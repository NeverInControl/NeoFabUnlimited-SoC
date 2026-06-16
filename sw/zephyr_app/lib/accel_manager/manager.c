#include <zephyr/kernel.h>
#include <zephyr/device.h>
#include <zephyr/drivers/fpga.h>
#include <stdbool.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>

#include "accel_platform.h"
#include "accel_packet.h"
#include "fabulous.h" 

/* Include the Daemon's local generic binary blocks */
#include "efpga_header_raw.h"
#include "efpga_footer_raw.h"

#define MAX_SLOTS 4

/* Slot States */
enum slot_state {
    SLOT_FREE,
    SLOT_CONFIGURING,
    SLOT_BUSY
};

struct efpga_slot {
    int slot_idx;
    uintptr_t base_addr;
    uint32_t active_uuid;
    uint32_t last_used_timestamp; 
    volatile enum slot_state state;
    
    /* Worker Thread Communication */
    struct accel_work_item *current_job;
    int load_err; 
    struct k_sem job_ready_sem;
};

struct hw_version_entry {
    uint32_t version_id;
    uint32_t slot_count;
    uintptr_t slot_bases[MAX_SLOTS];
};

static const struct hw_version_entry hw_lookup[] = {
    {
        .version_id = 0xFAB00001, /* Single-Slot Demo */
        .slot_count = 1,
        .slot_bases = { 0x20000000 }
    },
    {
        .version_id = 0xFAB00002, /* Multi-Slot Target */
        .slot_count = 2,
        .slot_bases = { 0x20000000, 0x30000000 }
    }
};

/* Hardware State */
static struct efpga_slot slots[MAX_SLOTS];
static uint32_t current_slot_count = 0; 
static const struct device *fpga_dev = DEVICE_DT_GET(DT_NODELABEL(efpga));

/* OS State */
static bool service_initialized = false;
K_MSGQ_DEFINE(accel_msgq, sizeof(struct accel_work_item *), 10, 4);
static struct k_sem free_slots_sem; // Tracks how many slots are ready for work

struct accel_work_item {
    const accel_packet_t *packet;
    void *data;
    size_t len;
    struct k_sem done_signal;
    int status;
};

/* --- WORKER THREAD POOL DEFINITIONS --- */
K_THREAD_STACK_ARRAY_DEFINE(worker_stacks, MAX_SLOTS, 1024);
static struct k_thread worker_threads[MAX_SLOTS];

/* * =================================================================
 * THE WORKER THREAD (One instance runs per hardware slot)
 * =================================================================
 */
void slot_worker_thread(void *p1, void *p2, void *p3) {
    int slot_idx = (int)(intptr_t)p1;
    struct efpga_slot *slot = &slots[slot_idx];

    while (1) {
        /* Sleep until the Dispatcher gives us a job */
        k_sem_take(&slot->job_ready_sem, K_FOREVER);
        struct accel_work_item *work = slot->current_job;

        /* Execution Phase */
        if (slot->load_err == 0) {
            /* Run Hardware! */
            if (work->packet->hw_execute) {
                accel_context_t ctx = {
                    .dev = fpga_dev,
                    .slot_idx = slot->slot_idx,
                    .slot_base_addr = slot->base_addr
                };

                /* Pass the clean context pointer to the package */
                work->status = work->packet->hw_execute(&ctx, work->data, work->len); 
                
            } else {
                work->status = -ENOSYS; 
            }
        } else {
            /* Hardware failed to load, execute SW Fallback */
            if (work->packet->sw_fallback) {
                work->status = work->packet->sw_fallback(work->data, work->len);
            } else {
                work->status = -ENOSYS;
            }
        }

        /* Cleanup & State Reset */
        slot->last_used_timestamp = k_uptime_get_32();
        slot->current_job = NULL;
        slot->state = SLOT_FREE;

        /* Wake the User Application Thread */
        k_sem_give(&work->done_signal);

        /* Alert the Dispatcher that this slot is available again! */
        k_sem_give(&free_slots_sem);
    }
}

/* * =================================================================
 * THE DISPATCHER THREAD (The core Accelerator Manager)
 * =================================================================
 */
