#define DT_DRV_COMPAT fabulous_efpga_wishbone

#include <zephyr/kernel.h>
#include <zephyr/drivers/fpga.h>
#include "fabulous.h"
#include <zephyr/sys/sys_io.h>
#include <zephyr/device.h>
#include <stdio.h>

/* Register Offsets NEW*/
#define REG_VERSION_OFFSET      0x00
#define REG_CTRL_STATUS_OFFSET  0x04 
#define REG_CONFIG_DATA_OFFSET  0x08
#define REG_CONFIG_COUNT_OFFSET 0x0C
#define REG_SCRATCHPAD_OFFSET   0x10 
#define REG_SLOT0_CTRL_OFFSET   0x14 // Encompasses Decoupler and Debug IO

/* Macro to calculate slot offsets (Slot 0 = 0x14, Slot 1 = 0x18, etc.) */
#define REG_SLOT_CTRL_OFFSET(idx) (REG_SLOT0_CTRL_OFFSET + ((idx) * 4))

/* CSR Bitmasks */
#define EFPGA_CTRL_SOFT_RESET_BIT (1 << 0)  // R/W: Drive fabric reset
#define EFPGA_STAT_RECONFIG_BIT   (1 << 1)  // RO: Hardware ComActive
#define EFPGA_STAT_WAS_RESET_BIT  (1 << 2)  // RO: Hardware Reset State

/* Decoupler Bitmasks */
#define DECOUPLE_REQ_BIT      (1 << 0) // R/W: Standard safe decouple
#define DECOUPLE_FORCE_BIT    (1 << 1) // R/W: Force decouple (Abort)
#define DECOUPLE_IS_DEC_BIT   (1 << 2) // RO: Hardware confirms shield is UP
#define DECOUPLE_HOST_ACT_BIT (1 << 3) // RO: Host/CPU is asserting CYC
#define DECOUPLE_DMA_ACT_BIT  (1 << 4) // RO: FPGA DMA is asserting CY

/* Slot Debug Control IO Bitmasks and Shifts */
#define SLOT_CTRL_O_TOP_SHIFT 24
#define SLOT_CTRL_O_TOP_MASK  (0xFFU << SLOT_CTRL_O_TOP_SHIFT)

#define SLOT_CTRL_I_TOP_SHIFT 16
#define SLOT_CTRL_I_TOP_MASK  (0xFFU << SLOT_CTRL_I_TOP_SHIFT)

/* Hardware Version definitions */
#define HW_TARGET_MASK  0xFFF00000  // Isolates the top 3 hex characters
#define HW_TARGET_MAGIC 0xFAB00000  // The expected 'FAB' prefix

/* Static buffer for the get_info string */
static char efpga_info_str[32] = "FABulous Unknown";

/* Config structure (Read-only ROM) */
struct efpga_fabulous_config {
    uintptr_t base_addr;
};

/* Data structure (Mutable RAM) */
struct efpga_fabulous_data {
    uint32_t load_count;
    struct k_mutex lock;
};

static enum FPGA_status efpga_fabulous_get_status(const struct device *dev)
{
    const struct efpga_fabulous_config *config = dev->config;
    uint32_t csr = sys_read32(config->base_addr + REG_CTRL_STATUS_OFFSET);

    // If hardware says it is NOT reconfiguring, AND it is NOT in a reset state...
    if ((csr & EFPGA_STAT_RECONFIG_BIT) == 0 && (csr & EFPGA_STAT_WAS_RESET_BIT) == 0) {
        return FPGA_STATUS_ACTIVE;
    }
    return FPGA_STATUS_INACTIVE;
}

static int efpga_fabulous_reset(const struct device *dev)
{
    const struct efpga_fabulous_config *config = dev->config;
    struct efpga_fabulous_data *data = dev->data;
    uintptr_t base = config->base_addr;

    k_mutex_lock(&data->lock, K_FOREVER);

    uint32_t csr = sys_read32(base + REG_CTRL_STATUS_OFFSET);
    
    // Assert Soft Reset (Only modify Bit 0)
    sys_write32(csr | EFPGA_CTRL_SOFT_RESET_BIT, base + REG_CTRL_STATUS_OFFSET);
    
    k_msleep(1); // Give the fabric 1ms to flush
    
    // Deassert Soft Reset
    sys_write32(csr & ~EFPGA_CTRL_SOFT_RESET_BIT, base + REG_CTRL_STATUS_OFFSET);

    k_mutex_unlock(&data->lock);

    return 0;
}

