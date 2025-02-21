--Engineer     : Junyoung Hwang
--Date         : 02/10/2025
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
  -- IDLE: Current sequence is nothing
  -- S1  : Current sequence is ""
  -- S2  : Current sequence is ""
  -- S3  : Current sequence is ""
  -- S4  : Current sequence is ""
  -- S5  : Current sequence is ""
  signal state, next_state: state_type;

begin
  p_seq: process(clk) 
  begin
    if (rising_edge(clk)) then
      -- TODO 
  end process;

  p_comb: process(state, data_in) 
  begin
    case state is 
      -- TODO 

      
    end case;
  end process;

end arch;
