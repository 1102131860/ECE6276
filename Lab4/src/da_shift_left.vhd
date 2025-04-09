-- Engineer     : Rui Wang
-- Date         : 04/09/2025
-- Name of file : da.vhd
-- Description  : implements a signed Distributed Arithmetic,
--                with 4 signed input vectors. Each is 4-bit wide.
--                The coefs are also 4-bit wide signed numbers

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity da is
  port (
       -- input side
       clk, rst       : in  std_logic;
       data_in_0      : in  signed (3 downto 0);
       data_in_1      : in  signed (3 downto 0);
       data_in_2      : in  signed (3 downto 0);
       data_in_3      : in  signed (3 downto 0);
       in_valid       : in  std_logic;
       next_in        : out std_logic;
       -- output side
       data_out       : out signed (9 downto 0);
       out_valid      : out std_logic
       );
end da;
-- DO NOT MODIFY PORT NAMES ABOVE

architecture arch of da is
  -- ----------------- Define Intermediate Signals -----------------
  type array16x5b_t  is array (0 to 15) of signed (4 downto 0);
  -- --------- ROM ----------
  --TODO (Fill the array)
  -- coef_0 = 7, coef_1 = 3, coef_2 =-8, coef_3 =-5
  signal ROM : array16x5b_t := (  
    0 => to_signed(0, 5),    -- 0000: 0x7 + 0x3 + 0x(-8) + 0x(-5) = 0
    1 => to_signed(7, 5),    -- 0001: 1x7 + 0x3 + 0x(-8) + 0x(-5) = 7
    2 => to_signed(3, 5),    -- 0010: 0x7 + 1x3 + 0x(-8) + 0x(-5) = 3
    3 => to_signed(10, 5),   -- 0011: 1x7 + 1x3 + 0x(-8) + 0x(-5) = 10
    4 => to_signed(-8, 5),   -- 0100: 0x7 + 0x3 + 1x(-8) + 0x(-5) = -8
    5 => to_signed(-1, 5),   -- 0101: 1x7 + 0x3 + 1x(-8) + 0x(-5) = -1
    6 => to_signed(-5, 5),   -- 0110: 0x7 + 1x3 + 1x(-8) + 0x(-5) = -5
    7 => to_signed(2, 5),    -- 0111: 1x7 + 1x3 + 1x(-8) + 0x(-5) = 2
    8 => to_signed(-5, 5),   -- 1000: 0x7 + 0x3 + 0x(-8) + 1x(-5) = -5
    9 => to_signed(2, 5),    -- 1001: 1x7 + 0x3 + 0x(-8) + 1x(-5) = 2
    10 => to_signed(-2, 5),  -- 1010: 0x7 + 1x3 + 0x(-8) + 1x(-5) = -2
    11 => to_signed(5, 5),   -- 1011: 1x7 + 1x3 + 0x(-8) + 1x(-5) = 5
    12 => to_signed(-13, 5), -- 1100: 0x7 + 0x3 + 1x(-8) + 1x(-5) = -13
    13 => to_signed(-6, 5),  -- 1101: 1x7 + 0x3 + 1x(-8) + 1x(-5) = -6
    14 => to_signed(-10, 5), -- 1110: 0x7 + 1x3 + 1x(-8) + 1x(-5) = -10
    15 => to_signed(-3, 5)   -- 1111: 1x7 + 1x3 + 1x(-8) + 1x(-5) = -3
  );

  -- --------- Stage 1 --------
  signal data_0_p1 : signed (3 downto 0);
  signal data_1_p1 : signed (3 downto 0);
  signal data_2_p1 : signed (3 downto 0);
  signal data_3_p1 : signed (3 downto 0);
  signal valid_p1  : std_logic;
  signal stall_p1  : std_logic;
  signal count_p1  : unsigned (1 downto 0);

  signal addr          : unsigned (3 downto 0);
  signal data_lut      : signed (4 downto 0);

  -- To achieve better sample period
  signal data_lut_p    : signed(4 downto 0);   -- pipelined version of LUT
  signal valid_p1_d    : std_logic;            -- delayed valid_p1
  signal count_p1_d    : unsigned(1 downto 0); -- delayed count_p1_d for count

  -- --------- Stage 2 --------
  signal acc_sig     : signed (9 downto 0);
  signal acc_p2      : signed (9 downto 0);
  signal count_equ_3 : std_logic;
  signal valid_p2    : std_logic;

