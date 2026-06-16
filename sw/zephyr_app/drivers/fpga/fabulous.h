/* efpga_fabulous.h */
#ifndef ZEPHYR_DRIVERS_FPGA_EFPGA_FABULOUS_H_
#define ZEPHYR_DRIVERS_FPGA_EFPGA_FABULOUS_H_

#include <zephyr/device.h>
#include <stdint.h>
#include <stddef.h>

struct efpga_fragment {
    const uint8_t *data; 
    size_t bin_size;
};

/**
 * @brief Custom hardware test for the FABulous Wishbone Manager.
 * * Writes a word to the scratchpad register and reads it back to verify
 * bus integrity before attempting bitstream configuration.
 * * @param dev Pointer to the eFPGA device structure.
 * @param test_value The 32-bit word to test the bus with.
 * @retval 0 If successful.
 * @retval -EIO If the readback does not match the test_value.
 */
int efpga_fabulous_test_scratchpad(const struct device *dev, uint32_t test_value);

/**
 * @brief Scatter-Gather Bitstream Loader.
 * Streams multiple bitstream fragments sequentially to the eFPGA without 
 * requiring contiguous RAM reallocation.
 * * @param dev Pointer to the eFPGA device structure.
 * @param fragments Array of fragment structures.
 * @param num_fragments The number of fragments in the array.
 * @retval 0 If successful.
 * @retval -EIO If the hardware word count doesn't match the expected count.
 */
int efpga_fabulous_load_dynamic(const struct device *dev, 
                                const struct efpga_fragment *fragments, 
                                size_t num_fragments);

/**
 * @brief Decoupler Control.
 * Decouples the FPGA Slot from the Wishbone interconnect
 * * @param dev Pointer to the eFPGA device structure.
 * @param decouple If the decoupler should decouple or recouple.
 * @param force Force decouple evenif transactions are pending.
 * @retval 0 If successful.
 * @retval -ETIMEDOUT If the transaction never concludes and save decoupling was not possible.
 */
int efpga_fabulous_set_decoupler(const struct device *dev, int slot_idx, bool decouple, bool force);

struct efpga_decoupler_state {
    bool req;
    bool force;
    bool is_dec;
    bool host_act;
    bool dma_act;
};

int efpga_fabulous_get_decoupler_state(const struct device *dev, int slot_idx, struct efpga_decoupler_state *state);

/**
 * @brief Write an 8-bit value to the fabric's O_top pins.
 */
int efpga_fabulous_write_io(const struct device *dev, int slot_idx, uint8_t val);

/**
 * @brief Read the current 8-bit state of the fabric's I_top pins.
 */
uint8_t efpga_fabulous_read_io(const struct device *dev, int slot_idx);

#endif /* ZEPHYR_DRIVERS_FPGA_EFPGA_FABULOUS_H_ */
