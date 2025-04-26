library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fft_pkg.all;

entity fft_butterfly_3 is 
	port(
		rst,clk : in std_logic;
		in_valid: in std_logic;
		out_valid: out std_logic;
		-- TODO 
		-- Find the number that goes inside the parentheses from fft_pkg
		s5,s6: in complex_14;
		w3 : in complex_9;
		g5,g6 : out complex_16
	);
end fft_butterfly_3;

architecture Behavioral_3 of fft_butterfly_3 is
	-- Pipelined Registers
	signal g5_reg, g6_reg : complex_16;
  	signal valid_3       : std_logic;

begin
	-- Stage 3 operations
	Stage_3 : process(clk) 
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				g5_reg.r <= (others => '0');
				g5_reg.i <= (others => '0');
				g6_reg.r <= (others => '0');
				g6_reg.i <= (others => '0');
				valid_3 <= '0';
			elsif (in_valid = '1') then
				g5_reg <= add_3(s5, s6);
				g6_reg <= mult_3(sub_3(s5, s6), w3);
				valid_3 <= '1';
			else
				valid_3 <= '0';
			end if;
		end if;
	end process;

	-- Assign outputs
	g5 <= g5_reg;
	g6 <= g6_reg;
	out_valid <= valid_3;

end Behavioral_3;