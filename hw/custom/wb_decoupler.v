`timescale 1ns / 1ps

module wb_decoupler_bidir (
    input  wire        clk_i,
    input  wire        rst_i,

    // --- Control Interface (from eFPGA Manager) ---
    input  wire        decouple_req_i,
    input  wire        force_decouple_i,
    output wire        is_decoupled_o,
    
    // --- Debug Interface ---
    output wire        host_active_o, // Host is currently talking to FPGA
    output wire        dma_active_o,  // FPGA is currently talking to RAM

    // ===================================================================
    // CHANNEL 1: HOST -> FPGA (CPU reads/writes to FPGA CSRs)
    // ===================================================================
    
    // SLAVE PORT (Faces Host / Interconnect)
    input  wire [31:0] h2f_s_adr_i,
    input  wire [31:0] h2f_s_dat_i,
    input  wire [3:0]  h2f_s_sel_i,
    input  wire        h2f_s_we_i,
    input  wire        h2f_s_cyc_i,
    input  wire        h2f_s_stb_i,
    output wire [31:0] h2f_s_dat_o,
    output wire        h2f_s_ack_o,
    output wire        h2f_s_err_o,

    // MASTER PORT (Faces FPGA Slave)
    output wire [31:0] h2f_m_adr_o,
    output wire [31:0] h2f_m_dat_o,
    output wire [3:0]  h2f_m_sel_o,
    output wire        h2f_m_we_o,
    output wire        h2f_m_cyc_o,
    output wire        h2f_m_stb_o,
    input  wire [31:0] h2f_m_dat_i,
    input  wire        h2f_m_ack_i,
    input  wire        h2f_m_err_i,

    // ===================================================================
    // CHANNEL 2: FPGA -> HOST (FPGA DMA reads/writes to System RAM)
    // ===================================================================
    
    // SLAVE PORT (Faces eFPGA Master)
    input  wire [31:0] f2h_s_adr_i,
    input  wire [31:0] f2h_s_dat_i,
    input  wire [3:0]  f2h_s_sel_i,
    input  wire        f2h_s_we_i,
    input  wire        f2h_s_cyc_i,
    input  wire        f2h_s_stb_i,
    output wire [31:0] f2h_s_dat_o,
    output wire        f2h_s_ack_o,
    output wire        f2h_s_err_o,

    // MASTER PORT (Faces System RAM / Interconnect)
    output wire [31:0] f2h_m_adr_o,
    output wire [31:0] f2h_m_dat_o,
    output wire [3:0]  f2h_m_sel_o,
    output wire        f2h_m_we_o,
    output wire        f2h_m_cyc_o,
    output wire        f2h_m_stb_o,
    input  wire [31:0] f2h_m_dat_i,
    input  wire        f2h_m_ack_i,
    input  wire        f2h_m_err_i
);

    reg decoupled_reg;
    assign is_decoupled_o = decoupled_reg;

    // Debug Tracking
    assign host_active_o = h2f_s_cyc_i; // CPU holds bus open
    assign dma_active_o  = f2h_s_cyc_i; // FPGA holds bus open

    // Both directions must be idle to safely drop the shield
    wire is_safe = (~h2f_s_cyc_i) & (~f2h_s_cyc_i);

    always @(posedge clk_i) begin
        if (rst_i) begin
            decoupled_reg <= 1'b0;
        end else begin
            if (force_decouple_i) begin
                decoupled_reg <= 1'b1;
            end else if (decouple_req_i) begin
                if (is_safe) decoupled_reg <= 1'b1;
            end else begin
                decoupled_reg <= 1'b0;
            end
        end
    end

    // ===================================================================
    // CHANNEL 1 ROUTING (Host -> FPGA)
    // ===================================================================
    assign h2f_m_adr_o = decoupled_reg ? 32'b0 : h2f_s_adr_i;
    assign h2f_m_dat_o = decoupled_reg ? 32'b0 : h2f_s_dat_i;
    assign h2f_m_sel_o = decoupled_reg ?  4'b0 : h2f_s_sel_i;
    assign h2f_m_we_o  = decoupled_reg ?  1'b0 : h2f_s_we_i;
    assign h2f_m_cyc_o = decoupled_reg ?  1'b0 : h2f_s_cyc_i;
    assign h2f_m_stb_o = decoupled_reg ?  1'b0 : h2f_s_stb_i;

    assign h2f_s_dat_o = decoupled_reg ? 32'b0 : h2f_m_dat_i;
    assign h2f_s_ack_o = decoupled_reg ?  1'b0 : h2f_m_ack_i;
    
    // Abort CPU transactions with ERR if decoupled
    assign h2f_s_err_o = decoupled_reg ? h2f_s_cyc_i : h2f_m_err_i;

    // ===================================================================
    // CHANNEL 2 ROUTING (FPGA -> Host)
    // ===================================================================
    assign f2h_m_adr_o = decoupled_reg ? 32'b0 : f2h_s_adr_i;
    assign f2h_m_dat_o = decoupled_reg ? 32'b0 : f2h_s_dat_i;
    assign f2h_m_sel_o = decoupled_reg ?  4'b0 : f2h_s_sel_i;
    assign f2h_m_we_o  = decoupled_reg ?  1'b0 : f2h_s_we_i;
    assign f2h_m_cyc_o = decoupled_reg ?  1'b0 : f2h_s_cyc_i; // CRITICAL: Protects System RAM
    assign f2h_m_stb_o = decoupled_reg ?  1'b0 : f2h_s_stb_i;

    assign f2h_s_dat_o = decoupled_reg ? 32'b0 : f2h_m_dat_i;
    assign f2h_s_ack_o = decoupled_reg ?  1'b0 : f2h_m_ack_i;
    
    // Abort garbage FPGA transactions with ERR to clear its master state machine
    assign f2h_s_err_o = decoupled_reg ? f2h_s_cyc_i : f2h_m_err_i;
    
endmodule