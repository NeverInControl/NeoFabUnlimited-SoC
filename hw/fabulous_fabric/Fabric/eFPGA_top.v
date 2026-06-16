module eFPGA_top
    #(
        parameter include_eFPGA=1,
        parameter NumberOfRows=3,
        parameter NumberOfCols=4,
        parameter FrameBitsPerRow=32,
        parameter MaxFramesPerCol=20,
        parameter desync_flag=20,
        parameter FrameSelectWidth=5,
        parameter RowSelectWidth=5
    )
    (
        //External IO port
        output  [11:0] A_config_C,
        output  [11:0] B_config_C,
        output  [11:0] Config_accessC,
        output  [5:0] I_top,
        input  [5:0] O_top,
        output  [5:0] T_top,
        //Config related ports
        input  CLK,
        input  resetn,
        input  SelfWriteStrobe,
        input  [31:0] SelfWriteData,
        input  Rx,
        output  ComActive,
        output  ReceiveLED,
        input  s_clk,
        input  s_data,
        
        input  [47:0] RAM2FAB_D_I,
        output [47:0] FAB2RAM_D_O,
        output [23:0] FAB2RAM_A_O,
        output [11:0] FAB2RAM_C_O
);
 //Signal declarations
wire[(NumberOfRows*FrameBitsPerRow)-1:0] FrameRegister;
wire[(MaxFramesPerCol*NumberOfCols)-1:0] FrameSelect;
wire[(FrameBitsPerRow*(NumberOfRows+2))-1:0] FrameData;
wire[FrameBitsPerRow-1:0] FrameAddressRegister;
wire LongFrameStrobe;
wire[31:0] LocalWriteData;
wire LocalWriteStrobe;
wire[RowSelectWidth-1:0] RowSelect;
`ifndef EMULATION

eFPGA_Config
    #(
    .RowSelectWidth(RowSelectWidth),
    .NumberOfRows(NumberOfRows),
    .desync_flag(desync_flag),
    .FrameBitsPerRow(FrameBitsPerRow)
    )
    eFPGA_Config_inst
    (
    .CLK(CLK),
    .resetn(resetn),
    .Rx(Rx),
    .ComActive(ComActive),
    .ReceiveLED(ReceiveLED),
    .s_clk(s_clk),
    .s_data(s_data),
    .SelfWriteData(SelfWriteData),
    .SelfWriteStrobe(SelfWriteStrobe),
    .ConfigWriteData(LocalWriteData),
    .ConfigWriteStrobe(LocalWriteStrobe),
    .FrameAddressRegister(FrameAddressRegister),
    .LongFrameStrobe(LongFrameStrobe),
    .RowSelect(RowSelect)
);


Frame_Data_Reg
    #(
    .FrameBitsPerRow(FrameBitsPerRow),
    .RowSelectWidth(RowSelectWidth),
    .Row(1)
    )
    inst_Frame_Data_Reg_0
    (
    .FrameData_I(LocalWriteData),
    .FrameData_O(FrameRegister[0*FrameBitsPerRow+FrameBitsPerRow-1:0*FrameBitsPerRow]),
    .RowSelect(RowSelect),
    .CLK(CLK)
);

Frame_Data_Reg
    #(
    .FrameBitsPerRow(FrameBitsPerRow),
    .RowSelectWidth(RowSelectWidth),
    .Row(2)
    )
    inst_Frame_Data_Reg_1
    (
    .FrameData_I(LocalWriteData),
    .FrameData_O(FrameRegister[1*FrameBitsPerRow+FrameBitsPerRow-1:1*FrameBitsPerRow]),
    .RowSelect(RowSelect),
    .CLK(CLK)
);

Frame_Data_Reg
    #(
    .FrameBitsPerRow(FrameBitsPerRow),
    .RowSelectWidth(RowSelectWidth),
    .Row(3)
    )
    inst_Frame_Data_Reg_2
    (
    .FrameData_I(LocalWriteData),
    .FrameData_O(FrameRegister[2*FrameBitsPerRow+FrameBitsPerRow-1:2*FrameBitsPerRow]),
    .RowSelect(RowSelect),
    .CLK(CLK)
);


Frame_Select
    #(
    .MaxFramesPerCol(MaxFramesPerCol),
    .FrameSelectWidth(FrameSelectWidth),
    .Col(0)
    )
    inst_Frame_Select_0
    (
    .FrameStrobe_I(FrameAddressRegister[MaxFramesPerCol-1:0]),
    .FrameStrobe_O(FrameSelect[0*MaxFramesPerCol+MaxFramesPerCol-1:0*MaxFramesPerCol]),
    .FrameSelect(FrameAddressRegister[FrameBitsPerRow-1:FrameBitsPerRow-FrameSelectWidth]),
    .FrameStrobe(LongFrameStrobe)
);

Frame_Select
    #(
    .MaxFramesPerCol(MaxFramesPerCol),
    .FrameSelectWidth(FrameSelectWidth),
    .Col(1)
    )
    inst_Frame_Select_1
    (
    .FrameStrobe_I(FrameAddressRegister[MaxFramesPerCol-1:0]),
    .FrameStrobe_O(FrameSelect[1*MaxFramesPerCol+MaxFramesPerCol-1:1*MaxFramesPerCol]),
    .FrameSelect(FrameAddressRegister[FrameBitsPerRow-1:FrameBitsPerRow-FrameSelectWidth]),
    .FrameStrobe(LongFrameStrobe)
);

Frame_Select
    #(
    .MaxFramesPerCol(MaxFramesPerCol),
    .FrameSelectWidth(FrameSelectWidth),
    .Col(2)
    )
    inst_Frame_Select_2
    (
    .FrameStrobe_I(FrameAddressRegister[MaxFramesPerCol-1:0]),
    .FrameStrobe_O(FrameSelect[2*MaxFramesPerCol+MaxFramesPerCol-1:2*MaxFramesPerCol]),
    .FrameSelect(FrameAddressRegister[FrameBitsPerRow-1:FrameBitsPerRow-FrameSelectWidth]),
    .FrameStrobe(LongFrameStrobe)
);

Frame_Select
    #(
    .MaxFramesPerCol(MaxFramesPerCol),
    .FrameSelectWidth(FrameSelectWidth),
    .Col(3)
    )
    inst_Frame_Select_3
    (
    .FrameStrobe_I(FrameAddressRegister[MaxFramesPerCol-1:0]),
    .FrameStrobe_O(FrameSelect[3*MaxFramesPerCol+MaxFramesPerCol-1:3*MaxFramesPerCol]),
    .FrameSelect(FrameAddressRegister[FrameBitsPerRow-1:FrameBitsPerRow-FrameSelectWidth]),
    .FrameStrobe(LongFrameStrobe)
);


`endif
eFPGA eFPGA_inst (
    .Tile_X0Y3_A_config_C_bit0(A_config_C[0]),
    .Tile_X0Y3_A_config_C_bit1(A_config_C[1]),
    .Tile_X0Y3_A_config_C_bit2(A_config_C[2]),
    .Tile_X0Y3_A_config_C_bit3(A_config_C[3]),
    .Tile_X0Y2_A_config_C_bit0(A_config_C[4]),
    .Tile_X0Y2_A_config_C_bit1(A_config_C[5]),
    .Tile_X0Y2_A_config_C_bit2(A_config_C[6]),
    .Tile_X0Y2_A_config_C_bit3(A_config_C[7]),
    .Tile_X0Y1_A_config_C_bit0(A_config_C[8]),
    .Tile_X0Y1_A_config_C_bit1(A_config_C[9]),
    .Tile_X0Y1_A_config_C_bit2(A_config_C[10]),
    .Tile_X0Y1_A_config_C_bit3(A_config_C[11]),
    .Tile_X0Y3_B_config_C_bit0(B_config_C[0]),
    .Tile_X0Y3_B_config_C_bit1(B_config_C[1]),
    .Tile_X0Y3_B_config_C_bit2(B_config_C[2]),
    .Tile_X0Y3_B_config_C_bit3(B_config_C[3]),
    .Tile_X0Y2_B_config_C_bit0(B_config_C[4]),
    .Tile_X0Y2_B_config_C_bit1(B_config_C[5]),
    .Tile_X0Y2_B_config_C_bit2(B_config_C[6]),
    .Tile_X0Y2_B_config_C_bit3(B_config_C[7]),
    .Tile_X0Y1_B_config_C_bit0(B_config_C[8]),
    .Tile_X0Y1_B_config_C_bit1(B_config_C[9]),
    .Tile_X0Y1_B_config_C_bit2(B_config_C[10]),
    .Tile_X0Y1_B_config_C_bit3(B_config_C[11]),
    .Tile_X3Y3_Config_accessC_bit0(Config_accessC[0]),
    .Tile_X3Y3_Config_accessC_bit1(Config_accessC[1]),
    .Tile_X3Y3_Config_accessC_bit2(Config_accessC[2]),
    .Tile_X3Y3_Config_accessC_bit3(Config_accessC[3]),
    .Tile_X3Y2_Config_accessC_bit0(Config_accessC[4]),
    .Tile_X3Y2_Config_accessC_bit1(Config_accessC[5]),
    .Tile_X3Y2_Config_accessC_bit2(Config_accessC[6]),
    .Tile_X3Y2_Config_accessC_bit3(Config_accessC[7]),
    .Tile_X3Y1_Config_accessC_bit0(Config_accessC[8]),
    .Tile_X3Y1_Config_accessC_bit1(Config_accessC[9]),
    .Tile_X3Y1_Config_accessC_bit2(Config_accessC[10]),
    .Tile_X3Y1_Config_accessC_bit3(Config_accessC[11]),
    .Tile_X3Y3_FAB2RAM_A0_O0(FAB2RAM_A_O[0]),
    .Tile_X3Y3_FAB2RAM_A0_O1(FAB2RAM_A_O[1]),
    .Tile_X3Y3_FAB2RAM_A0_O2(FAB2RAM_A_O[2]),
    .Tile_X3Y3_FAB2RAM_A0_O3(FAB2RAM_A_O[3]),
    .Tile_X3Y3_FAB2RAM_A1_O0(FAB2RAM_A_O[4]),
    .Tile_X3Y3_FAB2RAM_A1_O1(FAB2RAM_A_O[5]),
    .Tile_X3Y3_FAB2RAM_A1_O2(FAB2RAM_A_O[6]),
    .Tile_X3Y3_FAB2RAM_A1_O3(FAB2RAM_A_O[7]),
    .Tile_X3Y2_FAB2RAM_A0_O0(FAB2RAM_A_O[8]),
    .Tile_X3Y2_FAB2RAM_A0_O1(FAB2RAM_A_O[9]),
    .Tile_X3Y2_FAB2RAM_A0_O2(FAB2RAM_A_O[10]),
    .Tile_X3Y2_FAB2RAM_A0_O3(FAB2RAM_A_O[11]),
    .Tile_X3Y2_FAB2RAM_A1_O0(FAB2RAM_A_O[12]),
    .Tile_X3Y2_FAB2RAM_A1_O1(FAB2RAM_A_O[13]),
    .Tile_X3Y2_FAB2RAM_A1_O2(FAB2RAM_A_O[14]),
    .Tile_X3Y2_FAB2RAM_A1_O3(FAB2RAM_A_O[15]),
    .Tile_X3Y1_FAB2RAM_A0_O0(FAB2RAM_A_O[16]),
    .Tile_X3Y1_FAB2RAM_A0_O1(FAB2RAM_A_O[17]),
    .Tile_X3Y1_FAB2RAM_A0_O2(FAB2RAM_A_O[18]),
    .Tile_X3Y1_FAB2RAM_A0_O3(FAB2RAM_A_O[19]),
    .Tile_X3Y1_FAB2RAM_A1_O0(FAB2RAM_A_O[20]),
    .Tile_X3Y1_FAB2RAM_A1_O1(FAB2RAM_A_O[21]),
    .Tile_X3Y1_FAB2RAM_A1_O2(FAB2RAM_A_O[22]),
    .Tile_X3Y1_FAB2RAM_A1_O3(FAB2RAM_A_O[23]),
    .Tile_X3Y3_FAB2RAM_C_O0(FAB2RAM_C_O[0]),
    .Tile_X3Y3_FAB2RAM_C_O1(FAB2RAM_C_O[1]),
    .Tile_X3Y3_FAB2RAM_C_O2(FAB2RAM_C_O[2]),
    .Tile_X3Y3_FAB2RAM_C_O3(FAB2RAM_C_O[3]),
    .Tile_X3Y2_FAB2RAM_C_O0(FAB2RAM_C_O[4]),
    .Tile_X3Y2_FAB2RAM_C_O1(FAB2RAM_C_O[5]),
    .Tile_X3Y2_FAB2RAM_C_O2(FAB2RAM_C_O[6]),
    .Tile_X3Y2_FAB2RAM_C_O3(FAB2RAM_C_O[7]),
    .Tile_X3Y1_FAB2RAM_C_O0(FAB2RAM_C_O[8]),
    .Tile_X3Y1_FAB2RAM_C_O1(FAB2RAM_C_O[9]),
    .Tile_X3Y1_FAB2RAM_C_O2(FAB2RAM_C_O[10]),
    .Tile_X3Y1_FAB2RAM_C_O3(FAB2RAM_C_O[11]),
    .Tile_X3Y3_FAB2RAM_D0_O0(FAB2RAM_D_O[0]),
    .Tile_X3Y3_FAB2RAM_D0_O1(FAB2RAM_D_O[1]),
    .Tile_X3Y3_FAB2RAM_D0_O2(FAB2RAM_D_O[2]),
    .Tile_X3Y3_FAB2RAM_D0_O3(FAB2RAM_D_O[3]),
    .Tile_X3Y3_FAB2RAM_D1_O0(FAB2RAM_D_O[4]),
    .Tile_X3Y3_FAB2RAM_D1_O1(FAB2RAM_D_O[5]),
    .Tile_X3Y3_FAB2RAM_D1_O2(FAB2RAM_D_O[6]),
    .Tile_X3Y3_FAB2RAM_D1_O3(FAB2RAM_D_O[7]),
    .Tile_X3Y3_FAB2RAM_D2_O0(FAB2RAM_D_O[8]),
    .Tile_X3Y3_FAB2RAM_D2_O1(FAB2RAM_D_O[9]),
    .Tile_X3Y3_FAB2RAM_D2_O2(FAB2RAM_D_O[10]),
    .Tile_X3Y3_FAB2RAM_D2_O3(FAB2RAM_D_O[11]),
    .Tile_X3Y3_FAB2RAM_D3_O0(FAB2RAM_D_O[12]),
    .Tile_X3Y3_FAB2RAM_D3_O1(FAB2RAM_D_O[13]),
    .Tile_X3Y3_FAB2RAM_D3_O2(FAB2RAM_D_O[14]),
    .Tile_X3Y3_FAB2RAM_D3_O3(FAB2RAM_D_O[15]),
    .Tile_X3Y2_FAB2RAM_D0_O0(FAB2RAM_D_O[16]),
    .Tile_X3Y2_FAB2RAM_D0_O1(FAB2RAM_D_O[17]),
    .Tile_X3Y2_FAB2RAM_D0_O2(FAB2RAM_D_O[18]),
    .Tile_X3Y2_FAB2RAM_D0_O3(FAB2RAM_D_O[19]),
    .Tile_X3Y2_FAB2RAM_D1_O0(FAB2RAM_D_O[20]),
    .Tile_X3Y2_FAB2RAM_D1_O1(FAB2RAM_D_O[21]),
    .Tile_X3Y2_FAB2RAM_D1_O2(FAB2RAM_D_O[22]),
    .Tile_X3Y2_FAB2RAM_D1_O3(FAB2RAM_D_O[23]),
    .Tile_X3Y2_FAB2RAM_D2_O0(FAB2RAM_D_O[24]),
    .Tile_X3Y2_FAB2RAM_D2_O1(FAB2RAM_D_O[25]),
    .Tile_X3Y2_FAB2RAM_D2_O2(FAB2RAM_D_O[26]),
    .Tile_X3Y2_FAB2RAM_D2_O3(FAB2RAM_D_O[27]),
    .Tile_X3Y2_FAB2RAM_D3_O0(FAB2RAM_D_O[28]),
    .Tile_X3Y2_FAB2RAM_D3_O1(FAB2RAM_D_O[29]),
    .Tile_X3Y2_FAB2RAM_D3_O2(FAB2RAM_D_O[30]),
    .Tile_X3Y2_FAB2RAM_D3_O3(FAB2RAM_D_O[31]),
    .Tile_X3Y1_FAB2RAM_D0_O0(FAB2RAM_D_O[32]),
    .Tile_X3Y1_FAB2RAM_D0_O1(FAB2RAM_D_O[33]),
    .Tile_X3Y1_FAB2RAM_D0_O2(FAB2RAM_D_O[34]),
    .Tile_X3Y1_FAB2RAM_D0_O3(FAB2RAM_D_O[35]),
    .Tile_X3Y1_FAB2RAM_D1_O0(FAB2RAM_D_O[36]),
    .Tile_X3Y1_FAB2RAM_D1_O1(FAB2RAM_D_O[37]),
    .Tile_X3Y1_FAB2RAM_D1_O2(FAB2RAM_D_O[38]),
    .Tile_X3Y1_FAB2RAM_D1_O3(FAB2RAM_D_O[39]),
    .Tile_X3Y1_FAB2RAM_D2_O0(FAB2RAM_D_O[40]),
    .Tile_X3Y1_FAB2RAM_D2_O1(FAB2RAM_D_O[41]),
    .Tile_X3Y1_FAB2RAM_D2_O2(FAB2RAM_D_O[42]),
    .Tile_X3Y1_FAB2RAM_D2_O3(FAB2RAM_D_O[43]),
    .Tile_X3Y1_FAB2RAM_D3_O0(FAB2RAM_D_O[44]),
    .Tile_X3Y1_FAB2RAM_D3_O1(FAB2RAM_D_O[45]),
    .Tile_X3Y1_FAB2RAM_D3_O2(FAB2RAM_D_O[46]),
    .Tile_X3Y1_FAB2RAM_D3_O3(FAB2RAM_D_O[47]),
    .Tile_X0Y3_B_I_top(I_top[0]),
    .Tile_X0Y3_A_I_top(I_top[1]),
    .Tile_X0Y2_B_I_top(I_top[2]),
    .Tile_X0Y2_A_I_top(I_top[3]),
    .Tile_X0Y1_B_I_top(I_top[4]),
    .Tile_X0Y1_A_I_top(I_top[5]),
    .Tile_X0Y3_B_O_top(O_top[0]),
    .Tile_X0Y3_A_O_top(O_top[1]),
    .Tile_X0Y2_B_O_top(O_top[2]),
    .Tile_X0Y2_A_O_top(O_top[3]),
    .Tile_X0Y1_B_O_top(O_top[4]),
    .Tile_X0Y1_A_O_top(O_top[5]),
    .Tile_X3Y3_RAM2FAB_D0_I0(RAM2FAB_D_I[0]),
    .Tile_X3Y3_RAM2FAB_D0_I1(RAM2FAB_D_I[1]),
    .Tile_X3Y3_RAM2FAB_D0_I2(RAM2FAB_D_I[2]),
    .Tile_X3Y3_RAM2FAB_D0_I3(RAM2FAB_D_I[3]),
    .Tile_X3Y3_RAM2FAB_D1_I0(RAM2FAB_D_I[4]),
    .Tile_X3Y3_RAM2FAB_D1_I1(RAM2FAB_D_I[5]),
    .Tile_X3Y3_RAM2FAB_D1_I2(RAM2FAB_D_I[6]),
    .Tile_X3Y3_RAM2FAB_D1_I3(RAM2FAB_D_I[7]),
    .Tile_X3Y3_RAM2FAB_D2_I0(RAM2FAB_D_I[8]),
    .Tile_X3Y3_RAM2FAB_D2_I1(RAM2FAB_D_I[9]),
    .Tile_X3Y3_RAM2FAB_D2_I2(RAM2FAB_D_I[10]),
    .Tile_X3Y3_RAM2FAB_D2_I3(RAM2FAB_D_I[11]),
    .Tile_X3Y3_RAM2FAB_D3_I0(RAM2FAB_D_I[12]),
    .Tile_X3Y3_RAM2FAB_D3_I1(RAM2FAB_D_I[13]),
    .Tile_X3Y3_RAM2FAB_D3_I2(RAM2FAB_D_I[14]),
    .Tile_X3Y3_RAM2FAB_D3_I3(RAM2FAB_D_I[15]),
    .Tile_X3Y2_RAM2FAB_D0_I0(RAM2FAB_D_I[16]),
    .Tile_X3Y2_RAM2FAB_D0_I1(RAM2FAB_D_I[17]),
    .Tile_X3Y2_RAM2FAB_D0_I2(RAM2FAB_D_I[18]),
    .Tile_X3Y2_RAM2FAB_D0_I3(RAM2FAB_D_I[19]),
    .Tile_X3Y2_RAM2FAB_D1_I0(RAM2FAB_D_I[20]),
    .Tile_X3Y2_RAM2FAB_D1_I1(RAM2FAB_D_I[21]),
    .Tile_X3Y2_RAM2FAB_D1_I2(RAM2FAB_D_I[22]),
    .Tile_X3Y2_RAM2FAB_D1_I3(RAM2FAB_D_I[23]),
    .Tile_X3Y2_RAM2FAB_D2_I0(RAM2FAB_D_I[24]),
    .Tile_X3Y2_RAM2FAB_D2_I1(RAM2FAB_D_I[25]),
    .Tile_X3Y2_RAM2FAB_D2_I2(RAM2FAB_D_I[26]),
    .Tile_X3Y2_RAM2FAB_D2_I3(RAM2FAB_D_I[27]),
    .Tile_X3Y2_RAM2FAB_D3_I0(RAM2FAB_D_I[28]),
    .Tile_X3Y2_RAM2FAB_D3_I1(RAM2FAB_D_I[29]),
    .Tile_X3Y2_RAM2FAB_D3_I2(RAM2FAB_D_I[30]),
    .Tile_X3Y2_RAM2FAB_D3_I3(RAM2FAB_D_I[31]),
    .Tile_X3Y1_RAM2FAB_D0_I0(RAM2FAB_D_I[32]),
    .Tile_X3Y1_RAM2FAB_D0_I1(RAM2FAB_D_I[33]),
    .Tile_X3Y1_RAM2FAB_D0_I2(RAM2FAB_D_I[34]),
    .Tile_X3Y1_RAM2FAB_D0_I3(RAM2FAB_D_I[35]),
    .Tile_X3Y1_RAM2FAB_D1_I0(RAM2FAB_D_I[36]),
    .Tile_X3Y1_RAM2FAB_D1_I1(RAM2FAB_D_I[37]),
    .Tile_X3Y1_RAM2FAB_D1_I2(RAM2FAB_D_I[38]),
    .Tile_X3Y1_RAM2FAB_D1_I3(RAM2FAB_D_I[39]),
    .Tile_X3Y1_RAM2FAB_D2_I0(RAM2FAB_D_I[40]),
    .Tile_X3Y1_RAM2FAB_D2_I1(RAM2FAB_D_I[41]),
    .Tile_X3Y1_RAM2FAB_D2_I2(RAM2FAB_D_I[42]),
    .Tile_X3Y1_RAM2FAB_D2_I3(RAM2FAB_D_I[43]),
    .Tile_X3Y1_RAM2FAB_D3_I0(RAM2FAB_D_I[44]),
    .Tile_X3Y1_RAM2FAB_D3_I1(RAM2FAB_D_I[45]),
    .Tile_X3Y1_RAM2FAB_D3_I2(RAM2FAB_D_I[46]),
    .Tile_X3Y1_RAM2FAB_D3_I3(RAM2FAB_D_I[47]),
    .Tile_X0Y3_B_T_top(T_top[0]),
    .Tile_X0Y3_A_T_top(T_top[1]),
    .Tile_X0Y2_B_T_top(T_top[2]),
    .Tile_X0Y2_A_T_top(T_top[3]),
    .Tile_X0Y1_B_T_top(T_top[4]),
    .Tile_X0Y1_A_T_top(T_top[5]),
    .UserCLK(CLK),
    .FrameData(FrameData),
    .FrameStrobe(FrameSelect)
);

assign FrameData = {32'h12345678,FrameRegister,32'h12345678};
endmodule