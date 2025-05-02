library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity dual_ports_ROM_tb is
-- no port
end dual_ports_ROM_tb;

architecture sim of dual_ports_ROM_tb is

    signal enable          : std_logic := '0';
    signal address_0       : unsigned(3 downto 0) := (others => '0');
    signal address_1       : unsigned(3 downto 0) := (others => '0');
    signal out_valid       : std_logic;
    signal data_out_0      : signed(5 downto 0);
    signal data_out_1      : signed(5 downto 0);
    
begin
    DUT: entity work.dual_ports_ROM
        port map (
            enable      => enable,
            address_0   => address_0,
            address_1   => address_1,
            out_valid   => out_valid,
            data_out_0  => data_out_0,
            data_out_1  => data_out_1
        );

    stim_proc: process
    begin
        -- Test 1: enable = '0', data_out_x should be 0
        enable    <= '0';
        address_0 <= "0000";
        address_1 <= "0000";
        wait for 20 ns;
        
        -- Test 2: enable = '1'
        -- address_0 = "0001"  => only bit0 is '1', expect output 7
        -- address_1 = "0001"  => same
        enable    <= '1';
        address_0 <= "0001";
        address_1 <= "0001";
        wait for 20 ns;
        
        -- Test 3: enable = '1', select bit1
        -- address_0 = "0010"  => only bit1 is '1', expect output 3
        -- address_1 = "0010"  => same
        address_0 <= "0010";
        address_1 <= "0010";
        wait for 20 ns;
        
        -- Test 4: enable = '1', select bit2 and bit0
        -- address_0 = "0101"  => expect output = (-8 + 7) = -1
        -- address_1 = "0101"  => same
        address_0 <= "0101";
        address_1 <= "0101";
        wait for 20 ns;
        
        -- Test 5: enable = '1', select bit3 and bit1
        -- address_0 = "1010"  => bit3 = '1' (-5) and bit1 = '1' (3), expect output = (-5 + 3) = -2
        -- address_1 = "1010"  => same
        address_0 <= "1010";
        address_1 <= "1010";
        wait for 20 ns;
        
        -- Test 6: enable = '1', slect all bits
        -- address_0 = "1111"  => Expect output = 7 + 3 - 8 - 5 = -3
        -- address_1 = "1111"  => same
        address_0 <= "1111";
        address_1 <= "1111";
        wait for 20 ns;
        
        report "Test completed";
        stop(0); -- end of stimulation

    end process;
    
end sim;