static int efpga_fabulous_on(const struct device *dev)
{
    return -ENOTSUP; // Clock gating not supported
}

static int efpga_fabulous_off(const struct device *dev)
{
    return -ENOTSUP; // Clock gating not supported
}

static const char* efpga_fabulous_get_info(const struct device *dev)
{
    return efpga_info_str;
}

static int efpga_fabulous_init(const struct device *dev) {
    const struct efpga_fabulous_config *config = dev->config;
    if (config->base_addr == 0) {
        return -ENXIO; // No hardware address
    }

    // Verify the Hardware Manager is physically responding
    uint32_t version = sys_read32(config->base_addr + REG_VERSION_OFFSET);
    
    // Mask the bottom 20 bits to check if the top 12 bits spell "FAB"
    if ((version & HW_TARGET_MASK) != HW_TARGET_MAGIC) {
        printk("eFPGA: Init FAILED! Invalid HW Version: 0x%08X\n", version);
        return -EIO;
    }

    // Generate the info string dynamically for fpga_get_info()
    snprintf(efpga_info_str, sizeof(efpga_info_str), "FABulous HW: 0x%08X", version);

    struct efpga_fabulous_data *data = dev->data;
    k_mutex_init(&data->lock);

    printk("eFPGA: Driver initialized successfully at 0x%lx (%s)\n", config->base_addr, efpga_info_str);
    return 0;
}

/* Custom Driver Function: Verify Wishbone Read/Write integrity */
int efpga_fabulous_test_scratchpad(const struct device *dev, uint32_t test_value)
{
    const struct efpga_fabulous_config *config = dev->config;
    struct efpga_fabulous_data *data = dev->data;
    uintptr_t base = config->base_addr;

    k_mutex_lock(&data->lock, K_FOREVER);

    sys_write32(test_value, base + REG_SCRATCHPAD_OFFSET);
    uint32_t readback = sys_read32(base + REG_SCRATCHPAD_OFFSET);

    if (readback != test_value) {
        printk("eFPGA: Scratchpad test FAILED! Wrote 0x%08X, read 0x%08X\n", test_value, readback);
        k_mutex_unlock(&data->lock); // UNLOCK ON ERROR
        return -EIO;
    }
    
    printk("eFPGA: Scratchpad test OK! (0x%08X)\n", readback);

    k_mutex_unlock(&data->lock);
    
    return 0;
}

int efpga_fabulous_set_decoupler(const struct device *dev, int slot_idx, bool decouple, bool force)
{
    const struct efpga_fabulous_config *config = dev->config;
    struct efpga_fabulous_data *data = dev->data;
    uintptr_t base = config->base_addr;

    k_mutex_lock(&data->lock, K_FOREVER);

    uint32_t target_reg = base + REG_SLOT_CTRL_OFFSET(slot_idx);
    uint32_t val = sys_read32(target_reg);
    
    if (decouple) {
        if (force) {
            val |= DECOUPLE_FORCE_BIT;
            val &= ~DECOUPLE_REQ_BIT; 
        } else {
            val |= DECOUPLE_REQ_BIT;
            val &= ~DECOUPLE_FORCE_BIT;
        }
        sys_write32(val, target_reg);
        
        uint32_t status;
        int timeout = 100000;
        do {
            status = sys_read32(target_reg);
            timeout--;
        } while ((status & DECOUPLE_IS_DEC_BIT) == 0 && timeout > 0);

        if (timeout <= 0) {
            printk("eFPGA: WARNING! Decoupler hang! Host Active: %d, DMA Active: %d\n", 
                   (status & DECOUPLE_HOST_ACT_BIT) ? 1 : 0, 
                   (status & DECOUPLE_DMA_ACT_BIT) ? 1 : 0);
            k_mutex_unlock(&data->lock);
            return -ETIMEDOUT;
        }
    } else {
        val &= ~(DECOUPLE_REQ_BIT | DECOUPLE_FORCE_BIT);
        sys_write32(val, target_reg);
    }

    k_mutex_unlock(&data->lock);
    return 0;
}