begin
  -- --------- Stage 1 --------
  process (clk) 
  begin
    if (rising_edge(clk)) then 
      if (rst = '1') then
        valid_p1 <= '0';
      elsif (stall_p1 = '0') then
        valid_p1 <= in_valid;
        if (in_valid = '1') then
          data_0_p1 <= data_in_0;
          data_1_p1 <= data_in_1;
          data_2_p1 <= data_in_2;
          data_3_p1 <= data_in_3;
        end if;
      end if;
    end if;
  end process;

  -- reset counter as part of the valid path
  process (clk) 
  begin
    if (rising_edge(clk)) then 
      if (rst = '1') then
        count_p1 <= (others => '0');
      elsif (valid_p1 = '1') then
        count_p1 <= count_p1 + 1;
      end if;
    end if;
  end process;

  -- generating stall signal
  process (valid_p1, count_p1)
  begin
    -- TODO
    if (valid_p1 = '1') then
      if (count_p1 = "11") then  -- when count reaches 3
        stall_p1 <= '0';         -- allow new data
      else
        stall_p1 <= '1';         -- stall until count = 3
      end if;
    else
      stall_p1 <= '0';           -- no valid input → no stall
    end if;
  end process;

  -- --------- Stage 2 --------

  -- Generating the addr
  -- TODO
  -- concatenate a 4-bit address
  addr <= data_3_p1(to_integer(count_p1)) &
          data_2_p1(to_integer(count_p1)) &
          data_1_p1(to_integer(count_p1)) &
          data_0_p1(to_integer(count_p1));
  -- obtain value from address
  data_lut <= ROM(to_integer(unsigned(addr)));

  -- Pipeline register for LUT output
  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        data_lut_p <= (others => '0');
      elsif valid_p1 = '1' then
        data_lut_p <= data_lut;
      end if;
    end if;
  end process;

  -- Delay valid_p1, and count_p1 by 1 cycle
  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        valid_p1_d <= '0';
        count_p1_d <= (others => '0');
      else
        valid_p1_d <= valid_p1;
        count_p1_d <= count_p1;
      end if;
    end if;
  end process;

  -- Compute acc_sig from pipelined LUT
  process (count_p1_d, data_lut_p, acc_p2) 
  begin 
    -- TODO
    if (count_p1_d = to_unsigned(3, 2)) then
      -- For the MSB, subtract instead of add (equivalent to -2^B * value)
      acc_sig <= acc_p2 - shift_left(resize(data_lut_p, 10), to_integer(count_p1_d));
    elsif (count_p1_d = to_unsigned(0, 2)) then
      -- acc_p2 is 0, so directly add (data_lut << B)
      acc_sig <= shift_left(resize(data_lut_p, 10), to_integer(count_p1_d));
    else
      -- For other bits, continue with normal addition
      acc_sig <= acc_p2 + shift_left(resize(data_lut_p, 10), to_integer(count_p1_d));
    end if;
  end process;

  -- we use a dedicated signal here because the conversion from boolean to std_logic is bit complicated 
  -- in VHDL for the '*' line below
  count_equ_3 <= '1' when count_p1_d = to_unsigned(3,2) else '0';

  process (clk) 
  begin
    -- TODO
    if (rising_edge(clk)) then
      if (rst = '1') then
        acc_p2 <= (others => '0');  -- reset synchronously
        valid_p2 <= '0';            -- reset valid_p2 as well
      elsif (valid_p1_d = '1') then -- use delayed valid_p1 signal
        acc_p2 <= acc_sig;          -- udpate acc_p2 with acc_sig 
        valid_p2 <= count_equ_3;    -- assign valid_p2 with count_equ_3
      else
        valid_p2 <= '0';
      end if;
    end if;
  end process;

  -- --------- Output --------
  next_in   <= not stall_p1;
  data_out  <= acc_p2;
  out_valid <= valid_p2;

end arch;
