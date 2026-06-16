library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wb_bram is
  generic (
    MEM_SIZE_BYTES : natural := 64*1024
  );
  port (
    -- Global control --
    clk_i    : in  std_ulogic;
    rst_i    : in  std_ulogic;
    
    -- Wishbone Interface --
    wb_cyc_i : in  std_ulogic;
    wb_stb_i : in  std_ulogic;
    wb_we_i  : in  std_ulogic;
    wb_sel_i : in  std_ulogic_vector(3 downto 0);
    wb_adr_i : in  std_ulogic_vector(31 downto 0);
    wb_dat_i : in  std_ulogic_vector(31 downto 0);
    wb_dat_o : out std_ulogic_vector(31 downto 0);
    wb_ack_o : out std_ulogic
  );
end entity wb_bram;

architecture rtl of wb_bram is

  constant MEM_WORDS : natural := MEM_SIZE_BYTES / 4;

  type mem_array_t is array (0 to MEM_WORDS - 1) of std_ulogic_vector(31 downto 0);

  signal ram : mem_array_t;

  signal ack_reg   : std_ulogic;
  signal read_data : std_ulogic_vector(31 downto 0);

begin

  process(clk_i)
    variable word_addr : integer;
  begin
    if rising_edge(clk_i) then
      ack_reg <= '0';

      -- Convert byte address to word index (drop the lowest 2 bits)
      word_addr := to_integer(unsigned(wb_adr_i(15 downto 2)));

      -- Check for valid Wishbone cycle
      if wb_cyc_i = '1' and wb_stb_i = '1' then
        
        -- Prevent re-acknowledging the same transaction in pipelined setups
        if ack_reg = '0' then
          ack_reg <= '1'; -- Send ACK on the next clock edge

          if wb_we_i = '1' then
            -- Write cycle with byte-enable logic (wb_sel_i)
            if wb_sel_i(0) = '1' then
              ram(word_addr)(7 downto 0)   <= wb_dat_i(7 downto 0);
            end if;
            if wb_sel_i(1) = '1' then
              ram(word_addr)(15 downto 8)  <= wb_dat_i(15 downto 8);
            end if;
            if wb_sel_i(2) = '1' then
              ram(word_addr)(23 downto 16) <= wb_dat_i(23 downto 16);
            end if;
            if wb_sel_i(3) = '1' then
              ram(word_addr)(31 downto 24) <= wb_dat_i(31 downto 24);
            end if;
          end if;

          -- Synchronous read cycle
          read_data <= ram(word_addr);
        end if;
      end if;

      -- Synchronous reset for the control logic 
      -- (Memory contents are not cleared on reset to match standard BRAM behavior)
      if rst_i = '1' then
        ack_reg <= '0';
      end if;
    end if;
  end process;

  wb_ack_o <= ack_reg;
  wb_dat_o <= read_data;

end architecture rtl;