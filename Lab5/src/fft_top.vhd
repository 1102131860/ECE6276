
--Engineer     : Rui Wang
--Date         : 04/26/2025
--Name of file : fft_top.vhd
--Description  : implements 8-point FFT

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fft_pkg.all;

entity fft_top is
  port (
        -- input side
        clk, rst      : in std_logic;
        data_in       : in data_in_t;
        in_valid      : in std_logic;
        next_in       : out std_logic;
        -- output side
        out_valid     : out std_logic;
        data_real_out : out data_out_t;
        data_imag_out : out data_out_t
       );
end fft_top;
-- DO NOT MODIFY PORT NAMES ABOVE


-- TODO 
		-- Find the number that goes inside the parentheses from fft_pkg

architecture arch of fft_top is
-- S1 component
	component fft_butterfly_1 
		port(
		rst,clk : in std_logic;
		in_valid: in std_logic;
		out_valid: out std_logic;
		s1,s2: in complex_8;
		w1 : in complex_9;
		g1,g2 : out complex_11
		);
	end component;
-- S2 component
	component fft_butterfly_2 
		port(
		rst,clk : in std_logic;
		in_valid: in std_logic;
		out_valid: out std_logic;
		s3,s4: in complex_11;
		w2 : in complex_9;
		g3,g4 : out complex_14
		);
	end component;
-- S3 component
	component fft_butterfly_3 
		port(
		rst,clk : in std_logic;
		in_valid: in std_logic;
		out_valid: out std_logic;
		s5,s6: in complex_14;
		w3 : in complex_9;
		g5,g6 : out complex_16
		);
	end component;

	-- type def
	type valid_array is array(0 to 3) of std_logic;

	-- mid signal
	signal y1: data_in_b_s1;
	signal y2: data_in_b_s2;
	signal y3: data_in_b_s3;
	signal y4: data_in_e_s3;
	signal w : data_w ;
	signal valid_a,valid_b,valid_c: std_logic;
	signal valid_1,valid_2,valid_3: valid_array;