int efpga_fabulous_get_decoupler_state(const struct device *dev, int slot_idx, struct efpga_decoupler_state *state)
{
    if (!state) return -EINVAL;

    const struct efpga_fabulous_config *config = dev->config;
    uintptr_t base = config->base_addr;

    /* Read the combined Control/IO register for the requested slot */
    uint32_t target_reg = base + REG_SLOT_CTRL_OFFSET(slot_idx);
    uint32_t val = sys_read32(target_reg);

    /* Map the bits to the struct */
    state->req      = (val & DECOUPLE_REQ_BIT) != 0;
    state->force    = (val & DECOUPLE_FORCE_BIT) != 0;
    state->is_dec   = (val & DECOUPLE_IS_DEC_BIT) != 0;
    state->host_act = (val & DECOUPLE_HOST_ACT_BIT) != 0;
    state->dma_act  = (val & DECOUPLE_DMA_ACT_BIT) != 0;

    return 0;
}

static int efpga_fabulous_load(const struct device *dev, uint32_t *image_ptr, size_t img_size)
{
    const struct efpga_fabulous_config *config = dev->config;
    struct efpga_fabulous_data *data = dev->data;
    uintptr_t base = config->base_addr;

    k_mutex_lock(&data->lock, K_FOREVER);

    printk("eFPGA: Loading bitstream at %p (size: %zu)\n", image_ptr, img_size);

    // Calculate number of 32-bit words to send
    uint32_t word_count = img_size / 4;
    if (img_size % 4 != 0) {
        word_count += 1; // Catch unaligned remainders
    }

    printk("eFPGA: Streaming %u words (%zu bytes) to Hardware Manager...\n", word_count, img_size);

    // Record the counter BEFORE we start
    uint32_t initial_count = sys_read32(base + REG_CONFIG_COUNT_OFFSET);

    // Cast the generic uint32_t pointer to a byte pointer to bypass RISC-V little-endian memory reads
    uint8_t *byte_ptr = (uint8_t *)image_ptr;
    
    for (uint32_t i = 0; i < word_count; i++) {
        size_t offset = i * 4;

        // Safely extract bytes; pad with 0x00 if we reach the end of the array
        uint8_t b0 = (offset + 0 < img_size) ? byte_ptr[offset + 0] : 0x00;
        uint8_t b1 = (offset + 1 < img_size) ? byte_ptr[offset + 1] : 0x00;
        uint8_t b2 = (offset + 2 < img_size) ? byte_ptr[offset + 2] : 0x00;
        uint8_t b3 = (offset + 3 < img_size) ? byte_ptr[offset + 3] : 0x00;

        uint32_t word = (b0 << 24) | (b1 << 16) | (b2 << 8) | b3;
        
        sys_write32(word, base + REG_CONFIG_DATA_OFFSET);
    }

    // Verify the hardware received everything
    uint32_t final_count = sys_read32(base + REG_CONFIG_COUNT_OFFSET);
    uint32_t words_written = final_count - initial_count;

    if (words_written != word_count) {
        printk("eFPGA: Hardware stream FAILED! Sent %u words, Manager counted %u\n", word_count, words_written);
        k_mutex_unlock(&data->lock); // UNLOCK ON ERROR
        return -EIO;
    }

    /* Softwarefix for the fact the hardware does not accuratly report reconfiguration */
    uint32_t csr = sys_read32(base + REG_CTRL_STATUS_OFFSET);
    csr &= ~EFPGA_STAT_WAS_RESET_BIT;
    sys_write32(csr, base + REG_CTRL_STATUS_OFFSET);

    printk("eFPGA: Hardware stream verified! Manager confirmed %u words.\n", words_written);
    
    data->load_count++;

    k_mutex_unlock(&data->lock);

    return 0;
}

