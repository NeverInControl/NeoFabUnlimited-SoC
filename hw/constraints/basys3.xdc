## Clock signal definition (100 MHz -> 10ns period)
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk_i]

## 100 MHz Clock
set_property PACKAGE_PIN W5 [get_ports clk_i]							
set_property IOSTANDARD LVCMOS33 [get_ports clk_i]

## Reset (Using Slide Switch 0: Up = Run, Down = Reset)
set_property PACKAGE_PIN V17 [get_ports rstn_i]						
set_property IOSTANDARD LVCMOS33 [get_ports rstn_i]

## UART (USB RS-232 bridge)
# FPGA TX (A18) connects to PC RX
set_property PACKAGE_PIN A18 [get_ports uart0_txd_o]					
set_property IOSTANDARD LVCMOS33 [get_ports uart0_txd_o]
# FPGA RX (B18) connects to PC TX
set_property PACKAGE_PIN B18 [get_ports uart0_rxd_i]					
set_property IOSTANDARD LVCMOS33 [get_ports uart0_rxd_i]

## LEDs (gpio_o[7:0])
set_property PACKAGE_PIN U16 [get_ports {gpio_o[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[0]}]
set_property PACKAGE_PIN V19 [get_ports {gpio_o[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[1]}]
set_property PACKAGE_PIN W18 [get_ports {gpio_o[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[2]}]
set_property PACKAGE_PIN U15 [get_ports {gpio_o[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[3]}]
set_property PACKAGE_PIN U14 [get_ports {gpio_o[4]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[4]}]
set_property PACKAGE_PIN V14 [get_ports {gpio_o[5]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[5]}]
set_property PACKAGE_PIN V13 [get_ports {gpio_o[6]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[6]}]
set_property PACKAGE_PIN W13 [get_ports {gpio_o[7]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[7]}]