void accel_service_thread(void *p1, void *p2, void *p3) {
    if (!device_is_ready(fpga_dev)) return;

    /* --- HARDWARE DETECTION --- */
    const char *info_str = fpga_get_info(fpga_dev);
    uint32_t hw_version = 0;

    if (info_str != NULL) {
        const char *hex_ptr = strstr(info_str, "0x");
        if (hex_ptr != NULL) {
            hw_version = (uint32_t)strtoul(hex_ptr, NULL, 16);
        }
    }

    const struct hw_version_entry *matched_hw = NULL;
    for (size_t i = 0; i < sizeof(hw_lookup) / sizeof(hw_lookup[0]); i++) {
        if (hw_lookup[i].version_id == hw_version) {
            matched_hw = &hw_lookup[i];
            break;
        }
    }

    if (matched_hw == NULL) {
        printk("Daemon FATAL: Unsupported HW version (Parsed: 0x%08X)\n", hw_version);
        return; 
    }

    current_slot_count = matched_hw->slot_count;
    
    /* Initialize the Counting Semaphore with the number of discovered slots */
    k_sem_init(&free_slots_sem, current_slot_count, current_slot_count);

    /* Setup Slots and Spawn Worker Threads */
    for (uint32_t i = 0; i < current_slot_count; i++) {
        slots[i].slot_idx = i;
        slots[i].base_addr = matched_hw->slot_bases[i];
        slots[i].active_uuid = 0;
        slots[i].last_used_timestamp = k_uptime_get_32();
        slots[i].state = SLOT_FREE;
        k_sem_init(&slots[i].job_ready_sem, 0, 1);

        /* Spawn the dedicated worker thread for this slot */
        k_thread_create(&worker_threads[i], worker_stacks[i],
                        K_THREAD_STACK_SIZEOF(worker_stacks[i]),
                        slot_worker_thread,
                        (void *)(intptr_t)i, NULL, NULL,
                        5, 0, K_NO_WAIT);
    }

    printk("Daemon: Initialized %u parallel worker threads for HW 0x%08X\n", 
           current_slot_count, hw_version);

    service_initialized = true;

    /* --- THE RUNTIME DISPATCHER LOOP --- */
    while (1) {
        struct accel_work_item *work;
        
        /* Wait for a job to arrive */
        k_msgq_get(&accel_msgq, &work, K_FOREVER);

        /* Wait until AT LEAST ONE slot is free */
        k_sem_take(&free_slots_sem, K_FOREVER);

        /* Find the best FREE slot */
        int target_slot = -1;

        /* Cache Hit among FREE slots */
        for (int i = 0; i < current_slot_count; i++) {
            if (slots[i].state == SLOT_FREE && slots[i].active_uuid == work->packet->uuid) {
                target_slot = i;
                break;
            }
        }

        /* Cache Miss. Find the LRU FREE slot */
        if (target_slot == -1) {
            uint32_t oldest_time = 0xFFFFFFFF;
            for (int i = 0; i < current_slot_count; i++) {
                if (slots[i].state == SLOT_FREE) {
                    if (slots[i].last_used_timestamp < oldest_time) {
                        oldest_time = slots[i].last_used_timestamp;
                        target_slot = i;
                    }
                }
            }
        }

        /* Lock the slot so no other job grabs it */
        slots[target_slot].state = SLOT_CONFIGURING;
        int err = 0;
        bool need_reconfig = (slots[target_slot].active_uuid != work->packet->uuid);

        /* Load Bitstream (Protects the Wishbone bus via serial dispatcher thread) */
        if (need_reconfig) {
            if (current_slot_count == 1) { //For Demos only, this expects the Accelerator to have thefulöl bitstreaminstead of just for one slot
                err = fpga_load(fpga_dev, (uint32_t *)work->packet->bitstream, work->packet->bin_size);
            } else {
                struct efpga_fragment dynamic_chain[3];
                dynamic_chain[0].data = (const uint8_t *)efpga_header_bin;
                dynamic_chain[0].bin_size = efpga_header_bin_len;
                dynamic_chain[1].data = work->packet->bitstream;
                dynamic_chain[1].bin_size = work->packet->bin_size;
                dynamic_chain[2].data = (const uint8_t *)efpga_footer_bin;
                dynamic_chain[2].bin_size = efpga_footer_bin_len;

                err = efpga_fabulous_load_dynamic(fpga_dev, dynamic_chain, 3);
            }
            
            if (err == 0) slots[target_slot].active_uuid = work->packet->uuid;
        }

        /* Hand the job to the Worker and mark BUSY */
        slots[target_slot].current_job = work;
        slots[target_slot].load_err = err;
        slots[target_slot].state = SLOT_BUSY;
        
        k_sem_give(&slots[target_slot].job_ready_sem);
    }
}

int accel_execute(const accel_packet_t *packet, void *data, size_t len) {
    if (!packet || !data) return -EINVAL;
    if (!service_initialized) return -ENODEV;

    struct accel_work_item work;
    work.packet = packet;
    work.data = data;
    work.len = len;
    k_sem_init(&work.done_signal, 0, 1);

    struct accel_work_item *ptr = &work;
    k_msgq_put(&accel_msgq, &ptr, K_FOREVER);
    
    k_sem_take(&work.done_signal, K_FOREVER);

    return work.status;
}

bool accel_is_service_ready(void) { return service_initialized; }

K_THREAD_DEFINE(accel_service_tid, 1024, accel_service_thread, NULL, NULL, NULL, 5, 0, 0);