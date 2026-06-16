module eFPGA
    #(
        parameter MaxFramesPerCol=20,
        parameter FrameBitsPerRow=32
    )
    (
        input  Tile_X0Y1_A_O_top, //EXTERNAL
        output  Tile_X0Y1_A_I_top, //EXTERNAL
        output  Tile_X0Y1_A_T_top, //EXTERNAL
        input  Tile_X0Y1_B_O_top, //EXTERNAL
        output  Tile_X0Y1_B_I_top, //EXTERNAL
        output  Tile_X0Y1_B_T_top, //EXTERNAL
        output  Tile_X0Y1_A_config_C_bit0, //EXTERNAL
        output  Tile_X0Y1_A_config_C_bit1, //EXTERNAL
        output  Tile_X0Y1_A_config_C_bit2, //EXTERNAL
        output  Tile_X0Y1_A_config_C_bit3, //EXTERNAL
        output  Tile_X0Y1_B_config_C_bit0, //EXTERNAL
        output  Tile_X0Y1_B_config_C_bit1, //EXTERNAL
        output  Tile_X0Y1_B_config_C_bit2, //EXTERNAL
        output  Tile_X0Y1_B_config_C_bit3, //EXTERNAL
        input  Tile_X3Y1_RAM2FAB_D0_I0, //EXTERNAL
        input  Tile_X3Y1_RAM2FAB_D0_I1, //EXTERNAL
        input  Tile_X3Y1_RAM2FAB_D0_I2, //EXTERNAL
        input  Tile_X3Y1_RAM2FAB_D0_I3, //EXTERNAL
        input  Tile_X3Y1_RAM2FAB_D1_I0, //EXTERNAL
        input  Tile_X3Y1_RAM2FAB_D1_I1, //EXTERNAL
        input  Tile_X3Y1_RAM2FAB_D1_I2, //EXTERNAL
        input  Tile_X3Y1_RAM2FAB_D1_I3, //EXTERNAL
        input  Tile_X3Y1_RAM2FAB_D2_I0, //EXTERNAL
        input  Tile_X3Y1_RAM2FAB_D2_I1, //EXTERNAL
        input  Tile_X3Y1_RAM2FAB_D2_I2, //EXTERNAL
        input  Tile_X3Y1_RAM2FAB_D2_I3, //EXTERNAL
        input  Tile_X3Y1_RAM2FAB_D3_I0, //EXTERNAL
        input  Tile_X3Y1_RAM2FAB_D3_I1, //EXTERNAL
        input  Tile_X3Y1_RAM2FAB_D3_I2, //EXTERNAL
        input  Tile_X3Y1_RAM2FAB_D3_I3, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_D0_O0, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_D0_O1, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_D0_O2, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_D0_O3, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_D1_O0, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_D1_O1, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_D1_O2, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_D1_O3, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_D2_O0, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_D2_O1, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_D2_O2, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_D2_O3, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_D3_O0, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_D3_O1, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_D3_O2, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_D3_O3, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_A0_O0, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_A0_O1, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_A0_O2, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_A0_O3, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_A1_O0, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_A1_O1, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_A1_O2, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_A1_O3, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_C_O0, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_C_O1, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_C_O2, //EXTERNAL
        output  Tile_X3Y1_FAB2RAM_C_O3, //EXTERNAL
        output  Tile_X3Y1_Config_accessC_bit0, //EXTERNAL
        output  Tile_X3Y1_Config_accessC_bit1, //EXTERNAL
        output  Tile_X3Y1_Config_accessC_bit2, //EXTERNAL
        output  Tile_X3Y1_Config_accessC_bit3, //EXTERNAL
        input  Tile_X0Y2_A_O_top, //EXTERNAL
        output  Tile_X0Y2_A_I_top, //EXTERNAL
        output  Tile_X0Y2_A_T_top, //EXTERNAL
        input  Tile_X0Y2_B_O_top, //EXTERNAL
        output  Tile_X0Y2_B_I_top, //EXTERNAL
        output  Tile_X0Y2_B_T_top, //EXTERNAL
        output  Tile_X0Y2_A_config_C_bit0, //EXTERNAL
        output  Tile_X0Y2_A_config_C_bit1, //EXTERNAL
        output  Tile_X0Y2_A_config_C_bit2, //EXTERNAL
        output  Tile_X0Y2_A_config_C_bit3, //EXTERNAL
        output  Tile_X0Y2_B_config_C_bit0, //EXTERNAL
        output  Tile_X0Y2_B_config_C_bit1, //EXTERNAL
        output  Tile_X0Y2_B_config_C_bit2, //EXTERNAL
        output  Tile_X0Y2_B_config_C_bit3, //EXTERNAL
        input  Tile_X3Y2_RAM2FAB_D0_I0, //EXTERNAL
        input  Tile_X3Y2_RAM2FAB_D0_I1, //EXTERNAL
        input  Tile_X3Y2_RAM2FAB_D0_I2, //EXTERNAL
        input  Tile_X3Y2_RAM2FAB_D0_I3, //EXTERNAL
        input  Tile_X3Y2_RAM2FAB_D1_I0, //EXTERNAL
        input  Tile_X3Y2_RAM2FAB_D1_I1, //EXTERNAL
        input  Tile_X3Y2_RAM2FAB_D1_I2, //EXTERNAL
        input  Tile_X3Y2_RAM2FAB_D1_I3, //EXTERNAL
        input  Tile_X3Y2_RAM2FAB_D2_I0, //EXTERNAL
        input  Tile_X3Y2_RAM2FAB_D2_I1, //EXTERNAL
        input  Tile_X3Y2_RAM2FAB_D2_I2, //EXTERNAL
        input  Tile_X3Y2_RAM2FAB_D2_I3, //EXTERNAL
        input  Tile_X3Y2_RAM2FAB_D3_I0, //EXTERNAL
        input  Tile_X3Y2_RAM2FAB_D3_I1, //EXTERNAL
        input  Tile_X3Y2_RAM2FAB_D3_I2, //EXTERNAL
        input  Tile_X3Y2_RAM2FAB_D3_I3, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_D0_O0, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_D0_O1, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_D0_O2, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_D0_O3, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_D1_O0, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_D1_O1, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_D1_O2, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_D1_O3, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_D2_O0, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_D2_O1, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_D2_O2, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_D2_O3, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_D3_O0, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_D3_O1, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_D3_O2, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_D3_O3, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_A0_O0, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_A0_O1, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_A0_O2, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_A0_O3, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_A1_O0, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_A1_O1, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_A1_O2, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_A1_O3, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_C_O0, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_C_O1, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_C_O2, //EXTERNAL
        output  Tile_X3Y2_FAB2RAM_C_O3, //EXTERNAL
        output  Tile_X3Y2_Config_accessC_bit0, //EXTERNAL
        output  Tile_X3Y2_Config_accessC_bit1, //EXTERNAL
        output  Tile_X3Y2_Config_accessC_bit2, //EXTERNAL
        output  Tile_X3Y2_Config_accessC_bit3, //EXTERNAL
        input  Tile_X0Y3_A_O_top, //EXTERNAL
        output  Tile_X0Y3_A_I_top, //EXTERNAL
        output  Tile_X0Y3_A_T_top, //EXTERNAL
        input  Tile_X0Y3_B_O_top, //EXTERNAL
        output  Tile_X0Y3_B_I_top, //EXTERNAL
        output  Tile_X0Y3_B_T_top, //EXTERNAL
        output  Tile_X0Y3_A_config_C_bit0, //EXTERNAL
        output  Tile_X0Y3_A_config_C_bit1, //EXTERNAL
        output  Tile_X0Y3_A_config_C_bit2, //EXTERNAL
        output  Tile_X0Y3_A_config_C_bit3, //EXTERNAL
        output  Tile_X0Y3_B_config_C_bit0, //EXTERNAL
        output  Tile_X0Y3_B_config_C_bit1, //EXTERNAL
        output  Tile_X0Y3_B_config_C_bit2, //EXTERNAL
        output  Tile_X0Y3_B_config_C_bit3, //EXTERNAL
        input  Tile_X3Y3_RAM2FAB_D0_I0, //EXTERNAL
        input  Tile_X3Y3_RAM2FAB_D0_I1, //EXTERNAL
        input  Tile_X3Y3_RAM2FAB_D0_I2, //EXTERNAL
        input  Tile_X3Y3_RAM2FAB_D0_I3, //EXTERNAL
        input  Tile_X3Y3_RAM2FAB_D1_I0, //EXTERNAL
        input  Tile_X3Y3_RAM2FAB_D1_I1, //EXTERNAL
        input  Tile_X3Y3_RAM2FAB_D1_I2, //EXTERNAL
        input  Tile_X3Y3_RAM2FAB_D1_I3, //EXTERNAL
        input  Tile_X3Y3_RAM2FAB_D2_I0, //EXTERNAL
        input  Tile_X3Y3_RAM2FAB_D2_I1, //EXTERNAL
        input  Tile_X3Y3_RAM2FAB_D2_I2, //EXTERNAL
        input  Tile_X3Y3_RAM2FAB_D2_I3, //EXTERNAL
        input  Tile_X3Y3_RAM2FAB_D3_I0, //EXTERNAL
        input  Tile_X3Y3_RAM2FAB_D3_I1, //EXTERNAL
        input  Tile_X3Y3_RAM2FAB_D3_I2, //EXTERNAL
        input  Tile_X3Y3_RAM2FAB_D3_I3, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_D0_O0, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_D0_O1, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_D0_O2, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_D0_O3, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_D1_O0, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_D1_O1, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_D1_O2, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_D1_O3, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_D2_O0, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_D2_O1, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_D2_O2, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_D2_O3, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_D3_O0, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_D3_O1, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_D3_O2, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_D3_O3, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_A0_O0, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_A0_O1, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_A0_O2, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_A0_O3, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_A1_O0, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_A1_O1, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_A1_O2, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_A1_O3, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_C_O0, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_C_O1, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_C_O2, //EXTERNAL
        output  Tile_X3Y3_FAB2RAM_C_O3, //EXTERNAL
        output  Tile_X3Y3_Config_accessC_bit0, //EXTERNAL
        output  Tile_X3Y3_Config_accessC_bit1, //EXTERNAL
        output  Tile_X3Y3_Config_accessC_bit2, //EXTERNAL
        output  Tile_X3Y3_Config_accessC_bit3, //EXTERNAL
        input  [(FrameBitsPerRow*5)-1:0] FrameData, //CONFIG_PORT
        input  [(MaxFramesPerCol*4)-1:0] FrameStrobe, //CONFIG_PORT
        input  UserCLK
);

 //signal declarations

