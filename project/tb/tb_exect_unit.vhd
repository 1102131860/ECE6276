library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity exect_unit_tb is
    -- no ports
end exect_unit_tb;

architecture sim of exect_unit_tb is

    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal in_valid  : std_logic := '0';
    signal data_in_0 : signed(5 downto 0) := (others => '0');
    signal data_in_1 : signed(5 downto 0) := (others => '0');
    
    signal data_out  : signed(9 downto 0);
    signal out_valid : std_logic;
    
begin

    DUT: entity work.exect_unit
        port map (
            clk       => clk,
            rst       => rst,
            in_valid  => in_valid,
            data_in_0 => data_in_0,
            data_in_1 => data_in_1,
            data_out  => data_out,
            out_valid => out_valid
        );
        

    clk_gen: process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process clk_gen;
    
    stim_proc: process
    begin
        -- reset
        rst <= '1';
        in_valid <= '0';
        data_in_0 <= to_signed(0, 6);
        data_in_1 <= to_signed(0, 6);
        wait for 20 ns;
        
        rst <= '0';
        wait for 10 ns;
        
        ----------------------------------------------------------------------------
        -- Test 1
        ----------------------------------------------------------------------------
        -- in_valid <= '1';
        -- data_in_0 <= to_signed(10, 6);  -- 10
        -- data_in_1 <= to_signed(-2, 6);  -- -2
        -- wait for 10 ns;
        
        -- in_valid <= '0';
        -- wait for 10 ns;
        
        ----------------------------------------------------------------------------
        -- Test 2
        ----------------------------------------------------------------------------
        -- in_valid <= '1';
        -- data_in_0 <= to_signed(3, 6);   -- 3
        -- data_in_1 <= to_signed(5, 6);   -- 5
        -- wait for 10 ns;
        
        -- in_valid <= '0';
        -- wait for 20 ns;
        
        ----------------------------------------------------------------------------
        -- Test 3
        ----------------------------------------------------------------------------
        in_valid <= '1';
        data_in_0 <= to_signed(-8, 6);  -- -8
        data_in_1 <= to_signed(12, 6);  -- 12
        wait for 10 ns;
        -- continous data stream
        data_in_0 <= to_signed(6, 6);
        data_in_1 <= to_signed(-6, 6);
        wait for 10 ns;
        data_in_0 <= to_signed(8, 6);
        data_in_1 <= to_signed(-9, 6);
        wait for 10 ns;
        data_in_0 <= to_signed(-10, 6);
        data_in_1 <= to_signed(7, 6);
        wait for 10 ns;
        in_valid <= '0';
        wait for 50 ns;
        
        report "Test completed";
        stop(0); -- end of stimulation
    end process stim_proc;

end sim;
