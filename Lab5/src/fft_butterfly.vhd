library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fft_pkg.all;

entity fft_butterfly_1 is 
	port(
		rst,clk : in std_logic;
		in_valid: in std_logic;
		out_valid: out std_logic;
		-- TODO 
		-- Find the number that goes inside the parentheses from fft_pkg
		s1,s2: in complex_8;
		w1 : in complex_9;
		g1,g2 : out complex_11
	);
end fft_butterfly_1;

architecture Behavioral_1 of fft_butterfly_1 is
	-- Pieplined Registers
	signal g1_reg, g2_reg : complex_11;
	signal valid_1 : std_logic;

begin
	-- S1 operation
	Stage_1 : process(clk)
	begin
		if (clk'event and clk = '1') then
			-- TODO
			if (rst = '1') then
				g1_reg.r <= (others => '0');
				g1_reg.i <= (others => '0');
				g2_reg.r <= (others => '0');
				g2_reg.i <= (others => '0');
				valid_1 <= '0';
			elsif (in_valid = '1') then
				g1_reg <= add_1(s1, s2);
				g2_reg <= mult_1(sub_1(s1, s2), w1);
				valid_1 <= '1';
			else
				-- keep g1_reg unchanged
				-- keep g2_reg unchanged
				valid_1 <= '0';
			end if;		
		end if;
	end process;

	-- Assign outputs
	g1 <= g1_reg;
	g2 <= g2_reg;
	out_valid <= valid_1;

end Behavioral_1;