wire Tile_X0Y0_UserCLKo;
wire Tile_X1Y0_UserCLKo;
wire Tile_X2Y0_UserCLKo;
wire Tile_X3Y0_UserCLKo;
wire Tile_X0Y1_UserCLKo;
wire Tile_X1Y1_UserCLKo;
wire Tile_X2Y1_UserCLKo;
wire Tile_X3Y1_UserCLKo;
wire Tile_X0Y2_UserCLKo;
wire Tile_X1Y2_UserCLKo;
wire Tile_X2Y2_UserCLKo;
wire Tile_X3Y2_UserCLKo;
wire Tile_X0Y3_UserCLKo;
wire Tile_X1Y3_UserCLKo;
wire Tile_X2Y3_UserCLKo;
wire Tile_X3Y3_UserCLKo;
wire Tile_X0Y4_UserCLKo;
wire Tile_X1Y4_UserCLKo;
wire Tile_X2Y4_UserCLKo;
wire Tile_X3Y4_UserCLKo;
 //configuration signal declarations

wire[FrameBitsPerRow -1:0] Row_Y0_FrameData;
wire[FrameBitsPerRow -1:0] Row_Y1_FrameData;
wire[FrameBitsPerRow -1:0] Row_Y2_FrameData;
wire[FrameBitsPerRow -1:0] Row_Y3_FrameData;
wire[FrameBitsPerRow -1:0] Row_Y4_FrameData;
wire[MaxFramesPerCol - 1:0] Column_X0_FrameStrobe;
wire[MaxFramesPerCol - 1:0] Column_X1_FrameStrobe;
wire[MaxFramesPerCol - 1:0] Column_X2_FrameStrobe;
wire[MaxFramesPerCol - 1:0] Column_X3_FrameStrobe;
wire[FrameBitsPerRow - 1:0] Tile_X0Y0_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X1Y0_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X2Y0_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X3Y0_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X0Y1_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X1Y1_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X2Y1_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X3Y1_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X0Y2_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X1Y2_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X2Y2_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X3Y2_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X0Y3_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X1Y3_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X2Y3_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X3Y3_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X0Y4_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X1Y4_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X2Y4_FrameData_O;
wire[FrameBitsPerRow - 1:0] Tile_X3Y4_FrameData_O;
wire[MaxFramesPerCol - 1:0] Tile_X0Y0_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X1Y0_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X2Y0_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X3Y0_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X0Y1_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X1Y1_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X2Y1_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X3Y1_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X0Y2_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X1Y2_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X2Y2_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X3Y2_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X0Y3_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X1Y3_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X2Y3_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X3Y3_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X0Y4_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X1Y4_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X2Y4_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X3Y4_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X0Y5_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X1Y5_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X2Y5_FrameStrobe_O;
wire[MaxFramesPerCol - 1:0] Tile_X3Y5_FrameStrobe_O;
 //tile-to-tile signal declarations
wire[3:0] Tile_X1Y0_S1BEG;
wire[7:0] Tile_X1Y0_S2BEG;
wire[7:0] Tile_X1Y0_S2BEGb;
wire[15:0] Tile_X1Y0_S4BEG;
wire[15:0] Tile_X1Y0_SS4BEG;
wire[3:0] Tile_X2Y0_S1BEG;
wire[7:0] Tile_X2Y0_S2BEG;
wire[7:0] Tile_X2Y0_S2BEGb;
wire[15:0] Tile_X2Y0_S4BEG;
wire[15:0] Tile_X2Y0_SS4BEG;
wire[3:0] Tile_X3Y0_S1BEG;
wire[7:0] Tile_X3Y0_S2BEG;
wire[7:0] Tile_X3Y0_S2BEGb;
wire[15:0] Tile_X3Y0_S4BEG;
wire[3:0] Tile_X0Y1_E1BEG;
wire[7:0] Tile_X0Y1_E2BEG;
wire[7:0] Tile_X0Y1_E2BEGb;
wire[15:0] Tile_X0Y1_EE4BEG;
wire[11:0] Tile_X0Y1_E6BEG;
wire[3:0] Tile_X1Y1_N1BEG;
wire[7:0] Tile_X1Y1_N2BEG;
wire[7:0] Tile_X1Y1_N2BEGb;
wire[15:0] Tile_X1Y1_N4BEG;
wire[15:0] Tile_X1Y1_NN4BEG;
wire[3:0] Tile_X1Y1_E1BEG;
wire[7:0] Tile_X1Y1_E2BEG;
wire[7:0] Tile_X1Y1_E2BEGb;
wire[15:0] Tile_X1Y1_EE4BEG;
wire[11:0] Tile_X1Y1_E6BEG;
wire[3:0] Tile_X1Y1_S1BEG;
wire[7:0] Tile_X1Y1_S2BEG;
wire[7:0] Tile_X1Y1_S2BEGb;
wire[15:0] Tile_X1Y1_S4BEG;
wire[15:0] Tile_X1Y1_SS4BEG;
wire[3:0] Tile_X1Y1_W1BEG;
wire[7:0] Tile_X1Y1_W2BEG;
wire[7:0] Tile_X1Y1_W2BEGb;
wire[15:0] Tile_X1Y1_WW4BEG;
wire[11:0] Tile_X1Y1_W6BEG;
wire[0:0] Tile_X1Y1_Co;
wire[3:0] Tile_X2Y1_N1BEG;
wire[7:0] Tile_X2Y1_N2BEG;
wire[7:0] Tile_X2Y1_N2BEGb;
wire[15:0] Tile_X2Y1_N4BEG;
wire[15:0] Tile_X2Y1_NN4BEG;
wire[3:0] Tile_X2Y1_E1BEG;
wire[7:0] Tile_X2Y1_E2BEG;
wire[7:0] Tile_X2Y1_E2BEGb;
wire[15:0] Tile_X2Y1_EE4BEG;
wire[11:0] Tile_X2Y1_E6BEG;
wire[3:0] Tile_X2Y1_S1BEG;
wire[7:0] Tile_X2Y1_S2BEG;
wire[7:0] Tile_X2Y1_S2BEGb;
wire[15:0] Tile_X2Y1_S4BEG;
wire[15:0] Tile_X2Y1_SS4BEG;
wire[3:0] Tile_X2Y1_W1BEG;
wire[7:0] Tile_X2Y1_W2BEG;
wire[7:0] Tile_X2Y1_W2BEGb;
wire[15:0] Tile_X2Y1_WW4BEG;
wire[11:0] Tile_X2Y1_W6BEG;
wire[0:0] Tile_X2Y1_Co;
wire[3:0] Tile_X3Y1_N1BEG;
wire[7:0] Tile_X3Y1_N2BEG;
wire[7:0] Tile_X3Y1_N2BEGb;
wire[15:0] Tile_X3Y1_N4BEG;
wire[3:0] Tile_X3Y1_S1BEG;
wire[7:0] Tile_X3Y1_S2BEG;
wire[7:0] Tile_X3Y1_S2BEGb;
wire[15:0] Tile_X3Y1_S4BEG;
wire[3:0] Tile_X3Y1_W1BEG;
wire[7:0] Tile_X3Y1_W2BEG;
wire[7:0] Tile_X3Y1_W2BEGb;
wire[15:0] Tile_X3Y1_WW4BEG;
wire[11:0] Tile_X3Y1_W6BEG;
wire[3:0] Tile_X0Y2_E1BEG;
wire[7:0] Tile_X0Y2_E2BEG;
wire[7:0] Tile_X0Y2_E2BEGb;
wire[15:0] Tile_X0Y2_EE4BEG;
wire[11:0] Tile_X0Y2_E6BEG;
wire[3:0] Tile_X1Y2_N1BEG;
wire[7:0] Tile_X1Y2_N2BEG;
wire[7:0] Tile_X1Y2_N2BEGb;
wire[15:0] Tile_X1Y2_N4BEG;
wire[15:0] Tile_X1Y2_NN4BEG;
wire[3:0] Tile_X1Y2_E1BEG;
wire[7:0] Tile_X1Y2_E2BEG;
wire[7:0] Tile_X1Y2_E2BEGb;
wire[15:0] Tile_X1Y2_EE4BEG;
wire[11:0] Tile_X1Y2_E6BEG;
wire[3:0] Tile_X1Y2_S1BEG;
wire[7:0] Tile_X1Y2_S2BEG;
wire[7:0] Tile_X1Y2_S2BEGb;
wire[15:0] Tile_X1Y2_S4BEG;
wire[15:0] Tile_X1Y2_SS4BEG;
wire[3:0] Tile_X1Y2_W1BEG;
wire[7:0] Tile_X1Y2_W2BEG;
wire[7:0] Tile_X1Y2_W2BEGb;
wire[15:0] Tile_X1Y2_WW4BEG;
wire[11:0] Tile_X1Y2_W6BEG;
wire[0:0] Tile_X1Y2_Co;
wire[3:0] Tile_X2Y2_N1BEG;
wire[7:0] Tile_X2Y2_N2BEG;
wire[7:0] Tile_X2Y2_N2BEGb;
wire[15:0] Tile_X2Y2_N4BEG;
wire[15:0] Tile_X2Y2_NN4BEG;
wire[3:0] Tile_X2Y2_E1BEG;
wire[7:0] Tile_X2Y2_E2BEG;
wire[7:0] Tile_X2Y2_E2BEGb;
wire[15:0] Tile_X2Y2_EE4BEG;
wire[11:0] Tile_X2Y2_E6BEG;
wire[3:0] Tile_X2Y2_S1BEG;
wire[7:0] Tile_X2Y2_S2BEG;
wire[7:0] Tile_X2Y2_S2BEGb;
wire[15:0] Tile_X2Y2_S4BEG;
wire[15:0] Tile_X2Y2_SS4BEG;
wire[3:0] Tile_X2Y2_W1BEG;
wire[7:0] Tile_X2Y2_W2BEG;
wire[7:0] Tile_X2Y2_W2BEGb;
wire[15:0] Tile_X2Y2_WW4BEG;
wire[11:0] Tile_X2Y2_W6BEG;
wire[0:0] Tile_X2Y2_Co;
wire[3:0] Tile_X3Y2_N1BEG;
wire[7:0] Tile_X3Y2_N2BEG;
wire[7:0] Tile_X3Y2_N2BEGb;
wire[15:0] Tile_X3Y2_N4BEG;
wire[3:0] Tile_X3Y2_S1BEG;
wire[7:0] Tile_X3Y2_S2BEG;
wire[7:0] Tile_X3Y2_S2BEGb;
wire[15:0] Tile_X3Y2_S4BEG;
wire[3:0] Tile_X3Y2_W1BEG;
wire[7:0] Tile_X3Y2_W2BEG;
wire[7:0] Tile_X3Y2_W2BEGb;
wire[15:0] Tile_X3Y2_WW4BEG;
wire[11:0] Tile_X3Y2_W6BEG;
wire[3:0] Tile_X0Y3_E1BEG;
wire[7:0] Tile_X0Y3_E2BEG;
wire[7:0] Tile_X0Y3_E2BEGb;
wire[15:0] Tile_X0Y3_EE4BEG;
wire[11:0] Tile_X0Y3_E6BEG;
wire[3:0] Tile_X1Y3_N1BEG;
wire[7:0] Tile_X1Y3_N2BEG;
wire[7:0] Tile_X1Y3_N2BEGb;
wire[15:0] Tile_X1Y3_N4BEG;
wire[15:0] Tile_X1Y3_NN4BEG;
wire[3:0] Tile_X1Y3_E1BEG;
wire[7:0] Tile_X1Y3_E2BEG;
wire[7:0] Tile_X1Y3_E2BEGb;
wire[15:0] Tile_X1Y3_EE4BEG;
wire[11:0] Tile_X1Y3_E6BEG;
wire[3:0] Tile_X1Y3_S1BEG;
wire[7:0] Tile_X1Y3_S2BEG;
wire[7:0] Tile_X1Y3_S2BEGb;
wire[15:0] Tile_X1Y3_S4BEG;
wire[15:0] Tile_X1Y3_SS4BEG;
wire[3:0] Tile_X1Y3_W1BEG;
wire[7:0] Tile_X1Y3_W2BEG;
wire[7:0] Tile_X1Y3_W2BEGb;
wire[15:0] Tile_X1Y3_WW4BEG;
wire[11:0] Tile_X1Y3_W6BEG;
wire[0:0] Tile_X1Y3_Co;
wire[3:0] Tile_X2Y3_N1BEG;
wire[7:0] Tile_X2Y3_N2BEG;
wire[7:0] Tile_X2Y3_N2BEGb;
wire[15:0] Tile_X2Y3_N4BEG;
wire[15:0] Tile_X2Y3_NN4BEG;
wire[3:0] Tile_X2Y3_E1BEG;
wire[7:0] Tile_X2Y3_E2BEG;
wire[7:0] Tile_X2Y3_E2BEGb;
wire[15:0] Tile_X2Y3_EE4BEG;
wire[11:0] Tile_X2Y3_E6BEG;
wire[3:0] Tile_X2Y3_S1BEG;
wire[7:0] Tile_X2Y3_S2BEG;
wire[7:0] Tile_X2Y3_S2BEGb;
wire[15:0] Tile_X2Y3_S4BEG;
wire[15:0] Tile_X2Y3_SS4BEG;
wire[3:0] Tile_X2Y3_W1BEG;
wire[7:0] Tile_X2Y3_W2BEG;
wire[7:0] Tile_X2Y3_W2BEGb;
wire[15:0] Tile_X2Y3_WW4BEG;
wire[11:0] Tile_X2Y3_W6BEG;
wire[0:0] Tile_X2Y3_Co;
wire[3:0] Tile_X3Y3_N1BEG;
wire[7:0] Tile_X3Y3_N2BEG;
wire[7:0] Tile_X3Y3_N2BEGb;
wire[15:0] Tile_X3Y3_N4BEG;
wire[3:0] Tile_X3Y3_S1BEG;
wire[7:0] Tile_X3Y3_S2BEG;
wire[7:0] Tile_X3Y3_S2BEGb;
wire[15:0] Tile_X3Y3_S4BEG;
wire[3:0] Tile_X3Y3_W1BEG;
wire[7:0] Tile_X3Y3_W2BEG;
wire[7:0] Tile_X3Y3_W2BEGb;
wire[15:0] Tile_X3Y3_WW4BEG;
wire[11:0] Tile_X3Y3_W6BEG;
wire[3:0] Tile_X1Y4_N1BEG;
wire[7:0] Tile_X1Y4_N2BEG;
wire[7:0] Tile_X1Y4_N2BEGb;
wire[15:0] Tile_X1Y4_N4BEG;
wire[15:0] Tile_X1Y4_NN4BEG;
wire[0:0] Tile_X1Y4_Co;
wire[3:0] Tile_X2Y4_N1BEG;
wire[7:0] Tile_X2Y4_N2BEG;
wire[7:0] Tile_X2Y4_N2BEGb;
wire[15:0] Tile_X2Y4_N4BEG;
wire[15:0] Tile_X2Y4_NN4BEG;
wire[0:0] Tile_X2Y4_Co;
wire[3:0] Tile_X3Y4_N1BEG;
wire[7:0] Tile_X3Y4_N2BEG;
wire[7:0] Tile_X3Y4_N2BEGb;
wire[15:0] Tile_X3Y4_N4BEG;

