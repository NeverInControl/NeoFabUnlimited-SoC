#include "accel_packet.h"
#include <zephyr/kernel.h>
#include <zephyr/sys/sys_io.h>

/* Bitstream */
#include "add_bitstream_raw.h"

#define ADD_REG_A_OFFSET      0x00
#define ADD_REG_B_OFFSET      0x04
#define ADD_REG_RESULT_OFFSET 0x08

typedef struct {
    uint32_t a;
    uint32_t b;
    uint32_t result;
} add_dataset_t;

static int add_hw(accel_context_t *ctx, void *data, size_t len) {
    if (len != sizeof(add_dataset_t)) return -EINVAL; 
    add_dataset_t *io = (add_dataset_t *)data;

    sys_write32(io->a, ctx->slot_base_addr + ADD_REG_A_OFFSET);
    sys_write32(io->b, ctx->slot_base_addr + ADD_REG_B_OFFSET);
    io->result = sys_read32(ctx->slot_base_addr + ADD_REG_RESULT_OFFSET);

    return 0;
}

static int add_sw(void *data, size_t len) {
    if (len != sizeof(add_dataset_t)) return -EINVAL;
    add_dataset_t *io = (add_dataset_t *)data;
    
    io->result = io->a + io->b;
    return 0;
}

const accel_packet_t add_packet = {
    .name = "ADD32",
    .uuid = 0x1234,
    .bitstream = (const uint8_t *)add_bin,
    .bin_size = sizeof(add_bin),
    .hw_execute = add_hw,
    .sw_fallback = add_sw,
    .hw_latency_us = 10,
    .sw_latency_us = 200,
};