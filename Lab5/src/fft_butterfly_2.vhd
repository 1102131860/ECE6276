library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fft_pkg.all;

entity fft_butterfly_2 is 
	port(
		rst,clk : in std_logic;
		in_valid: in std_logic;
		out_valid: out std_logic;
		-- TODO 
		-- Find the number that goes inside the parentheses from fft_pkg
		s3,s4: in complex_11;
		w2 : in complex_9;
		g3,g4 : out complex_14
	);
end fft_butterfly_2;

architecture Behavioral_2 of fft_butterfly_2 is
	-- Pipelined Registers
	signal g3_reg, g4_reg : complex_14;
  	signal valid_2 : std_logic;

begin
	-- Stage 2 operations
	Stage_2 : process(clk) 
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				g3_reg.r <= (others => '0');
				g3_reg.i <= (others => '0');
				g4_reg.r <= (others => '0');
				g4_reg.i <= (others => '0');
				valid_2 <= '0';
			elsif (in_valid = '1') then
				g3_reg <= add_2(s3, s4);
				g4_reg <= mult_2(sub_2(s3, s4), w2);
				valid_2 <= '1';
			else
				valid_2 <= '0';
			end if;
		end if;
	end process;

	-- Assign outputs
	g3 <= g3_reg;
  	g4 <= g4_reg;
  	out_valid <= valid_2;

end Behavioral_2;