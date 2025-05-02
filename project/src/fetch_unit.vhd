-- Fetch Unit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch_unit is
    port (
        -- Input side
        clk, rst, in_valid                          : in  std_logic;
        data_in_0, data_in_1, data_in_2, data_in_3  : in  signed(3 downto 0);
        -- Output side
        next_in, out_valid                          : out std_logic;
        addr_0, addr_1                              : out unsigned(3 downto 0)
    );
end fetch_unit;

architecture fsm_arch of fetch_unit is
    -- Define FSM
    type state_t is (S0, S1);
    signal state, next_state : state_t := S0;
    
    -- data to store 4 4-bit data
    signal data_0, data_1, data_2, data_3 : signed(3 downto 0) := (others => '0');

    -- piplined registers
    signal next_addr_0, next_addr_1 : unsigned(3 downto 0) := (others => '0');
    signal next_next_in, next_out_valid : std_logic := '0';
    
begin
    -------------------------------------------------------------------
    -- Synchronously update state, out_valid, next_in and addresses
    -------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                state <= S0;
                addr_0 <= (others => '0');
                addr_1 <= (others => '0');
                out_valid <= '0';
                next_in <= '1';
            else
                state <= next_state;
                addr_0 <= next_addr_0;
                addr_1 <= next_addr_1;
                out_valid <= next_out_valid;
                next_in <= next_next_in;

                -- sychronously load data at S0 and in_valid
                if (state = S0 and in_valid = '1') then
                    data_0 <= data_in_0;
                    data_1 <= data_in_1;
                    data_2 <= data_in_2;
                    data_3 <= data_in_3;
                end if;
            end if;
        end if;
    end process;
    
    -------------------------------------------------------------------
    -- Combinational Logic
    -------------------------------------------------------------------
    process(state, in_valid, data_in_3, data_in_2, data_in_1, data_in_0, data_3, data_2, data_1, data_0)
    begin
        case state is
            when S0 =>
                if (in_valid = '1') then
                    next_state <= S1;
                    -- use data_in to output addresses to avoid delay
                    next_addr_0 <= data_in_3(0) & data_in_2(0) & data_in_1(0) & data_in_0(0);
                    next_addr_1 <= data_in_3(1) & data_in_2(1) & data_in_1(1) & data_in_0(1);
                    -- output valid and cannot next in
                    next_out_valid <= '1';
                    next_next_in <= '0';
                else
                    next_state <= S0;
                    next_addr_0 <= (others => '0');
                    next_addr_1 <= (others => '0');
                    next_out_valid <= '0';
                    next_next_in <= '1';
                end if;
            when S1 =>
                next_state <= S0;
                -- use stored data to output addresses
                next_addr_0 <= data_3(2) & data_2(2) & data_1(2) & data_0(2);
                next_addr_1 <= data_3(3) & data_2(3) & data_1(3) & data_0(3);
                -- output valid and can next in
                next_out_valid <= '1';
                next_next_in <= '1'; -- only 1 stall is enough
        end case;
    end process;
    
end fsm_arch;
