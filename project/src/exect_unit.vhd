-- Executing Unit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exect_unit is
    port (
        -- input side
        clk, rst, in_valid          : in  std_logic;
        data_in_0, data_in_1        : in  signed(5 downto 0);
        -- output side
        data_out                    : out signed(9 downto 0);
        out_valid                   : out std_logic
    );
end exect_unit;

architecture fsm_exect of exect_unit is
    -- Define FSM
    type state_t is (S0, S1);
    signal state, next_state : state_t := S0; 

    -- acculuamlated from ROM
    signal acc_res : signed(9 downto 0) := (others => '0');             -- a pipelined registers for data_out as well
    signal next_acc_res : signed(9 downto 0) := (others => '0');

    -- pipelined registers
    signal next_out_valid : std_logic := '0';

begin
    -------------------------------------------------------------------
    -- Synchronously update state, acc_res, data_out and out_valid
    -------------------------------------------------------------------
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1' or in_valid = '0') then
                state <= S0;
                acc_res <= (others => '0');
                -- data_out <= (others => '0');     -- unused in synthesis
                out_valid <= '0';
            else
                state <= next_state;
                acc_res <= next_acc_res;
                data_out <= next_acc_res;
                out_valid <= next_out_valid;
            end if;
        end if;
    end process;

    -------------------------------------------------------------------
    -- Combinational logic
    -------------------------------------------------------------------
    process(state, data_in_0, data_in_1, acc_res)
    begin
        case state is
            when S0 =>
                next_state <= S1;
                next_acc_res <= resize(data_in_0, 10) + (resize(data_in_1, 10)(8 downto 0) & '0');
                next_out_valid <= '0';
            when S1 =>
                next_state <= S0; 
                next_acc_res <= acc_res + (resize(data_in_0, 10)(7 downto 0) & "00") - (resize(data_in_1, 10)(6 downto 0) & "000");
                next_out_valid <= '1';
        end case;
    end process;

end fsm_exect;
