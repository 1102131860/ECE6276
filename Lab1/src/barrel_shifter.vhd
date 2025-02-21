--Engineer     : Rui Wang
--Date         : February, 3rd, 2025
--Name of file : my_barrel_shifter.vhd
--Description  : implements a left-shifted barrel shifter
--               of data width 16 bits, a ctrl-word of bit-width of 4 bits

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity barrel_shifter is
    --port list
    port(
         input  : in  std_logic_vector(15 downto 0); -- input data
         ctrl   : in  std_logic_vector(3 downto 0);  -- control word
         output : out std_logic_vector(15 downto 0)  -- output data
        );
end barrel_shifter;

architecture barrel_arch of barrel_shifter is
begin
    rotate_shift_left: process (input, ctrl)
        variable shift_bit : integer range 0 to 15;
        variable index : integer := 0;

    begin
        shift_bit := to_integer(unsigned(ctrl));

        for i in 0 to 15 loop
            index := i + shift_bit;
            if index > 15 then
                index := index - 16;
            end if;

            output(index) <= input(i);
        end loop;

    end process rotate_shift_left;
end barrel_arch; 
