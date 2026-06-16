
connect_debug_port u_ila_0/probe2 [get_nets [list {cpu_wb_adr[0]} {cpu_wb_adr[1]} {cpu_wb_adr[2]} {cpu_wb_adr[3]} {cpu_wb_adr[4]} {cpu_wb_adr[5]} {cpu_wb_adr[6]} {cpu_wb_adr[7]} {cpu_wb_adr[8]} {cpu_wb_adr[9]} {cpu_wb_adr[10]} {cpu_wb_adr[11]} {cpu_wb_adr[12]} {cpu_wb_adr[13]} {cpu_wb_adr[14]} {cpu_wb_adr[15]} {cpu_wb_adr[16]} {cpu_wb_adr[17]} {cpu_wb_adr[18]} {cpu_wb_adr[19]} {cpu_wb_adr[20]} {cpu_wb_adr[21]} {cpu_wb_adr[22]} {cpu_wb_adr[23]} {cpu_wb_adr[24]} {cpu_wb_adr[25]} {cpu_wb_adr[26]} {cpu_wb_adr[27]} {cpu_wb_adr[28]} {cpu_wb_adr[29]} {cpu_wb_adr[30]} {cpu_wb_adr[31]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list bram_wb_ack]]
connect_debug_port u_ila_0/probe4 [get_nets [list bram_wb_cyc]]
connect_debug_port u_ila_0/probe5 [get_nets [list cpu_wb_ack]]
connect_debug_port u_ila_0/probe10 [get_nets [list manager_wb_cyc]]
connect_debug_port u_ila_0/probe11 [get_nets [list manager_wb_stb]]
connect_debug_port u_ila_0/probe12 [get_nets [list manager_wb_we]]



create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_i_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {dec2arb_m_adr[0]} {dec2arb_m_adr[1]} {dec2arb_m_adr[2]} {dec2arb_m_adr[3]} {dec2arb_m_adr[4]} {dec2arb_m_adr[5]} {dec2arb_m_adr[6]} {dec2arb_m_adr[7]} {dec2arb_m_adr[8]} {dec2arb_m_adr[9]} {dec2arb_m_adr[10]} {dec2arb_m_adr[11]} {dec2arb_m_adr[12]} {dec2arb_m_adr[13]} {dec2arb_m_adr[14]} {dec2arb_m_adr[15]} {dec2arb_m_adr[16]} {dec2arb_m_adr[17]} {dec2arb_m_adr[18]} {dec2arb_m_adr[19]} {dec2arb_m_adr[20]} {dec2arb_m_adr[21]} {dec2arb_m_adr[22]} {dec2arb_m_adr[23]} {dec2arb_m_adr[24]} {dec2arb_m_adr[25]} {dec2arb_m_adr[26]} {dec2arb_m_adr[27]} {dec2arb_m_adr[28]} {dec2arb_m_adr[29]} {dec2arb_m_adr[30]} {dec2arb_m_adr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {dec2arb_m_dat_i[0]} {dec2arb_m_dat_i[1]} {dec2arb_m_dat_i[2]} {dec2arb_m_dat_i[3]} {dec2arb_m_dat_i[4]} {dec2arb_m_dat_i[5]} {dec2arb_m_dat_i[6]} {dec2arb_m_dat_i[7]} {dec2arb_m_dat_i[8]} {dec2arb_m_dat_i[9]} {dec2arb_m_dat_i[10]} {dec2arb_m_dat_i[11]} {dec2arb_m_dat_i[12]} {dec2arb_m_dat_i[13]} {dec2arb_m_dat_i[14]} {dec2arb_m_dat_i[15]} {dec2arb_m_dat_i[16]} {dec2arb_m_dat_i[17]} {dec2arb_m_dat_i[18]} {dec2arb_m_dat_i[19]} {dec2arb_m_dat_i[20]} {dec2arb_m_dat_i[21]} {dec2arb_m_dat_i[22]} {dec2arb_m_dat_i[23]} {dec2arb_m_dat_i[24]} {dec2arb_m_dat_i[25]} {dec2arb_m_dat_i[26]} {dec2arb_m_dat_i[27]} {dec2arb_m_dat_i[28]} {dec2arb_m_dat_i[29]} {dec2arb_m_dat_i[30]} {dec2arb_m_dat_i[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 4 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {dec2arb_m_sel[0]} {dec2arb_m_sel[1]} {dec2arb_m_sel[2]} {dec2arb_m_sel[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {dec2arb_m_dat_o[0]} {dec2arb_m_dat_o[1]} {dec2arb_m_dat_o[2]} {dec2arb_m_dat_o[3]} {dec2arb_m_dat_o[4]} {dec2arb_m_dat_o[5]} {dec2arb_m_dat_o[6]} {dec2arb_m_dat_o[7]} {dec2arb_m_dat_o[8]} {dec2arb_m_dat_o[9]} {dec2arb_m_dat_o[10]} {dec2arb_m_dat_o[11]} {dec2arb_m_dat_o[12]} {dec2arb_m_dat_o[13]} {dec2arb_m_dat_o[14]} {dec2arb_m_dat_o[15]} {dec2arb_m_dat_o[16]} {dec2arb_m_dat_o[17]} {dec2arb_m_dat_o[18]} {dec2arb_m_dat_o[19]} {dec2arb_m_dat_o[20]} {dec2arb_m_dat_o[21]} {dec2arb_m_dat_o[22]} {dec2arb_m_dat_o[23]} {dec2arb_m_dat_o[24]} {dec2arb_m_dat_o[25]} {dec2arb_m_dat_o[26]} {dec2arb_m_dat_o[27]} {dec2arb_m_dat_o[28]} {dec2arb_m_dat_o[29]} {dec2arb_m_dat_o[30]} {dec2arb_m_dat_o[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {fab2dec_m_adr[0]} {fab2dec_m_adr[1]} {fab2dec_m_adr[2]} {fab2dec_m_adr[3]} {fab2dec_m_adr[4]} {fab2dec_m_adr[5]} {fab2dec_m_adr[6]} {fab2dec_m_adr[7]} {fab2dec_m_adr[8]} {fab2dec_m_adr[9]} {fab2dec_m_adr[10]} {fab2dec_m_adr[11]} {fab2dec_m_adr[12]} {fab2dec_m_adr[13]} {fab2dec_m_adr[14]} {fab2dec_m_adr[15]} {fab2dec_m_adr[16]} {fab2dec_m_adr[17]} {fab2dec_m_adr[18]} {fab2dec_m_adr[19]} {fab2dec_m_adr[20]} {fab2dec_m_adr[21]} {fab2dec_m_adr[22]} {fab2dec_m_adr[23]} {fab2dec_m_adr[24]} {fab2dec_m_adr[25]} {fab2dec_m_adr[26]} {fab2dec_m_adr[27]} {fab2dec_m_adr[28]} {fab2dec_m_adr[29]} {fab2dec_m_adr[30]} {fab2dec_m_adr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {fab2dec_m_dat_i[0]} {fab2dec_m_dat_i[1]} {fab2dec_m_dat_i[2]} {fab2dec_m_dat_i[3]} {fab2dec_m_dat_i[4]} {fab2dec_m_dat_i[5]} {fab2dec_m_dat_i[6]} {fab2dec_m_dat_i[7]} {fab2dec_m_dat_i[8]} {fab2dec_m_dat_i[9]} {fab2dec_m_dat_i[10]} {fab2dec_m_dat_i[11]} {fab2dec_m_dat_i[12]} {fab2dec_m_dat_i[13]} {fab2dec_m_dat_i[14]} {fab2dec_m_dat_i[15]} {fab2dec_m_dat_i[16]} {fab2dec_m_dat_i[17]} {fab2dec_m_dat_i[18]} {fab2dec_m_dat_i[19]} {fab2dec_m_dat_i[20]} {fab2dec_m_dat_i[21]} {fab2dec_m_dat_i[22]} {fab2dec_m_dat_i[23]} {fab2dec_m_dat_i[24]} {fab2dec_m_dat_i[25]} {fab2dec_m_dat_i[26]} {fab2dec_m_dat_i[27]} {fab2dec_m_dat_i[28]} {fab2dec_m_dat_i[29]} {fab2dec_m_dat_i[30]} {fab2dec_m_dat_i[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 4 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {fab2dec_m_sel[0]} {fab2dec_m_sel[1]} {fab2dec_m_sel[2]} {fab2dec_m_sel[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 48 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {efpga_ram_d_o[0]} {efpga_ram_d_o[1]} {efpga_ram_d_o[2]} {efpga_ram_d_o[3]} {efpga_ram_d_o[4]} {efpga_ram_d_o[5]} {efpga_ram_d_o[6]} {efpga_ram_d_o[7]} {efpga_ram_d_o[8]} {efpga_ram_d_o[9]} {efpga_ram_d_o[10]} {efpga_ram_d_o[11]} {efpga_ram_d_o[12]} {efpga_ram_d_o[13]} {efpga_ram_d_o[14]} {efpga_ram_d_o[15]} {efpga_ram_d_o[16]} {efpga_ram_d_o[17]} {efpga_ram_d_o[18]} {efpga_ram_d_o[19]} {efpga_ram_d_o[20]} {efpga_ram_d_o[21]} {efpga_ram_d_o[22]} {efpga_ram_d_o[23]} {efpga_ram_d_o[24]} {efpga_ram_d_o[25]} {efpga_ram_d_o[26]} {efpga_ram_d_o[27]} {efpga_ram_d_o[28]} {efpga_ram_d_o[29]} {efpga_ram_d_o[30]} {efpga_ram_d_o[31]} {efpga_ram_d_o[32]} {efpga_ram_d_o[33]} {efpga_ram_d_o[34]} {efpga_ram_d_o[35]} {efpga_ram_d_o[36]} {efpga_ram_d_o[37]} {efpga_ram_d_o[38]} {efpga_ram_d_o[39]} {efpga_ram_d_o[40]} {efpga_ram_d_o[41]} {efpga_ram_d_o[42]} {efpga_ram_d_o[43]} {efpga_ram_d_o[44]} {efpga_ram_d_o[45]} {efpga_ram_d_o[46]} {efpga_ram_d_o[47]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {fab2dec_m_dat_o[0]} {fab2dec_m_dat_o[1]} {fab2dec_m_dat_o[2]} {fab2dec_m_dat_o[3]} {fab2dec_m_dat_o[4]} {fab2dec_m_dat_o[5]} {fab2dec_m_dat_o[6]} {fab2dec_m_dat_o[7]} {fab2dec_m_dat_o[8]} {fab2dec_m_dat_o[9]} {fab2dec_m_dat_o[10]} {fab2dec_m_dat_o[11]} {fab2dec_m_dat_o[12]} {fab2dec_m_dat_o[13]} {fab2dec_m_dat_o[14]} {fab2dec_m_dat_o[15]} {fab2dec_m_dat_o[16]} {fab2dec_m_dat_o[17]} {fab2dec_m_dat_o[18]} {fab2dec_m_dat_o[19]} {fab2dec_m_dat_o[20]} {fab2dec_m_dat_o[21]} {fab2dec_m_dat_o[22]} {fab2dec_m_dat_o[23]} {fab2dec_m_dat_o[24]} {fab2dec_m_dat_o[25]} {fab2dec_m_dat_o[26]} {fab2dec_m_dat_o[27]} {fab2dec_m_dat_o[28]} {fab2dec_m_dat_o[29]} {fab2dec_m_dat_o[30]} {fab2dec_m_dat_o[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 12 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {efpga_ram_c_o[0]} {efpga_ram_c_o[1]} {efpga_ram_c_o[2]} {efpga_ram_c_o[3]} {efpga_ram_c_o[4]} {efpga_ram_c_o[5]} {efpga_ram_c_o[6]} {efpga_ram_c_o[7]} {efpga_ram_c_o[8]} {efpga_ram_c_o[9]} {efpga_ram_c_o[10]} {efpga_ram_c_o[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 24 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {efpga_ram_a_o[0]} {efpga_ram_a_o[1]} {efpga_ram_a_o[2]} {efpga_ram_a_o[3]} {efpga_ram_a_o[4]} {efpga_ram_a_o[5]} {efpga_ram_a_o[6]} {efpga_ram_a_o[7]} {efpga_ram_a_o[8]} {efpga_ram_a_o[9]} {efpga_ram_a_o[10]} {efpga_ram_a_o[11]} {efpga_ram_a_o[12]} {efpga_ram_a_o[13]} {efpga_ram_a_o[14]} {efpga_ram_a_o[15]} {efpga_ram_a_o[16]} {efpga_ram_a_o[17]} {efpga_ram_a_o[18]} {efpga_ram_a_o[19]} {efpga_ram_a_o[20]} {efpga_ram_a_o[21]} {efpga_ram_a_o[22]} {efpga_ram_a_o[23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list dec2arb_m_ack]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list dec2arb_m_cyc]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list dec2arb_m_stb]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list dec2arb_m_we]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list fab2dec_m_ack]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list fab2dec_m_cyc]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list fab2dec_m_stb]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list fab2dec_m_we]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_i_IBUF_BUFG]
