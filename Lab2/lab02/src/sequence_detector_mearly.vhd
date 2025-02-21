--Engineer     : Rui Wang
--Date         : 02/21/2025
--Name of file : sequence_detector.vhd
--Description  : implements a sequence detector 
--               detecting "101110" using state machine

library ieee;
use ieee.std_logic_1164.all;

entity sequence_detector is
  port (
        clk, rst  : in  std_logic;
        data_in   : in  std_logic;
        data_out  : out std_logic 
       );
end sequence_detector;

architecture arch of sequence_detector is
  type state_type is (IDLE, S1, S2, S3, S4, S5);
  -- IDLE: Current sequence is "0"
  -- S1  : Current sequence is "1"
  -- S2  : Current sequence is "10"
  -- S3  : Current sequence is "101"
  -- S4  : Current sequence is "1011"
  -- S5  : Current sequence is "10111"
  signal state, next_state: state_type;

begin
  p_seq: process(clk) 
  begin
    if (rising_edge(clk)) then
      state <= next_state;
    end if; 
  end process p_seq;

  p_comb: process(state, data_in) 
  begin
    case state is 
      when IDLE =>
        if data_in = '1' then
          data_out <= '0';
          next_state <= S1;
        else
          data_out <= '0';
          next_state <= IDLE;
        end if;
      when S1 =>
        if data_in = '0' then
          data_out <= '0';
          next_state <= S2;
        else
          data_out <= '0';
          next_state <= S1;
        end if;
      when S2 =>
        if data_in = '1' then
          data_out <= '0';
          next_state <= S3;
        else
          data_out <= '0';
          next_state <= IDLE;
        end if;
      when S3 =>
        if data_in = '1' then
          data_out <= '0';
          next_state <= S4;
        else
          data_out <= '0';
          next_state <= S2;
        end if;
      when S4 =>
        if data_in = '1' then
          data_out <= '0';
          next_state <= S5;
        else
          data_out <= '0';
          next_state <= S2;
        end if;
      when S5 =>
        if data_in = '0' then
          data_out <= '1';
          next_state <= S2;
        else
          data_out <= '0';
          next_state <= S1;
        end if;
    end case;
  end process p_comb;

end arch;
