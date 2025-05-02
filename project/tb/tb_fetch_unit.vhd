library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity fetch_unit_tb is
end fetch_unit_tb;

architecture sim of fetch_unit_tb is

    -- Testbench signal
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '1';
    signal in_valid    : std_logic := '0';
    signal data_in_0   : signed(3 downto 0) := (others => '0');
    signal data_in_1   : signed(3 downto 0) := (others => '0');
    signal data_in_2   : signed(3 downto 0) := (others => '0');
    signal data_in_3   : signed(3 downto 0) := (others => '0');
    
    signal next_in     : std_logic;
    signal out_valid   : std_logic;
    signal addr_0      : unsigned(3 downto 0);
    signal addr_1      : unsigned(3 downto 0);

begin
    -- DUT instantize
    dut: entity work.fetch_unit
        port map (
            clk      => clk,
            rst      => rst,
            in_valid => in_valid,
            data_in_0=> data_in_0,
            data_in_1=> data_in_1,
            data_in_2=> data_in_2,
            data_in_3=> data_in_3,
            next_in  => next_in,
            out_valid=> out_valid,
            addr_0   => addr_0,
            addr_1   => addr_1
        );

    -- generate clock
    clk_gen: process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Stimulus Process
    stim_proc: process
    begin
        -- reset
        rst      <= '1';
        in_valid <= '0';
        data_in_0<= to_signed(1, 4);
        data_in_1<= to_signed(2, 4);
        data_in_2<= to_signed(3, 4);
        data_in_3<= to_signed(4, 4);
        wait for 20 ns;  -- keep 20 ns

        rst <= '0';      -- reset
        wait for 20 ns;

        -- stimulus invalid signal, and load a group of data
        in_valid <= '1';
        data_in_0 <= to_signed(1, 4);           -- 0001
        data_in_1 <= to_signed(-1, 4);          -- 1111
        data_in_2 <= to_signed(2, 4);           -- 0010
        data_in_3 <= to_signed(-2, 4);          -- 1110

        wait for 10 ns;  -- wait 10 ns, load data into fetch_unit

        -- stop stimulus, set in_valid to low to observe
        in_valid <= '0';

        -- observe for a long time, and check next_in, out_valid, addr_0 and addr_1
        wait for 100 ns;

        -- you can add more tests here

        report "Test completed";
        stop(0); -- end of stimulation
    end process;

end sim;
