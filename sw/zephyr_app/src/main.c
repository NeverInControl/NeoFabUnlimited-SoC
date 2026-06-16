#include <zephyr/kernel.h>
#include <zephyr/sys/sys_io.h>
#include <stdint.h>
#include <stdio.h>

#include <zephyr/drivers/fpga.h>
#include <zephyr/drivers/uart.h>
#include "fabulous.h"

#include "accel_platform.h"
#include "accels_registry.h"

// Safe-Zone target address - identical to the adress hardcoded in demo bitstream
volatile uint32_t *dma_target = (volatile uint32_t *)0x0000F000;

int main(void) {
    k_msleep(100);
    
    /* Get Devices */
    const struct device *efpga_dev = DEVICE_DT_GET(DT_NODELABEL(efpga));
    const struct device *uart_dev = DEVICE_DT_GET(DT_CHOSEN(zephyr_console));
    
    if (!device_is_ready(efpga_dev) || !device_is_ready(uart_dev)) {
        printk("FATAL: Devices not ready in Device Tree!\n");
        return -1;
    }

    /* Reset the Fabric */
    fpga_reset(efpga_dev);
    k_msleep(100);

    /* Initialize Target Memory */
    *dma_target = 0x00000000;

    /* State Variables */
    bool is_decoupled = true;
    bool is_forced = false;
    uint8_t current_o_top = 0x00;
    unsigned char key;

    // Start in a safe decoupled state, and ensure O_top is 0
    efpga_fabulous_set_decoupler(efpga_dev, 0, is_decoupled, is_forced);
    efpga_fabulous_write_io(efpga_dev, 0, current_o_top);

    /* Wait for daemon to be ready */
    while (!accel_is_service_ready()) {
        k_msleep(10);
    }

    /* The Interactive Dashboard Loop */
    while(1) {
        // Read hardware states via Driver APIs
        struct efpga_decoupler_state dec_state;
        efpga_fabulous_get_decoupler_state(efpga_dev, 0, &dec_state);
        
        uint8_t current_i_top = efpga_fabulous_read_io(efpga_dev, 0);

        // Decode the I_top flags defined in dma_a.v
        bool hw_alive = (current_i_top & 0x01);
        bool hw_done  = (current_i_top & 0x02);

        // Print Dashboard
        printk("\033[2J\033[H"); 
        printk("=========================================\n");
        printk("          DMA INTERACTIVE DEMO           \n");
        printk("=========================================\n\n");
        
        printk("Target RAM [0x0000F000]:  0x%08X\n\n", *dma_target);
        
        printk("Fabric IO Debug:\n");
        printk("  [O_top] CPU Cmds:  0x%02X\n", current_o_top);
        printk("  [I_top] HW Status: 0x%02X  | Alive: %s | DMA Done: %s\n\n", 
               current_i_top, 
               hw_alive ? "YES" : "NO", 
               hw_done ? "YES" : "NO");

        printk("Decoupler Status:\n");
        printk("  [State]  Decoupled: %s\n", dec_state.is_dec ? "YES (Safe)" : "NO (Live)");
        printk("  [Inputs] Requested: %d | Forced: %d\n", dec_state.req, dec_state.force);
        printk("  [Bus]    Host Busy: %d | DMA Busy: %d\n\n", dec_state.host_act, dec_state.dma_act);

        printk("-----------------------------------------\n");
        printk("Controls:\n");
        printk("  [d] Toggle Decoupler\n");
        printk("  [a] Load Bitstream\n");
        printk("  [s] Send START Pulse (Fires DMA)\n");
        printk("-----------------------------------------\n");

        // Poll for keystrokes asynchronously
        if (uart_poll_in(uart_dev, &key) == 0) {
            
            if (key == 'd') {
                is_decoupled = !is_decoupled;
                efpga_fabulous_set_decoupler(efpga_dev, 0, is_decoupled, is_forced);
            
            } else if (key == 'a') {
                if (!is_decoupled) {
                    is_decoupled = true;
                    efpga_fabulous_set_decoupler(efpga_dev, 0, is_decoupled, is_forced);
                }

                printk("\n>> Sending Job to Daemon...\n");
                
                // Clear memory so we can prove it works again
                *dma_target = 0x00000000;
                
                /* Use accel_execute instead of fpga_load */
                dma_job_t my_dma_job = { .status = 0 };
                int err = accel_execute(&dma_a_packet, &my_dma_job, sizeof(my_dma_job));
                
                if (err) {
                    printk(">> FATAL: Daemon job failed (%d)\n", err);
                } else {
                    printk(">> Daemon Job Complete! Bitstream Loaded.\n");
                }
                k_msleep(1000);
            
            } else if (key == 's') {
                printk("\n>> Pulsing START command...\n");
                
                // Assert Bit 0 (Puts hardware in reset/wait state)
                current_o_top |= 0x01;
                efpga_fabulous_write_io(efpga_dev, 0, current_o_top);
                k_msleep(10); 
                
                // Clear Bit 0 (Releases reset, DMA fires immediately)
                current_o_top &= ~0x01;
                efpga_fabulous_write_io(efpga_dev, 0, current_o_top);
                
                k_msleep(1000); 
            }
        }

        k_msleep(1000);
    }

    return 0;
}