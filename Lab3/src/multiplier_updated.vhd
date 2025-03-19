--Engineer     : Rui Wang
--Date         : 3/18/2025
--Name of file : multiplier_updated.vhd
--Description  : implements 2 simple 8b*8b signed multiplier_updateds
--               DSP slice

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier_updated is
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
end multiplier_updated;


architecture arch of multiplier_updated is
  -- -------------- Stage P1 -----------------
  signal data_valid_p1      : std_logic;
  signal data_in_ext_1      : signed (26 downto 0);
  signal data_in_ext_2      : signed (26 downto 0);
  signal data_concat_p1     : signed (26 downto 0);
  signal coef_ext_p1        : signed (17 downto 0);
  -- -------------- Stage P2 -----------------
  signal data_valid_p2    : std_logic;
  signal data_mult_ext_p2 : signed (44 downto 0);
  signal data_mult_p2     : signed (35 downto 0);
  -- -------------- Stage P3 -----------------
  signal data_valid_p3   : std_logic;
  signal data_out_1_p3   : signed (15 downto 0);
  signal data_out_2_p3   : signed (15 downto 0);
  signal sign_ext_data_2 : signed (1 downto 0);

begin
  -- -------------- Stage P1 -----------------
  -- sign extension and left shift
  data_in_ext_1 (26)           <= data_in_1 (7); -- sign extension
  data_in_ext_1 (25 downto 18) <= data_in_1;
  data_in_ext_1 (17 downto 0)  <= (others => '0'); -- pad 0
  data_in_ext_2 (7 downto 0)   <= data_in_2;
  data_in_ext_2 (26 downto 8)  <= (others => data_in_2 (7)); -- sign extension
  

  --TODO
  p1: process (clk) 
  begin
    if (rising_edge(clk)) then
      if (rst = '1') then
        data_valid_p1 <= '0';
      else
        data_valid_p1 <= in_valid;
        if (in_valid = '1') then
          data_concat_p1 <= data_in_ext_1 + data_in_ext_2; -- (a<<18 + d)[26:0]
          coef_ext_p1 (7 downto 0) <= coef_in;
          coef_ext_p1 (17 downto 8) <= (others => coef_in (7)); -- (sign extension)
        end if;
      end if;
    end if;
  end process;



  -- -------------- Stage P2 -----------------
  --TODO
  p2: process (clk) 
  begin
    if (rising_edge(clk)) then
      if (rst = '1') then
        data_valid_p2 <= '0';
      else
        data_valid_p2 <= data_valid_p1;
        if (data_valid_p1 = '1') then
          data_mult_ext_p2 <= data_concat_p1 * coef_ext_p1; -- P
        end if;
      end if;
    end if;
  end process;

  data_mult_p2 <= data_mult_ext_p2 (35 downto 0); -- M



  -- -------------- Stage P3 -----------------
  --TODO
  p3: process (clk)
  variable h : signed (17 downto 0);
  variable v : signed (17 downto 0);
  begin
    if (rising_edge(clk)) then
      if (rst = '1') then
        data_valid_p3 <= '0';
      else
        data_valid_p3 <= data_valid_p2;
        if (data_valid_p2 = '1') then
          h := data_mult_ext_p2 (35 downto 18) - resize(data_mult_ext_p2(17 downto 17), 18); -- h[17:0] = P[35:18] - P[17] 
          v := data_mult_ext_p2 (17 downto 0); -- v[17:0] = P[17:0]
          data_out_1_p3 <= h (15 downto 0); -- a*b[15:0] = h[15:0]
          data_out_2_p3 <= v (15 downto 0); -- d*b[15:0] = v[15:0]
          sign_ext_data_2 <= (others => v (17)); -- v[17], v[17]
        end if;
      end if;
    end if;
  end process;


  -- -------------- Output   -----------------
  out_valid  <= data_valid_p3;
  data_out_1 <= data_out_1_p3;
  data_out_2 <= data_out_2_p3;
end arch;
