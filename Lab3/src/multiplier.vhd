--Engineer     : Junyoung Hwang
--Date         : 03/15/2025
--Name of file : multiplier.vhd
--Description  : implements 2 simple 8b*8b signed multipliers

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
  port (
        -- input ports
        clk, rst   : in std_logic;
        in_valid   : in std_logic;
        data_in_1  : in signed (7 downto 0);
        data_in_2  : in signed (7 downto 0);
        coef_in    : in signed (7 downto 0);
        -- output ports
        out_valid  : out std_logic;
        data_out_1 : out signed (15 downto 0);
        data_out_2 : out signed (15 downto 0)
       );
end multiplier;

architecture arch of multiplier is
  -- -------------- Stage P1 -----------------
  signal data_valid_p1  : std_logic;
  signal data_1_p1   : signed (7 downto 0);
  signal data_2_p1   : signed (7 downto 0);
  signal coef_p1     : signed (7 downto 0);
  -- -------------- Stage P2 -----------------
  signal data_valid_p2  : std_logic;
  signal data_1_p2   : signed (15 downto 0);
  signal data_2_p2   : signed (15 downto 0);

begin
  -- -------------- Stage P1 -----------------
  p1: process (clk) 
  begin
    if (rising_edge(clk)) then
      if (rst = '1') then
        data_valid_p1 <= '0';
      else
        data_valid_p1 <= in_valid;
        if (in_valid = '1') then
          data_1_p1 <= data_in_1;
          data_2_p1 <= data_in_2;
          coef_p1   <= coef_in;
        end if;
      end if;
    end if;
  end process;
  -- -------------- Stage P2 -----------------
  p2: process (clk) 
  begin
    if (rising_edge(clk)) then
      if (rst = '1') then
        data_valid_p2 <= '0';
      else
        data_valid_p2 <= data_valid_p1;
        if (data_valid_p1 = '1') then
          data_1_p2 <= data_1_p1 * coef_p1;
          data_2_p2 <= data_2_p1 * coef_p1;
        end if;
      end if;
    end if;
  end process;
  -- outputs
  out_valid  <= data_valid_p2;
  data_out_1 <= data_1_p2;
  data_out_2 <= data_2_p2;
  
end arch;

