#ifndef ACCEL_PACKET_H
#define ACCEL_PACKET_H

#include <stdint.h>
#include <stddef.h>


typedef struct {
    const struct device *dev; // The FPGA we are on (in case multiple exist)
    int slot_idx;             // The slot on that FPGA
    uintptr_t slot_base_addr; // Wishbone address of that slot
} accel_context_t;

typedef int (*accel_sw_cb_t)(void *data, size_t len);
typedef int (*accel_hw_cb_t)(accel_context_t *ctx, void *data, size_t len);

typedef struct {
    const char *name;
    uint32_t uuid;           
    
    /* Hardware Payload Pointers (expects 8-bit arrays) */
    const uint8_t *bitstream;
    size_t bin_size;
    
    accel_hw_cb_t hw_execute;
    uint32_t hw_latency_us;  
    
    /* Software Data */
    accel_sw_cb_t sw_fallback; 
    uint32_t sw_latency_us;  
} accel_packet_t;

#endif /* ACCEL_PACKET_H */