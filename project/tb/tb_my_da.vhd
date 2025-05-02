library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb_da is
    -- no ports
end tb_da;

architecture sim of tb_da is
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';
    signal data_in_0 : signed(3 downto 0);
    signal data_in_1 : signed(3 downto 0);
    signal data_in_2 : signed(3 downto 0);
    signal data_in_3 : signed(3 downto 0);
    signal in_valid  : std_logic := '0';
    
    signal next_in   : std_logic;
    signal data_out  : signed(9 downto 0);
    signal out_valid : std_logic;
    
begin
    DUT: entity work.da
        port map (
            clk        => clk,
            rst        => rst,
            data_in_0  => data_in_0,
            data_in_1  => data_in_1,
            data_in_2  => data_in_2,
            data_in_3  => data_in_3,
            in_valid   => in_valid,
            next_in    => next_in,
            data_out   => data_out,
            out_valid  => out_valid
        );

    -------------------------------------------------------------------
    -- Generate Clock
    -------------------------------------------------------------------
    clk_gen: process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    -------------------------------------------------------------------
    -- Input stimulmus
    -------------------------------------------------------------------
    stim: process
    begin
        -- reset
        rst <= '1';
        in_valid <= '0';
        data_in_0 <= (others => '0');
        data_in_1 <= (others => '0');
        data_in_2 <= (others => '0');
        data_in_3 <= (others => '0');
        wait for 20 ns;
        
        rst <= '0';
        wait for 10 ns;
        
        -- test 1
        data_in_0 <= to_signed(3, 4);  -- 3
        data_in_1 <= to_signed(7, 4);  -- 7
        data_in_2 <= to_signed(2, 4);  -- 2
        data_in_3 <= to_signed(4, 4);  -- 4
        in_valid  <= '1';
        wait for 10 ns;                     -- one cycle
        in_valid  <= '0';
        wait for 30 ns;
        
        -- test 2
        data_in_0 <= to_signed(1, 4);
        data_in_1 <= to_signed(2, 4);
        data_in_2 <= to_signed(3, 4);
        data_in_3 <= to_signed(6, 4);
        in_valid  <= '1';
        wait for 10 ns;
        in_valid  <= '0';
        wait for 30 ns;
        
        -- 
        -- More tests!
        -- 

        -- test 3
        -- data_in_0 <= to_signed(5, 4);
        -- data_in_1 <= to_signed(-2, 4);
        -- data_in_2 <= to_signed(3, 4);
        -- data_in_3 <= to_signed(-7, 4);
        -- in_valid <= '1';
        -- wait for 10 ns;
        -- in_valid <= '0';
        -- wait for 10 ns;                 -- only wait for one cyle stall

        -- data_in_0 <= to_signed(5, 4);   -- input another group of
        -- data_in_1 <= to_signed(-2, 4);
        -- data_in_2 <= to_signed(3, 4);
        -- data_in_3 <= to_signed(-7, 4);
        -- in_valid <= '1';
        -- wait for 10 ns;
        -- in_valid <= '0';
        -- wait for 50 ns;                 -- check status



        report "Test completed";
        stop(0); -- end of stimulation
    end process;
    
end sim;
