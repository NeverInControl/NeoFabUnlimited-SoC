#ifndef ACCEL_PLATFORM_H
#define ACCEL_PLATFORM_H

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include "accel_packet.h"


/**
 * @brief Execute an acceleration task (Synchronous).
 *
 * @param packet Pointer to the constant accelerator manifest.
 * @param data   Pointer to the input/output data buffer in RAM.
 * @param len    Size of the data buffer in bytes.
 * @return 0 on success, negative error code on failure.
 */
int accel_execute(const accel_packet_t *packet, void *data, size_t len);

/**
 * @brief Check if the Acceleration Daemon is running and ready.
 */
bool accel_is_service_ready(void);

#endif /* ACCEL_PLATFORM_H */