begin
	--w signal number
	w(0).r <= "011111111";
	w(0).i <= "000000000";
	w(1).r <= "010110100";
	w(1).i <= "101001100";
	w(2).r <= "000000000";
	w(2).i <= "100000001";
	w(3).r <= "101001100";
	w(3).i <= "101001100";
	--Input
	y1(0).r <= data_in(0);
	y1(1).r <= data_in(1);
	y1(2).r <= data_in(2);
	y1(3).r <= data_in(3);
	y1(4).r <= data_in(4);
	y1(5).r <= data_in(5);
	y1(6).r <= data_in(6);
	y1(7).r <= data_in(7);
	y1(0).i <= "00000000";
	y1(1).i <= "00000000";
	y1(2).i <= "00000000";
	y1(3).i <= "00000000";
	y1(4).i <= "00000000";
	y1(5).i <= "00000000";
	y1(6).i <= "00000000";
	y1(7).i <= "00000000";

	-- Stage 1 operation
	--TODO
	-- Instantiate fft_butterfly_1
    fft_butterfly_1_inst_0 : fft_butterfly_1
        port map (
            rst => rst,
			clk => clk,
			in_valid => in_valid,
			out_valid => valid_1(0),
			s1 => y1(0),
			s2 => y1(4),
			w1 => w(0),
			g1 => y2(0),
			g2 => y2(4)
        );
	
	fft_butterfly_1_inst_1 : fft_butterfly_1
		port map (
			rst => rst,
			clk => clk,
			in_valid => in_valid,
			out_valid => valid_1(1),
			s1 => y1(1),
			s2 => y1(5),
			w1 => w(1),
			g1 => y2(1),
			g2 => y2(5)
		);

	fft_butterfly_1_inst_2 : fft_butterfly_1
		port map (
			rst => rst,
			clk => clk,
			in_valid => in_valid,
			out_valid => valid_1(2),
			s1 => y1(2),
			s2 => y1(6),
			w1 => w(2),
			g1 => y2(2),
			g2 => y2(6)
		);
	
	fft_butterfly_1_inst_3 : fft_butterfly_1
		port map (
			rst => rst,
			clk => clk,
			in_valid => in_valid,
			out_valid => valid_1(3),
			s1 => y1(3),
			s2 => y1(7),
			w1 => w(3),
			g1 => y2(3),
			g2 => y2(7)
		);

	valid_a <= '1' when (valid_1 = "1111") else '0';

	-- Stage 2 operation
	--TODO
	-- Instantiate fft_butterfly_2
	fft_butterfly_2_inst_0 : fft_butterfly_2
		port map (
			rst => rst,
			clk => clk,
			in_valid => valid_a,
			out_valid => valid_2(0),
			s3 => y2(0),
			s4 => y2(2),
			w2 => w(0),
			g3 => y3(0),
			g4 => y3(2)
		);

	fft_butterfly_2_inst_1 : fft_butterfly_2
		port map (
			rst => rst,
			clk => clk,
			in_valid => valid_a,
			out_valid => valid_2(1),
			s3 => y2(1),
			s4 => y2(3),
			w2 => w(2),
			g3 => y3(1),
			g4 => y3(3)
		);

	fft_butterfly_2_inst_2 : fft_butterfly_2
		port map (
			rst => rst,
			clk => clk,
			in_valid => valid_a,
			out_valid => valid_2(2),
			s3 => y2(4),
			s4 => y2(6),
			w2 => w(0),
			g3 => y3(4),
			g4 => y3(6)
		);

	fft_butterfly_2_inst_3 : fft_butterfly_2
		port map (
			rst => rst,
			clk => clk,
			in_valid => valid_a,
			out_valid => valid_2(3),
			s3 => y2(5),
			s4 => y2(7),
			w2 => w(2),
			g3 => y3(5),
			g4 => y3(7)
		);

	valid_b <= '1' when (valid_2 = "1111") else '0';

	-- Stage 3 operation
	--TODO
	-- Instantiate fft_butterfly_3
	fft_butterfly_3_inst_0 : fft_butterfly_3
		port map (
			rst => rst,
			clk => clk,
			in_valid => valid_b,
			out_valid => valid_3(0),
			s5 => y3(0),
			s6 => y3(1),
			w3 => w(0),
			g5 => y4(0),
			g6 => y4(4)		-- x[1] -> X[4]
		);

	fft_butterfly_3_inst_1 : fft_butterfly_3
		port map (
			rst => rst,
			clk => clk,
			in_valid => valid_b,
			out_valid => valid_3(1),
			s5 => y3(2),
			s6 => y3(3),
			w3 => w(0),
			g5 => y4(2),
			g6 => y4(6)		-- x[3] -> x[6]
		);
	
	fft_butterfly_3_inst_2 : fft_butterfly_3
		port map (
			rst => rst,
			clk => clk,
			in_valid => valid_b,
			out_valid => valid_3(2),
			s5 => y3(4),
			s6 => y3(5),
			w3 => w(0),
			g5 => y4(1),	-- x[4] -> X[1]
			g6 => y4(5)
		);

	fft_butterlfy_3_inst_3 : fft_butterfly_3
		port map (
			rst => rst,
			clk => clk,
			in_valid => valid_b,
			out_valid => valid_3(3),
			s5 => y3(6),
			s6 => y3(7),
			w3 => w(0),
			g5 => y4(3),	-- x[6] -> X[3]
			g6 => y4(7)
		);

	valid_c <= '1' when (valid_3 = "1111") else '0';

	-- valid determine
	out_valid <= valid_c;

	-- Output operation
	data_real_out(0) <= y4(0).r;
	data_real_out(1) <= y4(1).r;
	data_real_out(2) <= y4(2).r;
	data_real_out(3) <= y4(3).r;
	data_real_out(4) <= y4(4).r;
	data_real_out(5) <= y4(5).r;
	data_real_out(6) <= y4(6).r;
	data_real_out(7) <= y4(7).r;
	data_imag_out(0) <= y4(0).i;
	data_imag_out(1) <= y4(1).i;
	data_imag_out(2) <= y4(2).i;
	data_imag_out(3) <= y4(3).i;
	data_imag_out(4) <= y4(4).i;
	data_imag_out(5) <= y4(5).i;
	data_imag_out(6) <= y4(6).i;
	data_imag_out(7) <= y4(7).i;

	-- stall determine (no stall)
	next_in <= '1';
end arch;
