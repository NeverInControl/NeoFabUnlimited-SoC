#include "accel_packet.h"
#include <zephyr/kernel.h>
#include <zephyr/sys/sys_io.h>

/* Bitstream */
#include "dma_a.h"

#include "accel_dma_a.h"

static volatile uint32_t *dma_target = (volatile uint32_t *)0x0000F000;//only used for this dma

static int dma_hw(accel_context_t *ctx, void *data, size_t len) {
    efpga_fabulous_write_io(ctx->dev, ctx->slot_idx, 0x01); 
    k_msleep(1); 
    efpga_fabulous_write_io(ctx->dev, ctx->slot_idx, 0x00);
    return 0;
}

static int dma_sw(void *data, size_t len) {
    *dma_target = 0x50F7BEEF;//different to see change
    return 0;
}

const accel_packet_t dma_a_packet = {
    .name = "DMA_A",
    .uuid = 0x0000,
    .bitstream = (const uint8_t *)dma_a_bin,
    .bin_size = sizeof(dma_a_bin),
    .hw_execute = dma_hw,
    .sw_fallback = dma_sw,
    .hw_latency_us = 10,
    .sw_latency_us = 200,
};