-- ROM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dual_ports_ROM is
    port(
        -- input side
        enable                  : in  std_logic;
        address_0, address_1    : in  unsigned (3 downto 0);
        -- output side
        out_valid               : out std_logic;
        data_out_0, data_out_1  : out signed (5 downto 0)
    );
end dual_ports_ROM;

architecture arch of dual_ports_ROM is
    -- Define LUT
    type LUT_t is array (0 to 3) of signed(3 downto 0);
    -- coef_0 = 7, coef_1 = 3, coef_2 =-8, coef_3 =-5
    constant table : LUT_t := (
        to_signed(7, 4),        -- coef_0
        to_signed(3, 4),        -- coef_1
        to_signed(-8, 4),       -- coef_2
        to_signed(-5, 4)        -- coef_3
    );

    -- partial sum
    type partial_array_t is array(0 to 3) of signed(5 downto 0);
    signal out0_partials    : partial_array_t := (others => (others => '0'));
    signal out1_partials    : partial_array_t := (others => (others => '0'));

begin
    -- out_valid is assigned to enable
    out_valid <= enable;

    -- use generate to assign
    gen_partials: for i in 0 to 3 generate
    begin
        out0_partials(i) <= resize(table(i), 6)
                            when (enable = '1' and address_0(i) = '1')
                            else (others => '0');
        out1_partials(i) <= resize(table(i), 6)
                            when (enable = '1' and address_1(i) = '1')
                            else (others => '0');
    end generate;

    -- sum up 
    data_out_0 <= out0_partials(0) + out0_partials(1) + out0_partials(2) + out0_partials(3);
    data_out_1 <= out1_partials(0) + out1_partials(1) + out1_partials(2) + out1_partials(3);

end arch;
