--Engineer     : Rui Wang
--Date         : February 3rd, 2025
--Name of file : tb_my_barrel_shifter.vhd
--Description  : test bench for my barrel shifter 16-bit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.env.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_barrel_shifter is
  -- no ports needed for this since this 
  -- is the top most module and no interaction
  -- with outside modules needed
end tb_barrel_shifter;

architecture tb_behav_barrel of tb_barrel_shifter is
  -- Convert sld_logic_vector to string
  procedure slv_to_string(slv : in std_logic_vector; str : out string) is
  begin
    for i in slv'range loop
      if slv(i) = '1' then
        str(slv'left - i + 1) := '1';
      else
        str(slv'left - i + 1) := '0';
      end if;
    end loop;
  end procedure;

  --the component instructs the compiler that the 
  --following module(ip) is going to be used in the design
  component barrel_shifter
    port (input  : in  std_logic_vector(15 downto 0);
          ctrl   : in  std_logic_vector(3 downto 0);
          output : out std_logic_vector(15 downto 0));
  end component;
  --signals local only to the present ip
  signal  input_data : std_logic_vector (15 downto 0);
  signal   ctrl_data : std_logic_vector (3 downto 0);
  signal output_data : std_logic_vector (15 downto 0);
  --signals related to the file operations
  file   output_file : text;
begin
    DUT : barrel_shifter port map (input  => input_data,
                                   ctrl   => ctrl_data,
                                   output => output_data);
    process 
      variable input_line : line;
      variable output_line: line;
      variable output_str : string(1 to 16); -- String to store converted output
    begin
      file_open(output_file, "output.txt", write_mode);

      -- STIMULATE THE DESIGN - PART 1
      -- Initialize the input
      input_data <= (others => '0');
      ctrl_data  <= (others => '0');
      wait for 10 ns;
      write(output_line, output_data, right, 16);
      writeline(output_file, output_line);
      for i in 1 to 15 loop
        input_data <= std_logic_vector(unsigned(input_data) + 1);
        ctrl_data  <= std_logic_vector(unsigned(ctrl_data)  + 1);
        wait for 10 ns;
        write(output_line, output_data, right, 16);
        writeline(output_file, output_line);
      end loop;
      
      -- STIMULATE THE DESIGN - PART 2
      -- Add your test cases here , use a granularity of 10ns between 3 test cases
      input_data <= "0000000000000001";
      ctrl_data <= "0010";
      wait for 10 ns;
      write(output_line, output_data, right, 16);
      writeline(output_file, output_line);
      report "Test case 0: expected result 0000000000000100";
      slv_to_string(output_data, output_str);
      report "Test case 0: actual result " & output_str;

      -- ADD TEST CASE 1 BELOW THIS LINE
      -- My GTID is 904024640
      input_data <= "0000001110001000"; -- 902
      ctrl_data <= "0011";
      wait for 10 ns;
      write(output_line, output_data, right, 16);
      writeline(output_file, output_line);
      report "Test case 1: expected result 0001110001000000";
      slv_to_string(output_data, output_str);
      report "Test case 1: actual result " & output_str;

      -- ADD TEST CASE 2 BELOW THIS LINE
      input_data <= "0000000000011000"; -- 024
      ctrl_data <= "0110";
      wait for 10 ns;
      write(output_line, output_data, right, 16);
      writeline(output_file, output_line);
      report "Test case 2: expected result 0000011000000000";
      slv_to_string(output_data, output_str);
      report "Test case 2: actual result " & output_str;

      -- ADD TEST CASE 3 BELOW THIS LINE
      input_data <= "0000001010000000"; -- 640
      ctrl_data <= "1001";
      wait for 10 ns;
      write(output_line, output_data, right, 16);
      writeline(output_file, output_line);
      report "Test case 3: expected result 0000000000000101";
      slv_to_string(output_data, output_str);
      report "Test case 3: actual result " & output_str;

      -- assert false
      file_close(output_file);
      report "Test completed";
      stop(0);
    end process;

end tb_behav_barrel;    