assign Row_Y0_FrameData = FrameData[FrameBitsPerRow*(0+1)-1:FrameBitsPerRow*0];
assign Row_Y1_FrameData = FrameData[FrameBitsPerRow*(1+1)-1:FrameBitsPerRow*1];
assign Row_Y2_FrameData = FrameData[FrameBitsPerRow*(2+1)-1:FrameBitsPerRow*2];
assign Row_Y3_FrameData = FrameData[FrameBitsPerRow*(3+1)-1:FrameBitsPerRow*3];
assign Row_Y4_FrameData = FrameData[FrameBitsPerRow*(4+1)-1:FrameBitsPerRow*4];
assign Column_X0_FrameStrobe = FrameStrobe[MaxFramesPerCol*(0+1)-1:MaxFramesPerCol*0];
assign Column_X1_FrameStrobe = FrameStrobe[MaxFramesPerCol*(1+1)-1:MaxFramesPerCol*1];
assign Column_X2_FrameStrobe = FrameStrobe[MaxFramesPerCol*(2+1)-1:MaxFramesPerCol*2];
assign Column_X3_FrameStrobe = FrameStrobe[MaxFramesPerCol*(3+1)-1:MaxFramesPerCol*3];

 //tile IO port will get directly connected to top-level tile module
N_term_single Tile_X1Y0_N_term_single (
    .N1END(Tile_X1Y1_N1BEG),
    .N2MID(Tile_X1Y1_N2BEG),
    .N2END(Tile_X1Y1_N2BEGb),
    .N4END(Tile_X1Y1_N4BEG),
    .NN4END(Tile_X1Y1_NN4BEG),
    .Ci(Tile_X1Y1_Co),
    .S1BEG(Tile_X1Y0_S1BEG),
    .S2BEG(Tile_X1Y0_S2BEG),
    .S2BEGb(Tile_X1Y0_S2BEGb),
    .S4BEG(Tile_X1Y0_S4BEG),
    .SS4BEG(Tile_X1Y0_SS4BEG),
    .UserCLK(Tile_X1Y1_UserCLKo),
    .UserCLKo(Tile_X1Y0_UserCLKo),
    .FrameData(Row_Y0_FrameData),
    .FrameData_O(Tile_X1Y0_FrameData_O),
    .FrameStrobe(Tile_X1Y1_FrameStrobe_O),
    .FrameStrobe_O(Tile_X1Y0_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
N_term_single Tile_X2Y0_N_term_single (
    .N1END(Tile_X2Y1_N1BEG),
    .N2MID(Tile_X2Y1_N2BEG),
    .N2END(Tile_X2Y1_N2BEGb),
    .N4END(Tile_X2Y1_N4BEG),
    .NN4END(Tile_X2Y1_NN4BEG),
    .Ci(Tile_X2Y1_Co),
    .S1BEG(Tile_X2Y0_S1BEG),
    .S2BEG(Tile_X2Y0_S2BEG),
    .S2BEGb(Tile_X2Y0_S2BEGb),
    .S4BEG(Tile_X2Y0_S4BEG),
    .SS4BEG(Tile_X2Y0_SS4BEG),
    .UserCLK(Tile_X2Y1_UserCLKo),
    .UserCLKo(Tile_X2Y0_UserCLKo),
    .FrameData(Tile_X1Y0_FrameData_O),
    .FrameData_O(Tile_X2Y0_FrameData_O),
    .FrameStrobe(Tile_X2Y1_FrameStrobe_O),
    .FrameStrobe_O(Tile_X2Y0_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
N_term_RAM_IO Tile_X3Y0_N_term_RAM_IO (
    .N1END(Tile_X3Y1_N1BEG),
    .N2MID(Tile_X3Y1_N2BEG),
    .N2END(Tile_X3Y1_N2BEGb),
    .N4END(Tile_X3Y1_N4BEG),
    .S1BEG(Tile_X3Y0_S1BEG),
    .S2BEG(Tile_X3Y0_S2BEG),
    .S2BEGb(Tile_X3Y0_S2BEGb),
    .S4BEG(Tile_X3Y0_S4BEG),
    .UserCLK(Tile_X3Y1_UserCLKo),
    .UserCLKo(Tile_X3Y0_UserCLKo),
    .FrameData(Tile_X2Y0_FrameData_O),
    .FrameData_O(Tile_X3Y0_FrameData_O),
    .FrameStrobe(Tile_X3Y1_FrameStrobe_O),
    .FrameStrobe_O(Tile_X3Y0_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
W_IO
`ifdef EMULATION
    #(
    .Emulate_Bitstream(`Tile_X0Y1_Emulate_Bitstream)
    )
`endif
    Tile_X0Y1_W_IO
    (
    .W1END(Tile_X1Y1_W1BEG),
    .W2MID(Tile_X1Y1_W2BEG),
    .W2END(Tile_X1Y1_W2BEGb),
    .WW4END(Tile_X1Y1_WW4BEG),
    .W6END(Tile_X1Y1_W6BEG),
    .E1BEG(Tile_X0Y1_E1BEG),
    .E2BEG(Tile_X0Y1_E2BEG),
    .E2BEGb(Tile_X0Y1_E2BEGb),
    .EE4BEG(Tile_X0Y1_EE4BEG),
    .E6BEG(Tile_X0Y1_E6BEG),
    .A_O_top(Tile_X0Y1_A_O_top),
    .A_I_top(Tile_X0Y1_A_I_top),
    .A_T_top(Tile_X0Y1_A_T_top),
    .B_O_top(Tile_X0Y1_B_O_top),
    .B_I_top(Tile_X0Y1_B_I_top),
    .B_T_top(Tile_X0Y1_B_T_top),
    .A_config_C_bit0(Tile_X0Y1_A_config_C_bit0),
    .A_config_C_bit1(Tile_X0Y1_A_config_C_bit1),
    .A_config_C_bit2(Tile_X0Y1_A_config_C_bit2),
    .A_config_C_bit3(Tile_X0Y1_A_config_C_bit3),
    .B_config_C_bit0(Tile_X0Y1_B_config_C_bit0),
    .B_config_C_bit1(Tile_X0Y1_B_config_C_bit1),
    .B_config_C_bit2(Tile_X0Y1_B_config_C_bit2),
    .B_config_C_bit3(Tile_X0Y1_B_config_C_bit3),
    .UserCLK(Tile_X0Y2_UserCLKo),
    .UserCLKo(Tile_X0Y1_UserCLKo),
    .FrameData(Row_Y1_FrameData),
    .FrameData_O(Tile_X0Y1_FrameData_O),
    .FrameStrobe(Tile_X0Y2_FrameStrobe_O),
    .FrameStrobe_O(Tile_X0Y1_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
LUT4AB
`ifdef EMULATION
    #(
    .Emulate_Bitstream(`Tile_X1Y1_Emulate_Bitstream)
    )
`endif
    Tile_X1Y1_LUT4AB
    (
    .N1END(Tile_X1Y2_N1BEG),
    .N2MID(Tile_X1Y2_N2BEG),
    .N2END(Tile_X1Y2_N2BEGb),
    .N4END(Tile_X1Y2_N4BEG),
    .NN4END(Tile_X1Y2_NN4BEG),
    .Ci(Tile_X1Y2_Co),
    .E1END(Tile_X0Y1_E1BEG),
    .E2MID(Tile_X0Y1_E2BEG),
    .E2END(Tile_X0Y1_E2BEGb),
    .EE4END(Tile_X0Y1_EE4BEG),
    .E6END(Tile_X0Y1_E6BEG),
    .S1END(Tile_X1Y0_S1BEG),
    .S2MID(Tile_X1Y0_S2BEG),
    .S2END(Tile_X1Y0_S2BEGb),
    .S4END(Tile_X1Y0_S4BEG),
    .SS4END(Tile_X1Y0_SS4BEG),
    .W1END(Tile_X2Y1_W1BEG),
    .W2MID(Tile_X2Y1_W2BEG),
    .W2END(Tile_X2Y1_W2BEGb),
    .WW4END(Tile_X2Y1_WW4BEG),
    .W6END(Tile_X2Y1_W6BEG),
    .N1BEG(Tile_X1Y1_N1BEG),
    .N2BEG(Tile_X1Y1_N2BEG),
    .N2BEGb(Tile_X1Y1_N2BEGb),
    .N4BEG(Tile_X1Y1_N4BEG),
    .NN4BEG(Tile_X1Y1_NN4BEG),
    .E1BEG(Tile_X1Y1_E1BEG),
    .E2BEG(Tile_X1Y1_E2BEG),
    .E2BEGb(Tile_X1Y1_E2BEGb),
    .EE4BEG(Tile_X1Y1_EE4BEG),
    .E6BEG(Tile_X1Y1_E6BEG),
    .S1BEG(Tile_X1Y1_S1BEG),
    .S2BEG(Tile_X1Y1_S2BEG),
    .S2BEGb(Tile_X1Y1_S2BEGb),
    .S4BEG(Tile_X1Y1_S4BEG),
    .SS4BEG(Tile_X1Y1_SS4BEG),
    .W1BEG(Tile_X1Y1_W1BEG),
    .W2BEG(Tile_X1Y1_W2BEG),
    .W2BEGb(Tile_X1Y1_W2BEGb),
    .WW4BEG(Tile_X1Y1_WW4BEG),
    .W6BEG(Tile_X1Y1_W6BEG),
    .Co(Tile_X1Y1_Co),
    .UserCLK(Tile_X1Y2_UserCLKo),
    .UserCLKo(Tile_X1Y1_UserCLKo),
    .FrameData(Tile_X0Y1_FrameData_O),
    .FrameData_O(Tile_X1Y1_FrameData_O),
    .FrameStrobe(Tile_X1Y2_FrameStrobe_O),
    .FrameStrobe_O(Tile_X1Y1_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
LUT4AB
`ifdef EMULATION
    #(
    .Emulate_Bitstream(`Tile_X2Y1_Emulate_Bitstream)
    )
`endif
    Tile_X2Y1_LUT4AB
    (
    .N1END(Tile_X2Y2_N1BEG),
    .N2MID(Tile_X2Y2_N2BEG),
    .N2END(Tile_X2Y2_N2BEGb),
    .N4END(Tile_X2Y2_N4BEG),
    .NN4END(Tile_X2Y2_NN4BEG),
    .Ci(Tile_X2Y2_Co),
    .E1END(Tile_X1Y1_E1BEG),
    .E2MID(Tile_X1Y1_E2BEG),
    .E2END(Tile_X1Y1_E2BEGb),
    .EE4END(Tile_X1Y1_EE4BEG),
    .E6END(Tile_X1Y1_E6BEG),
    .S1END(Tile_X2Y0_S1BEG),
    .S2MID(Tile_X2Y0_S2BEG),
    .S2END(Tile_X2Y0_S2BEGb),
    .S4END(Tile_X2Y0_S4BEG),
    .SS4END(Tile_X2Y0_SS4BEG),
    .W1END(Tile_X3Y1_W1BEG),
    .W2MID(Tile_X3Y1_W2BEG),
    .W2END(Tile_X3Y1_W2BEGb),
    .WW4END(Tile_X3Y1_WW4BEG),
    .W6END(Tile_X3Y1_W6BEG),
    .N1BEG(Tile_X2Y1_N1BEG),
    .N2BEG(Tile_X2Y1_N2BEG),
    .N2BEGb(Tile_X2Y1_N2BEGb),
    .N4BEG(Tile_X2Y1_N4BEG),
    .NN4BEG(Tile_X2Y1_NN4BEG),
    .E1BEG(Tile_X2Y1_E1BEG),
    .E2BEG(Tile_X2Y1_E2BEG),
    .E2BEGb(Tile_X2Y1_E2BEGb),
    .EE4BEG(Tile_X2Y1_EE4BEG),
    .E6BEG(Tile_X2Y1_E6BEG),
    .S1BEG(Tile_X2Y1_S1BEG),
    .S2BEG(Tile_X2Y1_S2BEG),
    .S2BEGb(Tile_X2Y1_S2BEGb),
    .S4BEG(Tile_X2Y1_S4BEG),
    .SS4BEG(Tile_X2Y1_SS4BEG),
    .W1BEG(Tile_X2Y1_W1BEG),
    .W2BEG(Tile_X2Y1_W2BEG),
    .W2BEGb(Tile_X2Y1_W2BEGb),
    .WW4BEG(Tile_X2Y1_WW4BEG),
    .W6BEG(Tile_X2Y1_W6BEG),
    .Co(Tile_X2Y1_Co),
    .UserCLK(Tile_X2Y2_UserCLKo),
    .UserCLKo(Tile_X2Y1_UserCLKo),
    .FrameData(Tile_X1Y1_FrameData_O),
    .FrameData_O(Tile_X2Y1_FrameData_O),
    .FrameStrobe(Tile_X2Y2_FrameStrobe_O),
    .FrameStrobe_O(Tile_X2Y1_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
RAM_IO
`ifdef EMULATION
    #(
    .Emulate_Bitstream(`Tile_X3Y1_Emulate_Bitstream)
    )
`endif
    Tile_X3Y1_RAM_IO
    (
    .N1END(Tile_X3Y2_N1BEG),
    .N2MID(Tile_X3Y2_N2BEG),
    .N2END(Tile_X3Y2_N2BEGb),
    .N4END(Tile_X3Y2_N4BEG),
    .E1END(Tile_X2Y1_E1BEG),
    .E2MID(Tile_X2Y1_E2BEG),
    .E2END(Tile_X2Y1_E2BEGb),
    .EE4END(Tile_X2Y1_EE4BEG),
    .E6END(Tile_X2Y1_E6BEG),
    .S1END(Tile_X3Y0_S1BEG),
    .S2MID(Tile_X3Y0_S2BEG),
    .S2END(Tile_X3Y0_S2BEGb),
    .S4END(Tile_X3Y0_S4BEG),
    .N1BEG(Tile_X3Y1_N1BEG),
    .N2BEG(Tile_X3Y1_N2BEG),
    .N2BEGb(Tile_X3Y1_N2BEGb),
    .N4BEG(Tile_X3Y1_N4BEG),
    .S1BEG(Tile_X3Y1_S1BEG),
    .S2BEG(Tile_X3Y1_S2BEG),
    .S2BEGb(Tile_X3Y1_S2BEGb),
    .S4BEG(Tile_X3Y1_S4BEG),
    .W1BEG(Tile_X3Y1_W1BEG),
    .W2BEG(Tile_X3Y1_W2BEG),
    .W2BEGb(Tile_X3Y1_W2BEGb),
    .WW4BEG(Tile_X3Y1_WW4BEG),
    .W6BEG(Tile_X3Y1_W6BEG),
    .RAM2FAB_D0_I0(Tile_X3Y1_RAM2FAB_D0_I0),
    .RAM2FAB_D0_I1(Tile_X3Y1_RAM2FAB_D0_I1),
    .RAM2FAB_D0_I2(Tile_X3Y1_RAM2FAB_D0_I2),
    .RAM2FAB_D0_I3(Tile_X3Y1_RAM2FAB_D0_I3),
    .RAM2FAB_D1_I0(Tile_X3Y1_RAM2FAB_D1_I0),
    .RAM2FAB_D1_I1(Tile_X3Y1_RAM2FAB_D1_I1),
    .RAM2FAB_D1_I2(Tile_X3Y1_RAM2FAB_D1_I2),
    .RAM2FAB_D1_I3(Tile_X3Y1_RAM2FAB_D1_I3),
    .RAM2FAB_D2_I0(Tile_X3Y1_RAM2FAB_D2_I0),
    .RAM2FAB_D2_I1(Tile_X3Y1_RAM2FAB_D2_I1),
    .RAM2FAB_D2_I2(Tile_X3Y1_RAM2FAB_D2_I2),
    .RAM2FAB_D2_I3(Tile_X3Y1_RAM2FAB_D2_I3),
    .RAM2FAB_D3_I0(Tile_X3Y1_RAM2FAB_D3_I0),
    .RAM2FAB_D3_I1(Tile_X3Y1_RAM2FAB_D3_I1),
    .RAM2FAB_D3_I2(Tile_X3Y1_RAM2FAB_D3_I2),
    .RAM2FAB_D3_I3(Tile_X3Y1_RAM2FAB_D3_I3),
    .FAB2RAM_D0_O0(Tile_X3Y1_FAB2RAM_D0_O0),
    .FAB2RAM_D0_O1(Tile_X3Y1_FAB2RAM_D0_O1),
    .FAB2RAM_D0_O2(Tile_X3Y1_FAB2RAM_D0_O2),
    .FAB2RAM_D0_O3(Tile_X3Y1_FAB2RAM_D0_O3),
    .FAB2RAM_D1_O0(Tile_X3Y1_FAB2RAM_D1_O0),
    .FAB2RAM_D1_O1(Tile_X3Y1_FAB2RAM_D1_O1),
    .FAB2RAM_D1_O2(Tile_X3Y1_FAB2RAM_D1_O2),
    .FAB2RAM_D1_O3(Tile_X3Y1_FAB2RAM_D1_O3),
    .FAB2RAM_D2_O0(Tile_X3Y1_FAB2RAM_D2_O0),
    .FAB2RAM_D2_O1(Tile_X3Y1_FAB2RAM_D2_O1),
    .FAB2RAM_D2_O2(Tile_X3Y1_FAB2RAM_D2_O2),
    .FAB2RAM_D2_O3(Tile_X3Y1_FAB2RAM_D2_O3),
    .FAB2RAM_D3_O0(Tile_X3Y1_FAB2RAM_D3_O0),
    .FAB2RAM_D3_O1(Tile_X3Y1_FAB2RAM_D3_O1),
    .FAB2RAM_D3_O2(Tile_X3Y1_FAB2RAM_D3_O2),
    .FAB2RAM_D3_O3(Tile_X3Y1_FAB2RAM_D3_O3),
    .FAB2RAM_A0_O0(Tile_X3Y1_FAB2RAM_A0_O0),
    .FAB2RAM_A0_O1(Tile_X3Y1_FAB2RAM_A0_O1),
    .FAB2RAM_A0_O2(Tile_X3Y1_FAB2RAM_A0_O2),
    .FAB2RAM_A0_O3(Tile_X3Y1_FAB2RAM_A0_O3),
    .FAB2RAM_A1_O0(Tile_X3Y1_FAB2RAM_A1_O0),
    .FAB2RAM_A1_O1(Tile_X3Y1_FAB2RAM_A1_O1),
    .FAB2RAM_A1_O2(Tile_X3Y1_FAB2RAM_A1_O2),
    .FAB2RAM_A1_O3(Tile_X3Y1_FAB2RAM_A1_O3),
    .FAB2RAM_C_O0(Tile_X3Y1_FAB2RAM_C_O0),
    .FAB2RAM_C_O1(Tile_X3Y1_FAB2RAM_C_O1),
    .FAB2RAM_C_O2(Tile_X3Y1_FAB2RAM_C_O2),
    .FAB2RAM_C_O3(Tile_X3Y1_FAB2RAM_C_O3),
    .Config_accessC_bit0(Tile_X3Y1_Config_accessC_bit0),
    .Config_accessC_bit1(Tile_X3Y1_Config_accessC_bit1),
    .Config_accessC_bit2(Tile_X3Y1_Config_accessC_bit2),
    .Config_accessC_bit3(Tile_X3Y1_Config_accessC_bit3),
    .UserCLK(Tile_X3Y2_UserCLKo),
    .UserCLKo(Tile_X3Y1_UserCLKo),
    .FrameData(Tile_X2Y1_FrameData_O),
    .FrameData_O(Tile_X3Y1_FrameData_O),
    .FrameStrobe(Tile_X3Y2_FrameStrobe_O),
    .FrameStrobe_O(Tile_X3Y1_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
W_IO
`ifdef EMULATION
    #(
    .Emulate_Bitstream(`Tile_X0Y2_Emulate_Bitstream)
    )
`endif
    Tile_X0Y2_W_IO
    (
    .W1END(Tile_X1Y2_W1BEG),
    .W2MID(Tile_X1Y2_W2BEG),
    .W2END(Tile_X1Y2_W2BEGb),
    .WW4END(Tile_X1Y2_WW4BEG),
    .W6END(Tile_X1Y2_W6BEG),
    .E1BEG(Tile_X0Y2_E1BEG),
    .E2BEG(Tile_X0Y2_E2BEG),
    .E2BEGb(Tile_X0Y2_E2BEGb),
    .EE4BEG(Tile_X0Y2_EE4BEG),
    .E6BEG(Tile_X0Y2_E6BEG),
    .A_O_top(Tile_X0Y2_A_O_top),
    .A_I_top(Tile_X0Y2_A_I_top),
    .A_T_top(Tile_X0Y2_A_T_top),
    .B_O_top(Tile_X0Y2_B_O_top),
    .B_I_top(Tile_X0Y2_B_I_top),
    .B_T_top(Tile_X0Y2_B_T_top),
    .A_config_C_bit0(Tile_X0Y2_A_config_C_bit0),
    .A_config_C_bit1(Tile_X0Y2_A_config_C_bit1),
    .A_config_C_bit2(Tile_X0Y2_A_config_C_bit2),
    .A_config_C_bit3(Tile_X0Y2_A_config_C_bit3),
    .B_config_C_bit0(Tile_X0Y2_B_config_C_bit0),
    .B_config_C_bit1(Tile_X0Y2_B_config_C_bit1),
    .B_config_C_bit2(Tile_X0Y2_B_config_C_bit2),
    .B_config_C_bit3(Tile_X0Y2_B_config_C_bit3),
    .UserCLK(Tile_X0Y3_UserCLKo),
    .UserCLKo(Tile_X0Y2_UserCLKo),
    .FrameData(Row_Y2_FrameData),
    .FrameData_O(Tile_X0Y2_FrameData_O),
    .FrameStrobe(Tile_X0Y3_FrameStrobe_O),
    .FrameStrobe_O(Tile_X0Y2_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
LUT4AB
`ifdef EMULATION
    #(
    .Emulate_Bitstream(`Tile_X1Y2_Emulate_Bitstream)
    )
`endif
    Tile_X1Y2_LUT4AB
    (
    .N1END(Tile_X1Y3_N1BEG),
    .N2MID(Tile_X1Y3_N2BEG),
    .N2END(Tile_X1Y3_N2BEGb),
    .N4END(Tile_X1Y3_N4BEG),
    .NN4END(Tile_X1Y3_NN4BEG),
    .Ci(Tile_X1Y3_Co),
    .E1END(Tile_X0Y2_E1BEG),
    .E2MID(Tile_X0Y2_E2BEG),
    .E2END(Tile_X0Y2_E2BEGb),
    .EE4END(Tile_X0Y2_EE4BEG),
    .E6END(Tile_X0Y2_E6BEG),
    .S1END(Tile_X1Y1_S1BEG),
    .S2MID(Tile_X1Y1_S2BEG),
    .S2END(Tile_X1Y1_S2BEGb),
    .S4END(Tile_X1Y1_S4BEG),
    .SS4END(Tile_X1Y1_SS4BEG),
    .W1END(Tile_X2Y2_W1BEG),
    .W2MID(Tile_X2Y2_W2BEG),
    .W2END(Tile_X2Y2_W2BEGb),
    .WW4END(Tile_X2Y2_WW4BEG),
    .W6END(Tile_X2Y2_W6BEG),
    .N1BEG(Tile_X1Y2_N1BEG),
    .N2BEG(Tile_X1Y2_N2BEG),
    .N2BEGb(Tile_X1Y2_N2BEGb),
    .N4BEG(Tile_X1Y2_N4BEG),
    .NN4BEG(Tile_X1Y2_NN4BEG),
    .E1BEG(Tile_X1Y2_E1BEG),
    .E2BEG(Tile_X1Y2_E2BEG),
    .E2BEGb(Tile_X1Y2_E2BEGb),
    .EE4BEG(Tile_X1Y2_EE4BEG),
    .E6BEG(Tile_X1Y2_E6BEG),
    .S1BEG(Tile_X1Y2_S1BEG),
    .S2BEG(Tile_X1Y2_S2BEG),
    .S2BEGb(Tile_X1Y2_S2BEGb),
    .S4BEG(Tile_X1Y2_S4BEG),
    .SS4BEG(Tile_X1Y2_SS4BEG),
    .W1BEG(Tile_X1Y2_W1BEG),
    .W2BEG(Tile_X1Y2_W2BEG),
    .W2BEGb(Tile_X1Y2_W2BEGb),
    .WW4BEG(Tile_X1Y2_WW4BEG),
    .W6BEG(Tile_X1Y2_W6BEG),
    .Co(Tile_X1Y2_Co),
    .UserCLK(Tile_X1Y3_UserCLKo),
    .UserCLKo(Tile_X1Y2_UserCLKo),
    .FrameData(Tile_X0Y2_FrameData_O),
    .FrameData_O(Tile_X1Y2_FrameData_O),
    .FrameStrobe(Tile_X1Y3_FrameStrobe_O),
    .FrameStrobe_O(Tile_X1Y2_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
LUT4AB
`ifdef EMULATION
    #(
    .Emulate_Bitstream(`Tile_X2Y2_Emulate_Bitstream)
    )
`endif
    Tile_X2Y2_LUT4AB
    (
    .N1END(Tile_X2Y3_N1BEG),
    .N2MID(Tile_X2Y3_N2BEG),
    .N2END(Tile_X2Y3_N2BEGb),
    .N4END(Tile_X2Y3_N4BEG),
    .NN4END(Tile_X2Y3_NN4BEG),
    .Ci(Tile_X2Y3_Co),
    .E1END(Tile_X1Y2_E1BEG),
    .E2MID(Tile_X1Y2_E2BEG),
    .E2END(Tile_X1Y2_E2BEGb),
    .EE4END(Tile_X1Y2_EE4BEG),
    .E6END(Tile_X1Y2_E6BEG),
    .S1END(Tile_X2Y1_S1BEG),
    .S2MID(Tile_X2Y1_S2BEG),
    .S2END(Tile_X2Y1_S2BEGb),
    .S4END(Tile_X2Y1_S4BEG),
    .SS4END(Tile_X2Y1_SS4BEG),
    .W1END(Tile_X3Y2_W1BEG),
    .W2MID(Tile_X3Y2_W2BEG),
    .W2END(Tile_X3Y2_W2BEGb),
    .WW4END(Tile_X3Y2_WW4BEG),
    .W6END(Tile_X3Y2_W6BEG),
    .N1BEG(Tile_X2Y2_N1BEG),
    .N2BEG(Tile_X2Y2_N2BEG),
    .N2BEGb(Tile_X2Y2_N2BEGb),
    .N4BEG(Tile_X2Y2_N4BEG),
    .NN4BEG(Tile_X2Y2_NN4BEG),
    .E1BEG(Tile_X2Y2_E1BEG),
    .E2BEG(Tile_X2Y2_E2BEG),
    .E2BEGb(Tile_X2Y2_E2BEGb),
    .EE4BEG(Tile_X2Y2_EE4BEG),
    .E6BEG(Tile_X2Y2_E6BEG),
    .S1BEG(Tile_X2Y2_S1BEG),
    .S2BEG(Tile_X2Y2_S2BEG),
    .S2BEGb(Tile_X2Y2_S2BEGb),
    .S4BEG(Tile_X2Y2_S4BEG),
    .SS4BEG(Tile_X2Y2_SS4BEG),
    .W1BEG(Tile_X2Y2_W1BEG),
    .W2BEG(Tile_X2Y2_W2BEG),
    .W2BEGb(Tile_X2Y2_W2BEGb),
    .WW4BEG(Tile_X2Y2_WW4BEG),
    .W6BEG(Tile_X2Y2_W6BEG),
    .Co(Tile_X2Y2_Co),
    .UserCLK(Tile_X2Y3_UserCLKo),
    .UserCLKo(Tile_X2Y2_UserCLKo),
    .FrameData(Tile_X1Y2_FrameData_O),
    .FrameData_O(Tile_X2Y2_FrameData_O),
    .FrameStrobe(Tile_X2Y3_FrameStrobe_O),
    .FrameStrobe_O(Tile_X2Y2_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
RAM_IO
`ifdef EMULATION
    #(
    .Emulate_Bitstream(`Tile_X3Y2_Emulate_Bitstream)
    )
`endif
    Tile_X3Y2_RAM_IO
    (
    .N1END(Tile_X3Y3_N1BEG),
    .N2MID(Tile_X3Y3_N2BEG),
    .N2END(Tile_X3Y3_N2BEGb),
    .N4END(Tile_X3Y3_N4BEG),
    .E1END(Tile_X2Y2_E1BEG),
    .E2MID(Tile_X2Y2_E2BEG),
    .E2END(Tile_X2Y2_E2BEGb),
    .EE4END(Tile_X2Y2_EE4BEG),
    .E6END(Tile_X2Y2_E6BEG),
    .S1END(Tile_X3Y1_S1BEG),
    .S2MID(Tile_X3Y1_S2BEG),
    .S2END(Tile_X3Y1_S2BEGb),
    .S4END(Tile_X3Y1_S4BEG),
    .N1BEG(Tile_X3Y2_N1BEG),
    .N2BEG(Tile_X3Y2_N2BEG),
    .N2BEGb(Tile_X3Y2_N2BEGb),
    .N4BEG(Tile_X3Y2_N4BEG),
    .S1BEG(Tile_X3Y2_S1BEG),
    .S2BEG(Tile_X3Y2_S2BEG),
    .S2BEGb(Tile_X3Y2_S2BEGb),
    .S4BEG(Tile_X3Y2_S4BEG),
    .W1BEG(Tile_X3Y2_W1BEG),
    .W2BEG(Tile_X3Y2_W2BEG),
    .W2BEGb(Tile_X3Y2_W2BEGb),
    .WW4BEG(Tile_X3Y2_WW4BEG),
    .W6BEG(Tile_X3Y2_W6BEG),
    .RAM2FAB_D0_I0(Tile_X3Y2_RAM2FAB_D0_I0),
    .RAM2FAB_D0_I1(Tile_X3Y2_RAM2FAB_D0_I1),
    .RAM2FAB_D0_I2(Tile_X3Y2_RAM2FAB_D0_I2),
    .RAM2FAB_D0_I3(Tile_X3Y2_RAM2FAB_D0_I3),
    .RAM2FAB_D1_I0(Tile_X3Y2_RAM2FAB_D1_I0),
    .RAM2FAB_D1_I1(Tile_X3Y2_RAM2FAB_D1_I1),
    .RAM2FAB_D1_I2(Tile_X3Y2_RAM2FAB_D1_I2),
    .RAM2FAB_D1_I3(Tile_X3Y2_RAM2FAB_D1_I3),
    .RAM2FAB_D2_I0(Tile_X3Y2_RAM2FAB_D2_I0),
    .RAM2FAB_D2_I1(Tile_X3Y2_RAM2FAB_D2_I1),
    .RAM2FAB_D2_I2(Tile_X3Y2_RAM2FAB_D2_I2),
    .RAM2FAB_D2_I3(Tile_X3Y2_RAM2FAB_D2_I3),
    .RAM2FAB_D3_I0(Tile_X3Y2_RAM2FAB_D3_I0),
    .RAM2FAB_D3_I1(Tile_X3Y2_RAM2FAB_D3_I1),
    .RAM2FAB_D3_I2(Tile_X3Y2_RAM2FAB_D3_I2),
    .RAM2FAB_D3_I3(Tile_X3Y2_RAM2FAB_D3_I3),
    .FAB2RAM_D0_O0(Tile_X3Y2_FAB2RAM_D0_O0),
    .FAB2RAM_D0_O1(Tile_X3Y2_FAB2RAM_D0_O1),
    .FAB2RAM_D0_O2(Tile_X3Y2_FAB2RAM_D0_O2),
    .FAB2RAM_D0_O3(Tile_X3Y2_FAB2RAM_D0_O3),
    .FAB2RAM_D1_O0(Tile_X3Y2_FAB2RAM_D1_O0),
    .FAB2RAM_D1_O1(Tile_X3Y2_FAB2RAM_D1_O1),
    .FAB2RAM_D1_O2(Tile_X3Y2_FAB2RAM_D1_O2),
    .FAB2RAM_D1_O3(Tile_X3Y2_FAB2RAM_D1_O3),
    .FAB2RAM_D2_O0(Tile_X3Y2_FAB2RAM_D2_O0),
    .FAB2RAM_D2_O1(Tile_X3Y2_FAB2RAM_D2_O1),
    .FAB2RAM_D2_O2(Tile_X3Y2_FAB2RAM_D2_O2),
    .FAB2RAM_D2_O3(Tile_X3Y2_FAB2RAM_D2_O3),
    .FAB2RAM_D3_O0(Tile_X3Y2_FAB2RAM_D3_O0),
    .FAB2RAM_D3_O1(Tile_X3Y2_FAB2RAM_D3_O1),
    .FAB2RAM_D3_O2(Tile_X3Y2_FAB2RAM_D3_O2),
    .FAB2RAM_D3_O3(Tile_X3Y2_FAB2RAM_D3_O3),
    .FAB2RAM_A0_O0(Tile_X3Y2_FAB2RAM_A0_O0),
    .FAB2RAM_A0_O1(Tile_X3Y2_FAB2RAM_A0_O1),
    .FAB2RAM_A0_O2(Tile_X3Y2_FAB2RAM_A0_O2),
    .FAB2RAM_A0_O3(Tile_X3Y2_FAB2RAM_A0_O3),
    .FAB2RAM_A1_O0(Tile_X3Y2_FAB2RAM_A1_O0),
    .FAB2RAM_A1_O1(Tile_X3Y2_FAB2RAM_A1_O1),
    .FAB2RAM_A1_O2(Tile_X3Y2_FAB2RAM_A1_O2),
    .FAB2RAM_A1_O3(Tile_X3Y2_FAB2RAM_A1_O3),
    .FAB2RAM_C_O0(Tile_X3Y2_FAB2RAM_C_O0),
    .FAB2RAM_C_O1(Tile_X3Y2_FAB2RAM_C_O1),
    .FAB2RAM_C_O2(Tile_X3Y2_FAB2RAM_C_O2),
    .FAB2RAM_C_O3(Tile_X3Y2_FAB2RAM_C_O3),
    .Config_accessC_bit0(Tile_X3Y2_Config_accessC_bit0),
    .Config_accessC_bit1(Tile_X3Y2_Config_accessC_bit1),
    .Config_accessC_bit2(Tile_X3Y2_Config_accessC_bit2),
    .Config_accessC_bit3(Tile_X3Y2_Config_accessC_bit3),
    .UserCLK(Tile_X3Y3_UserCLKo),
    .UserCLKo(Tile_X3Y2_UserCLKo),
    .FrameData(Tile_X2Y2_FrameData_O),
    .FrameData_O(Tile_X3Y2_FrameData_O),
    .FrameStrobe(Tile_X3Y3_FrameStrobe_O),
    .FrameStrobe_O(Tile_X3Y2_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
W_IO
`ifdef EMULATION
    #(
    .Emulate_Bitstream(`Tile_X0Y3_Emulate_Bitstream)
    )
`endif
    Tile_X0Y3_W_IO
    (
    .W1END(Tile_X1Y3_W1BEG),
    .W2MID(Tile_X1Y3_W2BEG),
    .W2END(Tile_X1Y3_W2BEGb),
    .WW4END(Tile_X1Y3_WW4BEG),
    .W6END(Tile_X1Y3_W6BEG),
    .E1BEG(Tile_X0Y3_E1BEG),
    .E2BEG(Tile_X0Y3_E2BEG),
    .E2BEGb(Tile_X0Y3_E2BEGb),
    .EE4BEG(Tile_X0Y3_EE4BEG),
    .E6BEG(Tile_X0Y3_E6BEG),
    .A_O_top(Tile_X0Y3_A_O_top),
    .A_I_top(Tile_X0Y3_A_I_top),
    .A_T_top(Tile_X0Y3_A_T_top),
    .B_O_top(Tile_X0Y3_B_O_top),
    .B_I_top(Tile_X0Y3_B_I_top),
    .B_T_top(Tile_X0Y3_B_T_top),
    .A_config_C_bit0(Tile_X0Y3_A_config_C_bit0),
    .A_config_C_bit1(Tile_X0Y3_A_config_C_bit1),
    .A_config_C_bit2(Tile_X0Y3_A_config_C_bit2),
    .A_config_C_bit3(Tile_X0Y3_A_config_C_bit3),
    .B_config_C_bit0(Tile_X0Y3_B_config_C_bit0),
    .B_config_C_bit1(Tile_X0Y3_B_config_C_bit1),
    .B_config_C_bit2(Tile_X0Y3_B_config_C_bit2),
    .B_config_C_bit3(Tile_X0Y3_B_config_C_bit3),
    .UserCLK(UserCLK),
    .UserCLKo(Tile_X0Y3_UserCLKo),
    .FrameData(Row_Y3_FrameData),
    .FrameData_O(Tile_X0Y3_FrameData_O),
    .FrameStrobe(Column_X0_FrameStrobe),
    .FrameStrobe_O(Tile_X0Y3_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
LUT4AB
`ifdef EMULATION
    #(
    .Emulate_Bitstream(`Tile_X1Y3_Emulate_Bitstream)
    )
`endif
    Tile_X1Y3_LUT4AB
    (
    .N1END(Tile_X1Y4_N1BEG),
    .N2MID(Tile_X1Y4_N2BEG),
    .N2END(Tile_X1Y4_N2BEGb),
    .N4END(Tile_X1Y4_N4BEG),
    .NN4END(Tile_X1Y4_NN4BEG),
    .Ci(Tile_X1Y4_Co),
    .E1END(Tile_X0Y3_E1BEG),
    .E2MID(Tile_X0Y3_E2BEG),
    .E2END(Tile_X0Y3_E2BEGb),
    .EE4END(Tile_X0Y3_EE4BEG),
    .E6END(Tile_X0Y3_E6BEG),
    .S1END(Tile_X1Y2_S1BEG),
    .S2MID(Tile_X1Y2_S2BEG),
    .S2END(Tile_X1Y2_S2BEGb),
    .S4END(Tile_X1Y2_S4BEG),
    .SS4END(Tile_X1Y2_SS4BEG),
    .W1END(Tile_X2Y3_W1BEG),
    .W2MID(Tile_X2Y3_W2BEG),
    .W2END(Tile_X2Y3_W2BEGb),
    .WW4END(Tile_X2Y3_WW4BEG),
    .W6END(Tile_X2Y3_W6BEG),
    .N1BEG(Tile_X1Y3_N1BEG),
    .N2BEG(Tile_X1Y3_N2BEG),
    .N2BEGb(Tile_X1Y3_N2BEGb),
    .N4BEG(Tile_X1Y3_N4BEG),
    .NN4BEG(Tile_X1Y3_NN4BEG),
    .E1BEG(Tile_X1Y3_E1BEG),
    .E2BEG(Tile_X1Y3_E2BEG),
    .E2BEGb(Tile_X1Y3_E2BEGb),
    .EE4BEG(Tile_X1Y3_EE4BEG),
    .E6BEG(Tile_X1Y3_E6BEG),
    .S1BEG(Tile_X1Y3_S1BEG),
    .S2BEG(Tile_X1Y3_S2BEG),
    .S2BEGb(Tile_X1Y3_S2BEGb),
    .S4BEG(Tile_X1Y3_S4BEG),
    .SS4BEG(Tile_X1Y3_SS4BEG),
    .W1BEG(Tile_X1Y3_W1BEG),
    .W2BEG(Tile_X1Y3_W2BEG),
    .W2BEGb(Tile_X1Y3_W2BEGb),
    .WW4BEG(Tile_X1Y3_WW4BEG),
    .W6BEG(Tile_X1Y3_W6BEG),
    .Co(Tile_X1Y3_Co),
    .UserCLK(Tile_X1Y4_UserCLKo),
    .UserCLKo(Tile_X1Y3_UserCLKo),
    .FrameData(Tile_X0Y3_FrameData_O),
    .FrameData_O(Tile_X1Y3_FrameData_O),
    .FrameStrobe(Tile_X1Y4_FrameStrobe_O),
    .FrameStrobe_O(Tile_X1Y3_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
LUT4AB
`ifdef EMULATION
    #(
    .Emulate_Bitstream(`Tile_X2Y3_Emulate_Bitstream)
    )
`endif
    Tile_X2Y3_LUT4AB
    (
    .N1END(Tile_X2Y4_N1BEG),
    .N2MID(Tile_X2Y4_N2BEG),
    .N2END(Tile_X2Y4_N2BEGb),
    .N4END(Tile_X2Y4_N4BEG),
    .NN4END(Tile_X2Y4_NN4BEG),
    .Ci(Tile_X2Y4_Co),
    .E1END(Tile_X1Y3_E1BEG),
    .E2MID(Tile_X1Y3_E2BEG),
    .E2END(Tile_X1Y3_E2BEGb),
    .EE4END(Tile_X1Y3_EE4BEG),
    .E6END(Tile_X1Y3_E6BEG),
    .S1END(Tile_X2Y2_S1BEG),
    .S2MID(Tile_X2Y2_S2BEG),
    .S2END(Tile_X2Y2_S2BEGb),
    .S4END(Tile_X2Y2_S4BEG),
    .SS4END(Tile_X2Y2_SS4BEG),
    .W1END(Tile_X3Y3_W1BEG),
    .W2MID(Tile_X3Y3_W2BEG),
    .W2END(Tile_X3Y3_W2BEGb),
    .WW4END(Tile_X3Y3_WW4BEG),
    .W6END(Tile_X3Y3_W6BEG),
    .N1BEG(Tile_X2Y3_N1BEG),
    .N2BEG(Tile_X2Y3_N2BEG),
    .N2BEGb(Tile_X2Y3_N2BEGb),
    .N4BEG(Tile_X2Y3_N4BEG),
    .NN4BEG(Tile_X2Y3_NN4BEG),
    .E1BEG(Tile_X2Y3_E1BEG),
    .E2BEG(Tile_X2Y3_E2BEG),
    .E2BEGb(Tile_X2Y3_E2BEGb),
    .EE4BEG(Tile_X2Y3_EE4BEG),
    .E6BEG(Tile_X2Y3_E6BEG),
    .S1BEG(Tile_X2Y3_S1BEG),
    .S2BEG(Tile_X2Y3_S2BEG),
    .S2BEGb(Tile_X2Y3_S2BEGb),
    .S4BEG(Tile_X2Y3_S4BEG),
    .SS4BEG(Tile_X2Y3_SS4BEG),
    .W1BEG(Tile_X2Y3_W1BEG),
    .W2BEG(Tile_X2Y3_W2BEG),
    .W2BEGb(Tile_X2Y3_W2BEGb),
    .WW4BEG(Tile_X2Y3_WW4BEG),
    .W6BEG(Tile_X2Y3_W6BEG),
    .Co(Tile_X2Y3_Co),
    .UserCLK(Tile_X2Y4_UserCLKo),
    .UserCLKo(Tile_X2Y3_UserCLKo),
    .FrameData(Tile_X1Y3_FrameData_O),
    .FrameData_O(Tile_X2Y3_FrameData_O),
    .FrameStrobe(Tile_X2Y4_FrameStrobe_O),
    .FrameStrobe_O(Tile_X2Y3_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
RAM_IO
`ifdef EMULATION
    #(
    .Emulate_Bitstream(`Tile_X3Y3_Emulate_Bitstream)
    )
`endif
    Tile_X3Y3_RAM_IO
    (
    .N1END(Tile_X3Y4_N1BEG),
    .N2MID(Tile_X3Y4_N2BEG),
    .N2END(Tile_X3Y4_N2BEGb),
    .N4END(Tile_X3Y4_N4BEG),
    .E1END(Tile_X2Y3_E1BEG),
    .E2MID(Tile_X2Y3_E2BEG),
    .E2END(Tile_X2Y3_E2BEGb),
    .EE4END(Tile_X2Y3_EE4BEG),
    .E6END(Tile_X2Y3_E6BEG),
    .S1END(Tile_X3Y2_S1BEG),
    .S2MID(Tile_X3Y2_S2BEG),
    .S2END(Tile_X3Y2_S2BEGb),
    .S4END(Tile_X3Y2_S4BEG),
    .N1BEG(Tile_X3Y3_N1BEG),
    .N2BEG(Tile_X3Y3_N2BEG),
    .N2BEGb(Tile_X3Y3_N2BEGb),
    .N4BEG(Tile_X3Y3_N4BEG),
    .S1BEG(Tile_X3Y3_S1BEG),
    .S2BEG(Tile_X3Y3_S2BEG),
    .S2BEGb(Tile_X3Y3_S2BEGb),
    .S4BEG(Tile_X3Y3_S4BEG),
    .W1BEG(Tile_X3Y3_W1BEG),
    .W2BEG(Tile_X3Y3_W2BEG),
    .W2BEGb(Tile_X3Y3_W2BEGb),
    .WW4BEG(Tile_X3Y3_WW4BEG),
    .W6BEG(Tile_X3Y3_W6BEG),
    .RAM2FAB_D0_I0(Tile_X3Y3_RAM2FAB_D0_I0),
    .RAM2FAB_D0_I1(Tile_X3Y3_RAM2FAB_D0_I1),
    .RAM2FAB_D0_I2(Tile_X3Y3_RAM2FAB_D0_I2),
    .RAM2FAB_D0_I3(Tile_X3Y3_RAM2FAB_D0_I3),
    .RAM2FAB_D1_I0(Tile_X3Y3_RAM2FAB_D1_I0),
    .RAM2FAB_D1_I1(Tile_X3Y3_RAM2FAB_D1_I1),
    .RAM2FAB_D1_I2(Tile_X3Y3_RAM2FAB_D1_I2),
    .RAM2FAB_D1_I3(Tile_X3Y3_RAM2FAB_D1_I3),
    .RAM2FAB_D2_I0(Tile_X3Y3_RAM2FAB_D2_I0),
    .RAM2FAB_D2_I1(Tile_X3Y3_RAM2FAB_D2_I1),
    .RAM2FAB_D2_I2(Tile_X3Y3_RAM2FAB_D2_I2),
    .RAM2FAB_D2_I3(Tile_X3Y3_RAM2FAB_D2_I3),
    .RAM2FAB_D3_I0(Tile_X3Y3_RAM2FAB_D3_I0),
    .RAM2FAB_D3_I1(Tile_X3Y3_RAM2FAB_D3_I1),
    .RAM2FAB_D3_I2(Tile_X3Y3_RAM2FAB_D3_I2),
    .RAM2FAB_D3_I3(Tile_X3Y3_RAM2FAB_D3_I3),
    .FAB2RAM_D0_O0(Tile_X3Y3_FAB2RAM_D0_O0),
    .FAB2RAM_D0_O1(Tile_X3Y3_FAB2RAM_D0_O1),
    .FAB2RAM_D0_O2(Tile_X3Y3_FAB2RAM_D0_O2),
    .FAB2RAM_D0_O3(Tile_X3Y3_FAB2RAM_D0_O3),
    .FAB2RAM_D1_O0(Tile_X3Y3_FAB2RAM_D1_O0),
    .FAB2RAM_D1_O1(Tile_X3Y3_FAB2RAM_D1_O1),
    .FAB2RAM_D1_O2(Tile_X3Y3_FAB2RAM_D1_O2),
    .FAB2RAM_D1_O3(Tile_X3Y3_FAB2RAM_D1_O3),
    .FAB2RAM_D2_O0(Tile_X3Y3_FAB2RAM_D2_O0),
    .FAB2RAM_D2_O1(Tile_X3Y3_FAB2RAM_D2_O1),
    .FAB2RAM_D2_O2(Tile_X3Y3_FAB2RAM_D2_O2),
    .FAB2RAM_D2_O3(Tile_X3Y3_FAB2RAM_D2_O3),
    .FAB2RAM_D3_O0(Tile_X3Y3_FAB2RAM_D3_O0),
    .FAB2RAM_D3_O1(Tile_X3Y3_FAB2RAM_D3_O1),
    .FAB2RAM_D3_O2(Tile_X3Y3_FAB2RAM_D3_O2),
    .FAB2RAM_D3_O3(Tile_X3Y3_FAB2RAM_D3_O3),
    .FAB2RAM_A0_O0(Tile_X3Y3_FAB2RAM_A0_O0),
    .FAB2RAM_A0_O1(Tile_X3Y3_FAB2RAM_A0_O1),
    .FAB2RAM_A0_O2(Tile_X3Y3_FAB2RAM_A0_O2),
    .FAB2RAM_A0_O3(Tile_X3Y3_FAB2RAM_A0_O3),
    .FAB2RAM_A1_O0(Tile_X3Y3_FAB2RAM_A1_O0),
    .FAB2RAM_A1_O1(Tile_X3Y3_FAB2RAM_A1_O1),
    .FAB2RAM_A1_O2(Tile_X3Y3_FAB2RAM_A1_O2),
    .FAB2RAM_A1_O3(Tile_X3Y3_FAB2RAM_A1_O3),
    .FAB2RAM_C_O0(Tile_X3Y3_FAB2RAM_C_O0),
    .FAB2RAM_C_O1(Tile_X3Y3_FAB2RAM_C_O1),
    .FAB2RAM_C_O2(Tile_X3Y3_FAB2RAM_C_O2),
    .FAB2RAM_C_O3(Tile_X3Y3_FAB2RAM_C_O3),
    .Config_accessC_bit0(Tile_X3Y3_Config_accessC_bit0),
    .Config_accessC_bit1(Tile_X3Y3_Config_accessC_bit1),
    .Config_accessC_bit2(Tile_X3Y3_Config_accessC_bit2),
    .Config_accessC_bit3(Tile_X3Y3_Config_accessC_bit3),
    .UserCLK(Tile_X3Y4_UserCLKo),
    .UserCLKo(Tile_X3Y3_UserCLKo),
    .FrameData(Tile_X2Y3_FrameData_O),
    .FrameData_O(Tile_X3Y3_FrameData_O),
    .FrameStrobe(Tile_X3Y4_FrameStrobe_O),
    .FrameStrobe_O(Tile_X3Y3_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
S_term_single Tile_X1Y4_S_term_single (
    .S1END(Tile_X1Y3_S1BEG),
    .S2MID(Tile_X1Y3_S2BEG),
    .S2END(Tile_X1Y3_S2BEGb),
    .S4END(Tile_X1Y3_S4BEG),
    .SS4END(Tile_X1Y3_SS4BEG),
    .N1BEG(Tile_X1Y4_N1BEG),
    .N2BEG(Tile_X1Y4_N2BEG),
    .N2BEGb(Tile_X1Y4_N2BEGb),
    .N4BEG(Tile_X1Y4_N4BEG),
    .NN4BEG(Tile_X1Y4_NN4BEG),
    .Co(Tile_X1Y4_Co),
    .UserCLK(UserCLK),
    .UserCLKo(Tile_X1Y4_UserCLKo),
    .FrameData(Row_Y4_FrameData),
    .FrameData_O(Tile_X1Y4_FrameData_O),
    .FrameStrobe(Column_X1_FrameStrobe),
    .FrameStrobe_O(Tile_X1Y4_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
S_term_single Tile_X2Y4_S_term_single (
    .S1END(Tile_X2Y3_S1BEG),
    .S2MID(Tile_X2Y3_S2BEG),
    .S2END(Tile_X2Y3_S2BEGb),
    .S4END(Tile_X2Y3_S4BEG),
    .SS4END(Tile_X2Y3_SS4BEG),
    .N1BEG(Tile_X2Y4_N1BEG),
    .N2BEG(Tile_X2Y4_N2BEG),
    .N2BEGb(Tile_X2Y4_N2BEGb),
    .N4BEG(Tile_X2Y4_N4BEG),
    .NN4BEG(Tile_X2Y4_NN4BEG),
    .Co(Tile_X2Y4_Co),
    .UserCLK(UserCLK),
    .UserCLKo(Tile_X2Y4_UserCLKo),
    .FrameData(Tile_X1Y4_FrameData_O),
    .FrameData_O(Tile_X2Y4_FrameData_O),
    .FrameStrobe(Column_X2_FrameStrobe),
    .FrameStrobe_O(Tile_X2Y4_FrameStrobe_O)
);


 //tile IO port will get directly connected to top-level tile module
S_term_RAM_IO Tile_X3Y4_S_term_RAM_IO (
    .S1END(Tile_X3Y3_S1BEG),
    .S2MID(Tile_X3Y3_S2BEG),
    .S2END(Tile_X3Y3_S2BEGb),
    .S4END(Tile_X3Y3_S4BEG),
    .N1BEG(Tile_X3Y4_N1BEG),
    .N2BEG(Tile_X3Y4_N2BEG),
    .N2BEGb(Tile_X3Y4_N2BEGb),
    .N4BEG(Tile_X3Y4_N4BEG),
    .UserCLK(UserCLK),
    .UserCLKo(Tile_X3Y4_UserCLKo),
    .FrameData(Tile_X2Y4_FrameData_O),
    .FrameData_O(Tile_X3Y4_FrameData_O),
    .FrameStrobe(Column_X3_FrameStrobe),
    .FrameStrobe_O(Tile_X3Y4_FrameStrobe_O)
);

endmodule