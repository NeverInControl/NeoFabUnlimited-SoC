-- ================================================================================ --
-- NEO FAB UNLIMITED SOC top module --
-- ================================================================================ --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neorv32;
use neorv32.neorv32_package.all;

entity neo_fab_unlimited_soc is
  generic (
    CLOCK_FREQUENCY : natural := 100000000; -- clock frequency of clk_i in Hz
    MEM_SIZE        : natural := 64*1024;   -- size of total memory
    HW_VERSION      : std_ulogic_vector(31 downto 0) := x"FAB00001"
  );
  port (
    -- Global control --
    clk_i       : in  std_ulogic; -- global clock, rising edge
    rstn_i      : in  std_ulogic; -- global reset, low-active, async
    -- GPIO --
    gpio_o      : out std_ulogic_vector(7 downto 0); -- parallel output
    -- UART0 --
    uart0_txd_o : out std_ulogic; -- UART0 send data
    uart0_rxd_i : in  std_ulogic  -- UART0 receive data
  );
end entity;

architecture neo_fab_unlimited_soc_rtl of neo_fab_unlimited_soc is

  signal con_gpio_out : std_ulogic_vector(31 downto 0);
  
  -- NeoRV32 Master Bus Signals (Master 0)
  signal cpu_wb_cyc   : std_ulogic;
  signal cpu_wb_stb   : std_ulogic;
  signal cpu_wb_stb_stretched : std_ulogic; --for the WB B3-B4 bridge
  signal cpu_wb_we    : std_ulogic;
  signal cpu_wb_sel   : std_ulogic_vector(3 downto 0);
  signal cpu_wb_adr   : std_ulogic_vector(31 downto 0);
  signal cpu_wb_dat_o : std_ulogic_vector(31 downto 0);
  signal cpu_wb_dat_i : std_ulogic_vector(31 downto 0);
  signal cpu_wb_ack   : std_ulogic;
  signal cpu_wb_err   : std_ulogic;

  -- BRAM Slave Bus Signals (Slave 0)
  signal bram_wb_cyc   : std_ulogic;
  signal bram_wb_stb   : std_ulogic;
  signal bram_wb_we    : std_ulogic;
  signal bram_wb_sel   : std_ulogic_vector(3 downto 0);
  signal bram_wb_adr   : std_ulogic_vector(31 downto 0);
  signal bram_wb_dat_i : std_ulogic_vector(31 downto 0);
  signal bram_wb_dat_o : std_ulogic_vector(31 downto 0);
  signal bram_wb_ack   : std_ulogic;
  
  -- Manager Slave Bus Signals (Slave 1)
  signal manager_wb_cyc   : std_ulogic;
  signal manager_wb_stb   : std_ulogic;
  signal manager_wb_we    : std_ulogic;
  signal manager_wb_sel   : std_ulogic_vector(3 downto 0);
  signal manager_wb_adr   : std_ulogic_vector(31 downto 0);
  signal manager_wb_dat_i : std_ulogic_vector(31 downto 0);
  signal manager_wb_dat_o : std_ulogic_vector(31 downto 0);
  signal manager_wb_ack   : std_ulogic;

  -- SoC communicating to Fabric (Mux Slave 2 outputs -> Decoupler CH1)
  signal mux2dec_s_cyc   : std_ulogic;
  signal mux2dec_s_stb   : std_ulogic;
  signal mux2dec_s_we    : std_ulogic;
  signal mux2dec_s_sel   : std_ulogic_vector(3 downto 0);
  signal mux2dec_s_adr   : std_ulogic_vector(31 downto 0);
  signal mux2dec_s_dat_i : std_ulogic_vector(31 downto 0);
  signal mux2dec_s_dat_o : std_ulogic_vector(31 downto 0);
  signal mux2dec_s_ack   : std_ulogic;
  signal mux2dec_s_err   : std_ulogic;

  -- Decoupler CH1 outputs -> eFPGA Fabric Wrapper Slave Port
  signal dec2fab_s_cyc   : std_ulogic;
  signal dec2fab_s_stb   : std_ulogic;
  signal dec2fab_s_we    : std_ulogic;
  signal dec2fab_s_sel   : std_ulogic_vector(3 downto 0);
  signal dec2fab_s_adr   : std_ulogic_vector(31 downto 0);
  signal dec2fab_s_dat_i : std_ulogic_vector(31 downto 0);
  signal dec2fab_s_dat_o : std_ulogic_vector(31 downto 0);
  signal dec2fab_s_ack   : std_ulogic;
  signal dec2fab_s_err   : std_ulogic;

  -- eFPGA Fabric Wrapper Master Port -> Decoupler CH2
  signal fab2dec_m_cyc   : std_ulogic;
  signal fab2dec_m_stb   : std_ulogic;
  signal fab2dec_m_we    : std_ulogic;
  signal fab2dec_m_sel   : std_ulogic_vector(3 downto 0);
  signal fab2dec_m_adr   : std_ulogic_vector(31 downto 0);
  signal fab2dec_m_dat_o : std_ulogic_vector(31 downto 0);
  signal fab2dec_m_dat_i : std_ulogic_vector(31 downto 0);
  signal fab2dec_m_ack   : std_ulogic;
  signal fab2dec_m_err   : std_ulogic;

  -- Decoupler CH2 outputs -> Arbiter Master 1
  signal dec2arb_m_cyc   : std_ulogic;
  signal dec2arb_m_stb   : std_ulogic;
  signal dec2arb_m_we    : std_ulogic;
  signal dec2arb_m_sel   : std_ulogic_vector(3 downto 0);
  signal dec2arb_m_adr   : std_ulogic_vector(31 downto 0);
  signal dec2arb_m_dat_o : std_ulogic_vector(31 downto 0);
  signal dec2arb_m_dat_i : std_ulogic_vector(31 downto 0);
  signal dec2arb_m_ack   : std_ulogic;
  signal dec2arb_m_err   : std_ulogic;
  
  -- Physical Shared Bus Wires
  signal shared_wb_cyc   : std_ulogic;
  signal shared_wb_stb   : std_ulogic;
  signal shared_wb_we    : std_ulogic;
  signal shared_wb_sel   : std_ulogic_vector(3 downto 0);
  signal shared_wb_adr   : std_ulogic_vector(31 downto 0);
  signal shared_wb_dat_m : std_ulogic_vector(31 downto 0); 
  signal shared_wb_dat_s : std_ulogic_vector(31 downto 0); 
  signal shared_wb_ack   : std_ulogic;
  signal shared_wb_err   : std_ulogic;
  signal shared_wb_rty   : std_ulogic;
  signal shared_wb_cti   : std_ulogic_vector(2 downto 0);
  signal shared_wb_bte   : std_ulogic_vector(1 downto 0);

  -- Interconnect Arrays
  signal masters_adr_i : std_ulogic_vector(63 downto 0);
  signal masters_dat_i : std_ulogic_vector(63 downto 0);
  signal masters_sel_i : std_ulogic_vector(7 downto 0);
  signal masters_we_i  : std_ulogic_vector(1 downto 0);
  signal masters_cyc_i : std_ulogic_vector(1 downto 0);
  signal masters_stb_i : std_ulogic_vector(1 downto 0);
  signal masters_cti_i : std_ulogic_vector(5 downto 0);
  signal masters_bte_i : std_ulogic_vector(3 downto 0);
  
  signal masters_dat_o : std_ulogic_vector(63 downto 0);
  signal masters_ack_o : std_ulogic_vector(1 downto 0);
  signal masters_err_o : std_ulogic_vector(1 downto 0);
  signal masters_rty_o : std_ulogic_vector(1 downto 0);

  signal slaves_adr_o : std_ulogic_vector(95 downto 0);
  signal slaves_dat_o : std_ulogic_vector(95 downto 0);
  signal slaves_sel_o : std_ulogic_vector(11 downto 0);
  signal slaves_we_o  : std_ulogic_vector(2 downto 0);
  signal slaves_cyc_o : std_ulogic_vector(2 downto 0);
  signal slaves_stb_o : std_ulogic_vector(2 downto 0);
  signal slaves_cti_o : std_ulogic_vector(8 downto 0);
  signal slaves_bte_o : std_ulogic_vector(5 downto 0);
  
  signal slaves_dat_i : std_ulogic_vector(95 downto 0);
  signal slaves_ack_i : std_ulogic_vector(2 downto 0);
  signal slaves_err_i : std_ulogic_vector(2 downto 0);
  signal slaves_rty_i : std_ulogic_vector(2 downto 0);
  
  -- Manager / FPGA Signals
  signal efpga_config_data       : std_ulogic_vector(31 downto 0);
  signal efpga_config_we         : std_ulogic;
  signal efpga_debug_out         : std_ulogic_vector(5 downto 0); 
  
  signal rst_local : std_ulogic;
  signal fpga_rst  : std_ulogic;
  
  signal efpga_soft_reset : std_ulogic;
  signal efpga_com_active : std_ulogic;
  
  signal efpga_o_top      : std_ulogic_vector(7 downto 0);
  
  signal efpga_ram_d_i : std_ulogic_vector(47 downto 0) := (others => '0');
  signal efpga_ram_d_o : std_ulogic_vector(47 downto 0);
  signal efpga_ram_a_o : std_ulogic_vector(23 downto 0);
  signal efpga_ram_c_o : std_ulogic_vector(11 downto 0);
  
  -- Decoupler Control Signals
  signal dec0_req         : std_ulogic;
  signal dec0_force       : std_ulogic;
  signal dec0_is_dec      : std_ulogic;
  signal dec0_host_act    : std_ulogic;
  signal dec0_dma_act     : std_ulogic;
  
  component wb_bram is
    generic (
      MEM_SIZE_BYTES : natural := 64*1024
    );
    port (
      clk_i    : in  std_ulogic;
      rst_i    : in  std_ulogic;
      wb_cyc_i : in  std_ulogic;
      wb_stb_i : in  std_ulogic;
      wb_we_i  : in  std_ulogic;
      wb_sel_i : in  std_ulogic_vector(3 downto 0);
      wb_adr_i : in  std_ulogic_vector(31 downto 0);
      wb_dat_i : in  std_ulogic_vector(31 downto 0);
      wb_dat_o : out std_ulogic_vector(31 downto 0);
      wb_ack_o : out std_ulogic
    );
  end component;
  
  component efpga_manager is
    generic (
      HW_VERSION : std_ulogic_vector(31 downto 0) := x"FAB00001"
    );
    port (
      clk_i    : in  std_ulogic;
      rst_i    : in  std_ulogic;
      wb_cyc_i : in  std_ulogic;
      wb_stb_i : in  std_ulogic;
      wb_we_i  : in  std_ulogic;
      wb_sel_i : in  std_ulogic_vector(3 downto 0);
      wb_adr_i : in  std_ulogic_vector(31 downto 0);
      wb_dat_i : in  std_ulogic_vector(31 downto 0);
      wb_dat_o : out std_ulogic_vector(31 downto 0);
      wb_ack_o : out std_ulogic;
      
      -- Direct eFPGA Interfacing
      efpga_config_data_o : out std_ulogic_vector(31 downto 0);
      efpga_config_we_o   : out std_ulogic;
      
      -- Hardware Status & Control
      efpga_soft_reset_o  : out std_ulogic;
      efpga_com_active_i  : in  std_ulogic;
      
      -- Slot 0 Interfacing
      slot0_i_top_i       : in  std_ulogic_vector(7 downto 0);
      slot0_o_top_o       : out std_ulogic_vector(7 downto 0);
      
      -- Decoupler 0
      decoupler0_req_o          : out std_ulogic;
      decoupler0_force_o        : out std_ulogic;
      decoupler0_is_decoupled_i : in std_ulogic;
      decoupler0_host_act_i     : in std_ulogic;
      decoupler0_dma_act_i      : in std_ulogic
    );
  end component;
  
  component eFPGA_top is
    port (
        A_config_C      : out std_ulogic_vector(11 downto 0);
        B_config_C      : out std_ulogic_vector(11 downto 0);
        Config_accessC  : out std_ulogic_vector(11 downto 0);
        I_top           : out std_ulogic_vector(5 downto 0);
        O_top           : in  std_ulogic_vector(5 downto 0);
        T_top           : out std_ulogic_vector(5 downto 0);
        CLK             : in  std_ulogic;
        resetn          : in  std_ulogic;
        SelfWriteStrobe : in  std_ulogic;
        SelfWriteData   : in  std_ulogic_vector(31 downto 0);
        Rx              : in  std_ulogic;
        ComActive       : out std_ulogic;
        ReceiveLED      : out std_ulogic;
        s_clk           : in  std_ulogic;
        s_data          : in  std_ulogic;
        
        RAM2FAB_D_I     : in  std_ulogic_vector(47 downto 0);
        FAB2RAM_D_O     : out std_ulogic_vector(47 downto 0);
        FAB2RAM_A_O     : out std_ulogic_vector(23 downto 0);
        FAB2RAM_C_O     : out std_ulogic_vector(11 downto 0)
    );
  end component;
  
  component wb_arbiter is
    generic (
      dw : integer := 32;
      aw : integer := 32;
      num_masters : integer := 2
    );
    port (
      wb_clk_i  : in  std_ulogic;
      wb_rst_i  : in  std_ulogic;
      
      wbm_adr_i : in  std_ulogic_vector(63 downto 0);
      wbm_dat_i : in  std_ulogic_vector(63 downto 0);
      wbm_sel_i : in  std_ulogic_vector(7 downto 0);
      wbm_we_i  : in  std_ulogic_vector(1 downto 0);
      wbm_cyc_i : in  std_ulogic_vector(1 downto 0);
      wbm_stb_i : in  std_ulogic_vector(1 downto 0);
      wbm_cti_i : in  std_ulogic_vector(5 downto 0);
      wbm_bte_i : in  std_ulogic_vector(3 downto 0);
      
      wbm_dat_o : out std_ulogic_vector(63 downto 0);
      wbm_ack_o : out std_ulogic_vector(1 downto 0);
      wbm_err_o : out std_ulogic_vector(1 downto 0);
      wbm_rty_o : out std_ulogic_vector(1 downto 0);

      wbs_adr_o : out std_ulogic_vector(31 downto 0);
      wbs_dat_o : out std_ulogic_vector(31 downto 0);
      wbs_sel_o : out std_ulogic_vector(3 downto 0);
      wbs_we_o  : out std_ulogic;
      wbs_cyc_o : out std_ulogic;
      wbs_stb_o : out std_ulogic;
      wbs_cti_o : out std_ulogic_vector(2 downto 0);
      wbs_bte_o : out std_ulogic_vector(1 downto 0);
      
      wbs_dat_i : in  std_ulogic_vector(31 downto 0);
      wbs_ack_i : in  std_ulogic;
      wbs_err_i : in  std_ulogic;
      wbs_rty_i : in  std_ulogic
    );
  end component;

  component wb_mux is
    generic (
      dw : integer := 32;
      aw : integer := 32;
      num_slaves : integer := 3;
      MATCH_ADDR : std_ulogic_vector(95 downto 0); 
      MATCH_MASK : std_ulogic_vector(95 downto 0)
    );
    port (
      wb_clk_i  : in  std_ulogic;
      wb_rst_i  : in  std_ulogic;
      wbm_adr_i : in  std_ulogic_vector(31 downto 0);
      wbm_dat_i : in  std_ulogic_vector(31 downto 0);
      wbm_sel_i : in  std_ulogic_vector(3 downto 0);
      wbm_we_i  : in  std_ulogic;
      wbm_cyc_i : in  std_ulogic;
      wbm_stb_i : in  std_ulogic;
      wbm_cti_i : in  std_ulogic_vector(2 downto 0);
      wbm_bte_i : in  std_ulogic_vector(1 downto 0);
      wbm_dat_o : out std_ulogic_vector(31 downto 0);
      wbm_ack_o : out std_ulogic;
      wbm_err_o : out std_ulogic;
      wbm_rty_o : out std_ulogic;
      wbs_adr_o : out std_ulogic_vector(95 downto 0);
      wbs_dat_o : out std_ulogic_vector(95 downto 0);
      wbs_sel_o : out std_ulogic_vector(11 downto 0);
      wbs_we_o  : out std_ulogic_vector(2 downto 0);
      wbs_cyc_o : out std_ulogic_vector(2 downto 0);
      wbs_stb_o : out std_ulogic_vector(2 downto 0);
      wbs_cti_o : out std_ulogic_vector(8 downto 0);
      wbs_bte_o : out std_ulogic_vector(5 downto 0);
      wbs_dat_i : in  std_ulogic_vector(95 downto 0);
      wbs_ack_i : in  std_ulogic_vector(2 downto 0);
      wbs_err_i : in  std_ulogic_vector(2 downto 0);
      wbs_rty_i : in  std_ulogic_vector(2 downto 0)
    );
  end component;
  
  component wb_decoupler_bidir
  port (
    clk_i              : in  std_ulogic;
    rst_i              : in  std_ulogic;
    
    decouple_req_i     : in  std_ulogic;
    force_decouple_i   : in  std_ulogic;
    is_decoupled_o     : out std_ulogic;
    host_active_o      : out std_ulogic;
    dma_active_o       : out std_ulogic;

    -- CH1 SLAVE (Faces Host)
    h2f_s_adr_i        : in  std_ulogic_vector(31 downto 0);
    h2f_s_dat_i        : in  std_ulogic_vector(31 downto 0);
    h2f_s_sel_i        : in  std_ulogic_vector(3 downto 0);
    h2f_s_we_i         : in  std_ulogic;
    h2f_s_cyc_i        : in  std_ulogic;
    h2f_s_stb_i        : in  std_ulogic;
    h2f_s_dat_o        : out std_ulogic_vector(31 downto 0);
    h2f_s_ack_o        : out std_ulogic;
    h2f_s_err_o        : out std_ulogic;

    -- CH1 MASTER (Faces Target RAM)
    h2f_m_adr_o        : out std_ulogic_vector(31 downto 0);
    h2f_m_dat_o        : out std_ulogic_vector(31 downto 0);
    h2f_m_sel_o        : out std_ulogic_vector(3 downto 0);
    h2f_m_we_o         : out std_ulogic;
    h2f_m_cyc_o        : out std_ulogic;
    h2f_m_stb_o        : out std_ulogic;
    h2f_m_dat_i        : in  std_ulogic_vector(31 downto 0);
    h2f_m_ack_i        : in  std_ulogic;
    h2f_m_err_i        : in  std_ulogic;

    -- CH2 SLAVE (Faces Fabric DMA)
    f2h_s_adr_i        : in  std_ulogic_vector(31 downto 0);
    f2h_s_dat_i        : in  std_ulogic_vector(31 downto 0);
    f2h_s_sel_i        : in  std_ulogic_vector(3 downto 0);
    f2h_s_we_i         : in  std_ulogic;
    f2h_s_cyc_i        : in  std_ulogic;
    f2h_s_stb_i        : in  std_ulogic;
    f2h_s_dat_o        : out std_ulogic_vector(31 downto 0);
    f2h_s_ack_o        : out std_ulogic;
    f2h_s_err_o        : out std_ulogic;
    
    -- CH2 MASTER (Faces Host Bus)
    f2h_m_adr_o        : out std_ulogic_vector(31 downto 0);
    f2h_m_dat_o        : out std_ulogic_vector(31 downto 0);
    f2h_m_sel_o        : out std_ulogic_vector(3 downto 0);
    f2h_m_we_o         : out std_ulogic;
    f2h_m_cyc_o        : out std_ulogic;
    f2h_m_stb_o        : out std_ulogic;
    f2h_m_dat_i        : in  std_ulogic_vector(31 downto 0);
    f2h_m_ack_i        : in  std_ulogic;
    f2h_m_err_i        : in  std_ulogic
  );
  end component;


  -- ILA Debug Probes
  attribute mark_debug : string;
  
  -- Unmapped RamIO signals
  attribute mark_debug of efpga_ram_d_o   : signal is "true";
  attribute mark_debug of efpga_ram_a_o   : signal is "true";
  attribute mark_debug of efpga_ram_c_o   : signal is "true";

  -- Master signals BEFORE Decoupler (From Fabric)
  attribute mark_debug of fab2dec_m_cyc   : signal is "true";
  attribute mark_debug of fab2dec_m_stb   : signal is "true";
  attribute mark_debug of fab2dec_m_we    : signal is "true";
  attribute mark_debug of fab2dec_m_sel   : signal is "true";
  attribute mark_debug of fab2dec_m_ack   : signal is "true";
  attribute mark_debug of fab2dec_m_adr   : signal is "true";
  attribute mark_debug of fab2dec_m_dat_o : signal is "true";
  attribute mark_debug of fab2dec_m_dat_i : signal is "true";

  -- Master signals AFTER Decoupler (To Arbiter)
  attribute mark_debug of dec2arb_m_cyc   : signal is "true";
  attribute mark_debug of dec2arb_m_stb   : signal is "true";
  attribute mark_debug of dec2arb_m_we    : signal is "true";
  attribute mark_debug of dec2arb_m_sel   : signal is "true";
  attribute mark_debug of dec2arb_m_ack   : signal is "true";
  attribute mark_debug of dec2arb_m_adr   : signal is "true";
  attribute mark_debug of dec2arb_m_dat_o : signal is "true";
  attribute mark_debug of dec2arb_m_dat_i : signal is "true";



