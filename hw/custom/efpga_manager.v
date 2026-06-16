`timescale 1ns / 1ps

module efpga_manager #(
    parameter HW_VERSION = 32'hFAB00001
) (
    input  wire        clk_i,
    input  wire        rst_i,
    input  wire        wb_cyc_i,
    input  wire        wb_stb_i,
    input  wire        wb_we_i,
    input  wire [3:0]  wb_sel_i,
    input  wire [31:0] wb_adr_i,
    input  wire [31:0] wb_dat_i,
    output reg  [31:0] wb_dat_o,
    output reg         wb_ack_o,
    
    // --- Direct eFPGA Interfacing ---
    output reg  [31:0] efpga_config_data_o,
    output reg         efpga_config_we_o,
    
    // --- Hardware Status & Control ---
    output wire        efpga_soft_reset_o,
    input  wire        efpga_com_active_i,
    
    // --- Slot 0 Interfacing & Control ---
    input  wire [7:0]  slot0_i_top_i,
    output reg  [7:0]  slot0_o_top_o,
    output wire        decoupler0_req_o,
    output wire        decoupler0_force_o,
    input  wire        decoupler0_is_decoupled_i,
    input  wire        decoupler0_host_act_i,
    input  wire        decoupler0_dma_act_i
);

    reg [31:0] scratchpad_reg;
    reg [31:0] config_count_reg;
    
    // CSR Registers
    reg soft_reset_reg;
    reg was_reset_reg;
    reg com_active_q; 
    
    // Slot 0 Decoupler Registers
    reg dec0_req_reg;
    reg dec0_force_reg;

    assign decoupler0_req_o   = dec0_req_reg;
    assign decoupler0_force_o = dec0_force_reg;
    assign efpga_soft_reset_o = soft_reset_reg;

    always @(posedge clk_i) begin
        if (rst_i) begin
            scratchpad_reg      <= 32'h00000000;
            config_count_reg    <= 32'h00000000;
            efpga_config_data_o <= 32'h00000000;
            efpga_config_we_o   <= 1'b0;
            wb_ack_o            <= 1'b0;
            wb_dat_o            <= 32'h00000000;
            
            soft_reset_reg      <= 1'b0;
            was_reset_reg       <= 1'b1; 
            com_active_q        <= 1'b0;
            
            slot0_o_top_o  <= 8'h00;
            dec0_req_reg   <= 1'b1;
            dec0_force_reg <= 1'b0;
            
        end else begin
            wb_ack_o          <= 1'b0;
            efpga_config_we_o <= 1'b0;
            
            com_active_q <= efpga_com_active_i;
            
            if (soft_reset_reg) begin
                was_reset_reg <= 1'b1;
            end else if (com_active_q && !efpga_com_active_i) begin
                was_reset_reg <= 1'b0;
            end

            if (wb_cyc_i && wb_stb_i && !wb_ack_o) begin
                wb_ack_o <= 1'b1;

                if (wb_we_i) begin
                    // WRITE TRANSACTIONS
                    case (wb_adr_i[4:2])
                        3'b001: begin 
                            // 0x04: Control & Status
                            if (wb_sel_i[0]) begin 
                                soft_reset_reg <= wb_dat_i[0];
                                if (wb_dat_i[2] == 1'b0) begin
                                    was_reset_reg <= 1'b0;
                                end
                            end
                        end
                        3'b010: begin 
                            // 0x08: Config Data
                            config_count_reg    <= config_count_reg + 1;
                            efpga_config_data_o <= wb_dat_i;
                            efpga_config_we_o   <= 1'b1; 
                        end
                        3'b100: begin 
                            // 0x10: Scratchpad
                            if (wb_sel_i[0]) scratchpad_reg[7:0]   <= wb_dat_i[7:0];
                            if (wb_sel_i[1]) scratchpad_reg[15:8]  <= wb_dat_i[15:8];
                            if (wb_sel_i[2]) scratchpad_reg[23:16] <= wb_dat_i[23:16];
                            if (wb_sel_i[3]) scratchpad_reg[31:24] <= wb_dat_i[31:24];
                        end
                        3'b101: begin
                            // 0x14: Slot 0 Control
                            // wb_sel_i[0] protects the decoupler bits
                            if (wb_sel_i[0]) begin
                                dec0_req_reg   <= wb_dat_i[0];
                                dec0_force_reg <= wb_dat_i[1];
                            end
                            // wb_sel_i[3] protects the O_top pins
                            if (wb_sel_i[3]) begin
                                slot0_o_top_o  <= wb_dat_i[31:24];
                            end
                        end
                    endcase
                end else begin
                    // READ TRANSACTIONS
                    case (wb_adr_i[4:2])
                        3'b000: wb_dat_o <= HW_VERSION; // 0x00: Parameterized Version
                        3'b001: wb_dat_o <= {29'd0, was_reset_reg, efpga_com_active_i, soft_reset_reg}; // 0x04: CSR
                        3'b010: wb_dat_o <= 32'h00000000; // 0x08: Config Data (WO)
                        3'b011: wb_dat_o <= config_count_reg; // 0x0C: Config Count
                        3'b100: wb_dat_o <= scratchpad_reg;   // 0x10: Scratchpad
                        3'b101: begin
                            // 0x14: Slot 0 Control Readback
                            wb_dat_o <= {
                                slot0_o_top_o,               // [31:24]
                                slot0_i_top_i,               // [23:16]
                                11'd0,                       // [15:5] Reserved
                                decoupler0_dma_act_i,        // [4]
                                decoupler0_host_act_i,       // [3]
                                decoupler0_is_decoupled_i,   // [2]
                                dec0_force_reg,              // [1]
                                dec0_req_reg                 // [0]
                            };
                        end
                        default: wb_dat_o <= 32'hDEADDEAD;
                    endcase
                end
            end
        end
    end
endmodule