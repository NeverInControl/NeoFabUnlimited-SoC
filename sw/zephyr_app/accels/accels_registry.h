#ifndef ACCEL_REGISTRY_H
#define ACCEL_REGISTRY_H

#include "accel_packet.h"

/* * List all available accelerator manifests here.
 * This allows main.c to just include this one header 
 * to see every available feature.
 */
#include "accel_dma_a.h"
extern const accel_packet_t add_packet;
extern const accel_packet_t dma_a_packet;

#endif
