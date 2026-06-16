## Clock signal definition (100 MHz -> 10ns period)
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_i]

## 100 MHz Clock
set_property PACKAGE_PIN R4 [get_ports clk_i]
set_property IOSTANDARD LVCMOS33 [get_ports clk_i]

## Reset (Using Slide Switch 0: Up = Run, Down = Reset)
set_property PACKAGE_PIN E22 [get_ports rstn_i]
set_property IOSTANDARD LVCMOS12 [get_ports rstn_i]

## UART (USB RS-232 bridge)
# FPGA TX (AA19) connects to PC RX
set_property PACKAGE_PIN AA19 [get_ports uart0_txd_o]
set_property IOSTANDARD LVCMOS33 [get_ports uart0_txd_o]
# FPGA RX (V18) connects to PC TX
set_property PACKAGE_PIN V18 [get_ports uart0_rxd_i]
set_property IOSTANDARD LVCMOS33 [get_ports uart0_rxd_i]

## LEDs (gpio_o[7:0])
set_property PACKAGE_PIN T14 [get_ports {gpio_o[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gpio_o[0]}]
set_property PACKAGE_PIN T15 [get_ports {gpio_o[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gpio_o[1]}]
set_property PACKAGE_PIN T16 [get_ports {gpio_o[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gpio_o[2]}]
set_property PACKAGE_PIN U16 [get_ports {gpio_o[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gpio_o[3]}]
set_property PACKAGE_PIN V15 [get_ports {gpio_o[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gpio_o[4]}]
set_property PACKAGE_PIN W16 [get_ports {gpio_o[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gpio_o[5]}]
set_property PACKAGE_PIN W15 [get_ports {gpio_o[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gpio_o[6]}]
set_property PACKAGE_PIN Y13 [get_ports {gpio_o[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gpio_o[7]}]

# ------------------------------------------------------------------------
# eFPGA Fabric Constraints
# ------------------------------------------------------------------------
# Tell the DRC checker to treat loop errors as warnings
set_property SEVERITY {Warning} [get_drc_checks LUTLP-1]

# Explicitly allow combinatorial loops on all nets inside the fabric
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets -hierarchical -filter {NAME =~ *fabric_inst*}]

#set_disable_timing -from [all_inputs] -to [all_outputs] [get_cells fabric_inst/*]

set_false_path -through [get_pins fabric_inst/I_top*]
set_false_path -through [get_pins fabric_inst/O_top*]
set_false_path -through [get_pins fabric_inst/RAM2FAB*]
set_false_path -through [get_pins fabric_inst/FAB2RAM*]