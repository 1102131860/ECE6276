library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package fft_pkg is
	type complex_8 is
		record
			r : signed (7 downto 0);
			i : signed (7 downto 0);
		end record;
	type complex_11 is
		record
			r : signed (10 downto 0);
			i : signed (10 downto 0);
		end record;
	type complex_14 is
		record
			r : signed (13 downto 0);
			i : signed (13 downto 0);
		end record;
	type complex_16 is
		record
			r : signed (15 downto 0);
			i : signed (15 downto 0);
		end record;
	type complex_9 is
		record
			r : signed (8 downto 0);
			i : signed (8 downto 0);
		end record;
	type complex_12 is
		record
			r : signed (11 downto 0);
			i : signed (11 downto 0);
		end record;
	type complex_15 is
		record
			r : signed (14 downto 0);
			i : signed (14 downto 0);
		end record;
	type complex_19 is
		record
			r : signed (18 downto 0);
			i : signed (18 downto 0);
		end record;
	type complex_22 is
		record
			r : signed (21 downto 0);
			i : signed (21 downto 0);
		end record;
	type complex_24 is
		record
			r : signed (23 downto 0);
			i : signed (23 downto 0);
		end record;
	type data_in_t        is array (0 to 7) of signed (7 downto 0);
	type data_out_t       is array (0 to 7) of signed (15 downto 0);
	type data_in_b_s1        is array (0 to 7) of complex_8;
	type data_in_b_s2        is array (0 to 7) of complex_11;
	type data_in_b_s3        is array (0 to 7) of complex_14;
	type data_in_e_s3        is array (0 to 7) of complex_16;
	type data_w       is array (0 to 3) of complex_9;
	
-- Stage 1
	function add_1 (n1,n2 : complex_8) return complex_11;
	function sub_1 (n1,n2 : complex_8) return complex_9;
	function mult_1 (n1, n2 : complex_9) return complex_11;
-- Stage 2
	function add_2 (n1,n2 : complex_11) return complex_14;
	function sub_2 (n1,n2 : complex_11) return complex_12;
	function mult_2 (n1:complex_12; n2 : complex_9) return complex_14;
-- Stage 3
	function add_3 (n1,n2 : complex_14) return complex_16;
	function sub_3 (n1,n2 : complex_14) return complex_15;
	function mult_3 (n1:complex_15; n2 : complex_9) return complex_16;
end fft_pkg;
--body struct
package body fft_pkg is
	-- S1 
	function add_1 (n1, n2 : complex_8) return complex_11 is
		variable sum : complex_11;
	begin
		sum.r := resize(resize(n1.r,9) + resize(n2.r,9),11);
		sum.i := resize(resize(n1.i,9) + resize(n2.i,9),11);
		return sum;
	end add_1;
	
	function sub_1 (n1, n2 : complex_8) return complex_9 is
		variable diff : complex_9;
	begin
		diff.r := resize(n1.r,9) - resize(n2.r,9);
		diff.i := resize(n1.i,9) - resize(n2.i,9);
		return diff;
	end sub_1;
	
	function mult_1 (n1, n2 : complex_9) return complex_11 is
		variable prod : complex_19;
		variable output: complex_11;
	begin
		prod.r := resize(((n1.r * n2.r) - (n1.i * n2.i)),19);
		prod.i := resize(((n1.r * n2.i) + (n1.i * n2.r)),19);
		output.r := prod.r(18 downto 8);
		output.i := prod.i(18 downto 8);
		return output;
	end mult_1;
	-- S2
	function add_2 (n1, n2 : complex_11) return complex_14 is
		variable sum : complex_14;
	begin
		sum.r := resize(resize(n1.r,12) + resize(n2.r,12),14);
		sum.i := resize(resize(n1.i,12) + resize(n2.i,12),14);
		return sum;
	end add_2;
	
	function sub_2 (n1, n2 : complex_11) return complex_12 is
		variable diff : complex_12;
	begin
		diff.r := resize(n1.r,12) - resize(n2.r,12);
		diff.i := resize(n1.i,12) - resize(n2.i,12);
		return diff;
	end sub_2;
	
	function mult_2 (n1: complex_12; n2 : complex_9) return complex_14 is
		variable prod : complex_22;
		variable output: complex_14;
	begin
		prod.r := resize(((n1.r * n2.r) - (n1.i * n2.i)),22);
		prod.i := resize(((n1.r * n2.i) + (n1.i * n2.r)),22);
		output.r := prod.r(21 downto 8);
		output.i := prod.i(21 downto 8);
		return output;
	end mult_2;
	-- S3
	function add_3 (n1, n2 : complex_14) return complex_16 is
		variable sum : complex_16;
	begin
		sum.r := resize(resize(n1.r,15) + resize(n2.r,15),16);
		sum.i := resize(resize(n1.i,15) + resize(n2.i,15),16);
		return sum;
	end add_3;
	
	function sub_3 (n1, n2 : complex_14) return complex_15 is
		variable diff : complex_15;
	begin
		diff.r := resize(n1.r,15) - resize(n2.r,15);
		diff.i := resize(n1.i,15) - resize(n2.i,15);
		return diff;
	end sub_3;
	
	function mult_3 (n1 : complex_15; n2 : complex_9) return complex_16 is
		variable prod : complex_24;
		variable output: complex_16;
	begin
		prod.r := resize(((n1.r * n2.r) - (n1.i * n2.i)),24);
		prod.i := resize(((n1.r * n2.i) + (n1.i * n2.r)),24);
		output.r := prod.r(23 downto 8);
		output.i := prod.i(23 downto 8);
		return output;
	end mult_3;
end fft_pkg;