int efpga_fabulous_load_dynamic(const struct device *dev, 
                                const struct efpga_fragment *fragments, 
                                size_t num_fragments)
{
    const struct efpga_fabulous_config *config = dev->config;
    struct efpga_fabulous_data *data = dev->data;
    uintptr_t base = config->base_addr;

    k_mutex_lock(&data->lock, K_FOREVER);

    uint32_t total_words_expected = 0;

    // Pre-calculate the total number of words about to be send
    for (size_t f = 0; f < num_fragments; f++) {
        uint32_t words = fragments[f].bin_size / 4;
        if (fragments[f].bin_size % 4 != 0) {
            words += 1;
        }
        total_words_expected += words;
    }

    printk("eFPGA: Dynamic load started. %zu fragments, %u total words expected.\n", 
           num_fragments, total_words_expected);

    // Record the hardware counter BEFORE start
    uint32_t initial_count = sys_read32(base + REG_CONFIG_COUNT_OFFSET);

    // Scatter-Gather Deployment Loop
    for (size_t f = 0; f < num_fragments; f++) {
        uint8_t *byte_ptr = (uint8_t *)fragments[f].data;
        size_t img_size = fragments[f].bin_size;
        
        uint32_t word_count = img_size / 4;
        if (img_size % 4 != 0) {
            word_count += 1;
        }

        for (uint32_t i = 0; i < word_count; i++) {
            size_t offset = i * 4;

            uint8_t b0 = (offset + 0 < img_size) ? byte_ptr[offset + 0] : 0x00;
            uint8_t b1 = (offset + 1 < img_size) ? byte_ptr[offset + 1] : 0x00;
            uint8_t b2 = (offset + 2 < img_size) ? byte_ptr[offset + 2] : 0x00;
            uint8_t b3 = (offset + 3 < img_size) ? byte_ptr[offset + 3] : 0x00;

            uint32_t word = (b0 << 24) | (b1 << 16) | (b2 << 8) | b3;
            
            sys_write32(word, base + REG_CONFIG_DATA_OFFSET);
        }
    }

    // Verify the hardware received everything across all fragments
    uint32_t final_count = sys_read32(base + REG_CONFIG_COUNT_OFFSET);
    uint32_t words_written = final_count - initial_count;

    if (words_written != total_words_expected) {
        printk("eFPGA: Dynamic stream FAILED! Sent %u words, Manager counted %u\n", 
               total_words_expected, words_written);
        k_mutex_unlock(&data->lock);
        return -EIO;
    }

    /* Softwarefix for the fact the hardware does not accuratly report reconfiguration */
    uint32_t csr = sys_read32(base + REG_CTRL_STATUS_OFFSET);
    csr &= ~EFPGA_STAT_WAS_RESET_BIT;
    sys_write32(csr, base + REG_CTRL_STATUS_OFFSET);

    printk("eFPGA: Dynamic stream verified! Manager confirmed %u words.\n", words_written);
    
    data->load_count++;

    k_mutex_unlock(&data->lock);

    return 0;
}

int efpga_fabulous_write_io(const struct device *dev, int slot_idx, uint8_t val)
{
    const struct efpga_fabulous_config *config = dev->config;
    struct efpga_fabulous_data *data = dev->data;
    uintptr_t base = config->base_addr;

    uint32_t target_reg = base + REG_SLOT_CTRL_OFFSET(slot_idx);

    k_mutex_lock(&data->lock, K_FOREVER);

    // Read-Modify-Write to preserve decoupler state
    uint32_t reg = sys_read32(target_reg);
    
    reg &= ~SLOT_CTRL_O_TOP_MASK; // Safely clear only the O_top bits
    reg |= ((uint32_t)val << SLOT_CTRL_O_TOP_SHIFT); // Insert the new value
    
    sys_write32(reg, target_reg);

    k_mutex_unlock(&data->lock);

    return 0;
}

uint8_t efpga_fabulous_read_io(const struct device *dev, int slot_idx)
{
    const struct efpga_fabulous_config *config = dev->config;
    uintptr_t base = config->base_addr;

    uint32_t target_reg = base + REG_SLOT_CTRL_OFFSET(slot_idx);

    uint32_t reg = sys_read32(target_reg);
    
    // Mask out the I_top bits and shift them down to a clean 8-bit integer
    return (uint8_t)((reg & SLOT_CTRL_I_TOP_MASK) >> SLOT_CTRL_I_TOP_SHIFT);
}

static const struct fpga_driver_api efpga_fabulous_api = {
    .load       = efpga_fabulous_load,
    .get_status = efpga_fabulous_get_status,
    .reset      = efpga_fabulous_reset,
    .on         = efpga_fabulous_on,
    .off        = efpga_fabulous_off,
    .get_info   = efpga_fabulous_get_info,
};

#define EFPGA_FAB_INIT(inst)                                            \
    static struct efpga_fabulous_data efpga_data_##inst;            \
                                                                        \
    static const struct efpga_fabulous_config efpga_config_##inst = { \
        .base_addr = DT_INST_REG_ADDR(inst),                        \
    };                                                              \
                                                                        \
    DEVICE_DT_INST_DEFINE(inst,                                     \
                        efpga_fabulous_init,                        \
                        NULL,                                       \
                        &efpga_data_##inst,                         \
                        &efpga_config_##inst,                       \
                        POST_KERNEL,                                \
                        CONFIG_FPGA_INIT_PRIORITY,                  \
                        &efpga_fabulous_api);

DT_INST_FOREACH_STATUS_OKAY(EFPGA_FAB_INIT)