begin

  rst_local <= not rstn_i;
  fpga_rst <= rstn_i and not(efpga_soft_reset);
  
  -- GPIO output --
  gpio_o <= con_gpio_out(7 downto 0);

  -- -------------------------------------------------------------------------------------------
  -- The Core Of The Problem ----------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  neorv32_top_inst: neorv32_top
  generic map (
    -- Clocking --
    CLOCK_FREQUENCY  => CLOCK_FREQUENCY,   -- clock frequency of clk_i in Hz
    -- Boot Configuration --
    BOOT_MODE_SELECT => 0,                 -- boot via internal bootloader
    -- RISC-V CPU Extensions --
    RISCV_ISA_C      => true,              -- implement compressed extension?
    RISCV_ISA_M      => true,              -- implement mul/div extension?
    RISCV_ISA_Zicntr => true,              -- implement base counters?
    -- Internal Memory  --
    -- Internal Instruction memory (IMEM) --
    IMEM_EN   => false,
    IMEM_BASE => x"00000000",
    IMEM_SIZE => 32*1024,
    -- Internal Data memory (DMEM) --
    DMEM_EN   => false,
    DMEM_BASE => x"00008000",
    DMEM_SIZE => 32*1024,
    -- External Wishbone Bus --
    XBUS_EN          => true,
    XBUS_TIMEOUT     => 255,
    -- Processor peripherals --
    IO_GPIO_NUM      => 8,                 -- number of GPIO input/output pairs (0..32)
    IO_CLINT_EN      => true,              -- implement core local interruptor (CLINT)?
    IO_UART0_EN      => true               -- implement primary universal asynchronous receiver/transmitter (UART0)?
  )
  port map (
    -- Global control --
    clk_i       => clk_i,        -- global clock, rising edge
    rstn_i      => rstn_i,       -- global reset, low-active, async
    -- GPIO (available if IO_GPIO_NUM > 0) --
    gpio_o      => con_gpio_out, -- parallel output
    -- primary UART0 (available if IO_UART0_EN = true)
    uart0_txd_o => uart0_txd_o,  -- UART0 send data
    uart0_rxd_i => uart0_rxd_i,  -- UART0 receive data
    -- XBUS
    xbus_cyc_o => cpu_wb_cyc,
    xbus_stb_o => cpu_wb_stb,
    xbus_we_o  => cpu_wb_we,
    xbus_sel_o => cpu_wb_sel,
    xbus_adr_o => cpu_wb_adr,
    xbus_dat_o => cpu_wb_dat_o,
    xbus_dat_i => cpu_wb_dat_i,
    xbus_ack_i => cpu_wb_ack,
    xbus_err_i => cpu_wb_err,
    xbus_err_i => '0'
  );

  -- -------------------------------------------------------------------------------------------
  -- B3 to B4 (Pipelined) Wishbone Adapter (STB Stretch)
  -- -------------------------------------------------------------------------------------------
  process(clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_local = '1' then
        cpu_wb_stb_stretched <= '0';
      else
        -- Latch STB high when the CPU pulses it
        if cpu_wb_stb = '1' then
          cpu_wb_stb_stretched <= '1';
        -- Drop it when the transaction gets an ACK, ERR, or the CPU drops CYC (abort)
        elsif cpu_wb_ack = '1' or cpu_wb_err = '1' or cpu_wb_cyc = '0' then
          cpu_wb_stb_stretched <= '0';
        end if;
      end if;
    end if;
  end process;
  
  -- -------------------------------------------------------------------------------------------
  -- Pack Masters (Master 1 = Tied Off, Master 0 = NeoRV32)
  -- -------------------------------------------------------------------------------------------

  -- Vector logic: Upper bits are Master 1, lower bits are Master 0
  masters_adr_i <= dec2arb_m_adr & cpu_wb_adr;
  masters_dat_i <= dec2arb_m_dat_o & cpu_wb_dat_o;
  masters_sel_i <= dec2arb_m_sel & cpu_wb_sel;
  masters_we_i  <= dec2arb_m_we  & cpu_wb_we;
  masters_cyc_i <= dec2arb_m_cyc & cpu_wb_cyc;
  masters_stb_i <= dec2arb_m_stb & (cpu_wb_stb or cpu_wb_stb_stretched);
  masters_cti_i <= "000"         & "000"; 
  masters_bte_i <= "00"          & "00";
  
  -- Feed Interconnect Data back to NeoRV32
  cpu_wb_dat_i <= masters_dat_o(31 downto 0);
  cpu_wb_ack   <= masters_ack_o(0);
  cpu_wb_err   <= masters_err_o(0);

  -- Feed Interconnect Data back to Decoupler CH2
  dec2arb_m_dat_i <= masters_dat_o(63 downto 32);
  dec2arb_m_ack   <= masters_ack_o(1);
  dec2arb_m_err   <= masters_err_o(1);

  -- -------------------------------------------------------------------------------------------
  -- The Shared Bus Arbiter
  -- -------------------------------------------------------------------------------------------

  wb_arbiter_inst: wb_arbiter
  generic map (
    num_masters => 2
  )
  port map (
    wb_clk_i  => clk_i,
    wb_rst_i  => rst_local,
    
    wbm_adr_i => masters_adr_i,
    wbm_dat_i => masters_dat_i,
    wbm_sel_i => masters_sel_i,
    wbm_we_i  => masters_we_i,
    wbm_cyc_i => masters_cyc_i,
    wbm_stb_i => masters_stb_i,
    wbm_cti_i => masters_cti_i,
    wbm_bte_i => masters_bte_i,
    
    wbm_dat_o => masters_dat_o,
    wbm_ack_o => masters_ack_o,
    wbm_err_o => masters_err_o,
    wbm_rty_o => masters_rty_o,

    -- Singular Shared Bus Wires
    wbs_adr_o => shared_wb_adr,
    wbs_dat_o => shared_wb_dat_m,
    wbs_sel_o => shared_wb_sel,
    wbs_we_o  => shared_wb_we,
    wbs_cyc_o => shared_wb_cyc,
    wbs_stb_o => shared_wb_stb,
    wbs_cti_o => shared_wb_cti,
    wbs_bte_o => shared_wb_bte,
    
    wbs_dat_i => shared_wb_dat_s,
    wbs_ack_i => shared_wb_ack,
    wbs_err_i => shared_wb_err,
    wbs_rty_i => shared_wb_rty
  );

  -- -------------------------------------------------------------------------------------------
  -- The Shared Bus Multiplexer
  -- -------------------------------------------------------------------------------------------

  wb_mux_inst: wb_mux
  generic map (
    num_slaves => 3,
    -- Slv2 (eFPGA: 0x20000000) | Slv1 (Manager: 0x10000000) | Slv0 (BRAM: 0x00000000)
    MATCH_ADDR => x"200000001000000000000000",
    MATCH_MASK => x"FFFF0000FFFFFF00FFFF0000" 
  )
  port map (
    wb_clk_i  => clk_i,
    wb_rst_i  => rst_local,
    -- Shared Inputs
    wbm_adr_i => shared_wb_adr,
    wbm_dat_i => shared_wb_dat_m,
    wbm_sel_i => shared_wb_sel,
    wbm_we_i  => shared_wb_we,
    wbm_cyc_i => shared_wb_cyc,
    wbm_stb_i => shared_wb_stb,
    wbm_cti_i => shared_wb_cti,
    wbm_bte_i => shared_wb_bte,
    wbm_dat_o => shared_wb_dat_s,
    wbm_ack_o => shared_wb_ack,
    wbm_err_o => shared_wb_err,
    wbm_rty_o => shared_wb_rty,
    -- Split Outputs
    wbs_adr_o => slaves_adr_o,
    wbs_dat_o => slaves_dat_o,
    wbs_sel_o => slaves_sel_o,
    wbs_we_o  => slaves_we_o,
    wbs_cyc_o => slaves_cyc_o,
    wbs_stb_o => slaves_stb_o,
    wbs_cti_o => slaves_cti_o,
    wbs_bte_o => slaves_bte_o,
    wbs_dat_i => slaves_dat_i,
    wbs_ack_i => slaves_ack_i,
    wbs_err_i => slaves_err_i,
    wbs_rty_i => slaves_rty_i
  );

  -- -------------------------------------------------------------------------------------------
  -- Unpack Slaves (Slave 1 = Tied Off, Slave 0 = BRAM)
  -- -------------------------------------------------------------------------------------------

  -- Slave 0: BRAM (Direct)
  bram_wb_adr   <= slaves_adr_o(31 downto 0);
  bram_wb_dat_i <= slaves_dat_o(31 downto 0);
  bram_wb_sel   <= slaves_sel_o(3 downto 0);
  bram_wb_we    <= slaves_we_o(0);
  bram_wb_cyc   <= slaves_cyc_o(0);
  bram_wb_stb   <= slaves_stb_o(0);

  -- Slave 1: Manager (Direct)
  manager_wb_adr   <= slaves_adr_o(63 downto 32);
  manager_wb_dat_i <= slaves_dat_o(63 downto 32);
  manager_wb_sel   <= slaves_sel_o(7 downto 4);
  manager_wb_we    <= slaves_we_o(1);
  manager_wb_cyc   <= slaves_cyc_o(1);
  manager_wb_stb   <= slaves_stb_o(1);

  -- Slave 2: SoC talking to Fabric (Through Decoupler)
  mux2dec_s_adr   <= slaves_adr_o(95 downto 64);
  mux2dec_s_dat_i <= slaves_dat_o(95 downto 64);
  mux2dec_s_sel   <= slaves_sel_o(11 downto 8);
  mux2dec_s_we    <= slaves_we_o(2);
  mux2dec_s_cyc   <= slaves_cyc_o(2);
  mux2dec_s_stb   <= slaves_stb_o(2);

  -- Repack responses to Mux
  slaves_dat_i <= mux2dec_s_dat_o & manager_wb_dat_o & bram_wb_dat_o;
  slaves_ack_i <= mux2dec_s_ack   & manager_wb_ack   & bram_wb_ack;
  slaves_err_i <= mux2dec_s_err   & "0"              & "0"; 
  slaves_rty_i <= "000";
  
  -- -------------------------------------------------------------------------------------------
  -- Wishbone Memory ----------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------

  ext_mem_inst: wb_bram
  generic map ( MEM_SIZE_BYTES => MEM_SIZE )
  port map (
    clk_i    => clk_i,
    rst_i    => rst_local,
    wb_cyc_i => bram_wb_cyc,
    wb_stb_i => bram_wb_stb,
    wb_we_i  => bram_wb_we,
    wb_sel_i => bram_wb_sel,
    wb_adr_i => bram_wb_adr,
    wb_dat_i => bram_wb_dat_i,
    wb_dat_o => bram_wb_dat_o,
    wb_ack_o => bram_wb_ack
  );
  
  -- -------------------------------------------------------------------------------------------
  -- eFPGA Manager ------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  
  manager_inst: efpga_manager
  generic map (
    HW_VERSION => HW_VERSION
  )
  port map (
    clk_i    => clk_i,
    rst_i    => rst_local,
    wb_cyc_i => manager_wb_cyc,
    wb_stb_i => manager_wb_stb,
    wb_we_i  => manager_wb_we,
    wb_sel_i => manager_wb_sel,
    wb_adr_i => manager_wb_adr,
    wb_dat_i => manager_wb_dat_i,
    wb_dat_o => manager_wb_dat_o,
    wb_ack_o => manager_wb_ack,
    
    efpga_config_data_o => efpga_config_data,
    efpga_config_we_o   => efpga_config_we,
    
    efpga_soft_reset_o  => efpga_soft_reset,
    efpga_com_active_i  => efpga_com_active,
    
    slot0_i_top_i       => "00" & efpga_debug_out, 
    slot0_o_top_o       => efpga_o_top,            
    
    decoupler0_req_o          => dec0_req,
    decoupler0_force_o        => dec0_force,
    decoupler0_is_decoupled_i => dec0_is_dec,
    decoupler0_host_act_i     => dec0_host_act,
    decoupler0_dma_act_i      => dec0_dma_act
  );
  
  -- ===========================================================================================
  -- PACK INPUTS TO eFPGA (SoC -> Fabric)
  -- ===========================================================================================
  -- eFPGA_top array index mapping: Y3 = [15:0], Y2 = [31:16], Y1 = [47:32]

  -- Y3: DMA Acknowledge & Error (Mapped to D0)
  efpga_ram_d_i(0)            <= fab2dec_m_ack;
  efpga_ram_d_i(1)            <= fab2dec_m_err;
  efpga_ram_d_i(15 downto 2)  <= (others => '0');
  
  -- Y2: Upper 16 Data In
  efpga_ram_d_i(31 downto 16) <= fab2dec_m_dat_i(31 downto 16); 
  
  -- Y1: Lower 16 Data In
  efpga_ram_d_i(47 downto 32) <= fab2dec_m_dat_i(15 downto 0);  


  -- ===========================================================================================
  -- UNPACK OUTPUTS FROM eFPGA (Fabric -> SoC)
  -- ===========================================================================================

  -- Y1: Lower 16 Data Out
  fab2dec_m_dat_o(15 downto 0)  <= efpga_ram_d_o(47 downto 32);  
  
  -- Y2: Upper 16 Data Out
  fab2dec_m_dat_o(31 downto 16) <= efpga_ram_d_o(31 downto 16); 

  -- Y1: Address [7:0]
  fab2dec_m_adr(7 downto 0)     <= efpga_ram_a_o(23 downto 16);   
  
  -- Y2: Address [15:8]
  fab2dec_m_adr(15 downto 8)    <= efpga_ram_a_o(15 downto 8);  
  
  -- Y3: Address [23:16]
  fab2dec_m_adr(23 downto 16)   <= efpga_ram_a_o(7 downto 0); 
  fab2dec_m_adr(31 downto 24)   <= (others => '0'); -- Padding

  -- Y1: SEL Control (Mapped to C[3:0])
  fab2dec_m_sel(3 downto 0)     <= efpga_ram_c_o(11 downto 8);     
  
  -- Y2: WE, CYC, STB (Mapped to C[2:0])
  fab2dec_m_we                  <= efpga_ram_c_o(4);              
  fab2dec_m_cyc                 <= efpga_ram_c_o(5);              
  fab2dec_m_stb                 <= efpga_ram_c_o(6);              

  -- The CPU-to-Fabric Slave port is left OPEN
  dec2fab_s_ack   <= '0';
  dec2fab_s_err   <= '0';
  dec2fab_s_dat_o <= (others => '0');
  
  -- -------------------------------------------------------------------------------------------
  -- eFPGA ------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------  
  
  fabric_inst: eFPGA_top
  port map (
    -- Clocks and Resets
    CLK             => clk_i,
    resetn          => fpga_rst,
    
    -- Configuration Interface
    SelfWriteData   => efpga_config_data,
    SelfWriteStrobe => efpga_config_we,
    ComActive       => efpga_com_active,
    
    -- Unused Serial Config
    Rx              => '1',
    s_clk           => '0',
    s_data          => '0',
    
    -- The Wishbone Mapped Arrays
    RAM2FAB_D_I     => efpga_ram_d_i,
    FAB2RAM_D_O     => efpga_ram_d_o,
    FAB2RAM_A_O     => efpga_ram_a_o,
    FAB2RAM_C_O     => efpga_ram_c_o,
    
    -- IO routing
    I_top           => efpga_debug_out,
    O_top           => efpga_o_top(5 downto 0),
    
    -- Leave these unconnected/open
    A_config_C      => open,
    B_config_C      => open,
    Config_accessC  => open,
    T_top           => open,
    ReceiveLED      => open
  );
  
  -- -------------------------------------------------------------------------------------------
  -- Decoupler 0 ------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------  
  
  decoupler0_inst: wb_decoupler_bidir
  port map (
    clk_i              => clk_i,
    rst_i              => rst_local,
    decouple_req_i     => dec0_req,
    force_decouple_i   => dec0_force,
    is_decoupled_o     => dec0_is_dec,
    host_active_o      => dec0_host_act,
    dma_active_o       => dec0_dma_act,

    -- CH1 SLAVE (Receives from Mux Slave 2)
    h2f_s_adr_i        => mux2dec_s_adr,
    h2f_s_dat_i        => mux2dec_s_dat_i,
    h2f_s_sel_i        => mux2dec_s_sel,
    h2f_s_we_i         => mux2dec_s_we,
    h2f_s_cyc_i        => mux2dec_s_cyc,
    h2f_s_stb_i        => mux2dec_s_stb,
    h2f_s_dat_o        => mux2dec_s_dat_o,
    h2f_s_ack_o        => mux2dec_s_ack,
    h2f_s_err_o        => mux2dec_s_err,

    -- CH1 MASTER (Drives to eFPGA Fabric Wrapper)
    h2f_m_adr_o        => dec2fab_s_adr,
    h2f_m_dat_o        => dec2fab_s_dat_i,
    h2f_m_sel_o        => dec2fab_s_sel,
    h2f_m_we_o         => dec2fab_s_we,
    h2f_m_cyc_o        => dec2fab_s_cyc,
    h2f_m_stb_o        => dec2fab_s_stb,
    h2f_m_dat_i        => dec2fab_s_dat_o,
    h2f_m_ack_i        => dec2fab_s_ack,
    h2f_m_err_i        => dec2fab_s_err,

    -- CH2 SLAVE (Receives from eFPGA Fabric Wrapper)
    f2h_s_adr_i        => fab2dec_m_adr,
    f2h_s_dat_i        => fab2dec_m_dat_o,
    f2h_s_sel_i        => fab2dec_m_sel,
    f2h_s_we_i         => fab2dec_m_we,
    f2h_s_cyc_i        => fab2dec_m_cyc,
    f2h_s_stb_i        => fab2dec_m_stb,
    f2h_s_dat_o        => fab2dec_m_dat_i,
    f2h_s_ack_o        => fab2dec_m_ack,
    f2h_s_err_o        => fab2dec_m_err,
    
    -- CH2 MASTER (Drives to Arbiter Master 1)
    f2h_m_adr_o        => dec2arb_m_adr,
    f2h_m_dat_o        => dec2arb_m_dat_o,
    f2h_m_sel_o        => dec2arb_m_sel,
    f2h_m_we_o         => dec2arb_m_we,
    f2h_m_cyc_o        => dec2arb_m_cyc,
    f2h_m_stb_o        => dec2arb_m_stb,
    f2h_m_dat_i        => dec2arb_m_dat_i,
    f2h_m_ack_i        => dec2arb_m_ack,
    f2h_m_err_i        => dec2arb_m_err
  );

end architecture;
