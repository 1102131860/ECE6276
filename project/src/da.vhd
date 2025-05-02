-- Top-level DA

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity da is
    port (
        -- input side
        clk, rst       : in  std_logic;
        data_in_0      : in  signed (3 downto 0);
        data_in_1      : in  signed (3 downto 0);
        data_in_2      : in  signed (3 downto 0);
        data_in_3      : in  signed (3 downto 0);
        in_valid       : in  std_logic;
        -- output side
        next_in        : out std_logic;
        data_out       : out signed (9 downto 0);
        out_valid      : out std_logic
    );
end da;

architecture arch of da is
    component fetch_unit is
        port (
            -- input side
            clk, rst, in_valid                              : in  std_logic;
            data_in_0, data_in_1, data_in_2, data_in_3      : in  signed (3 downto 0);
            -- output side
            next_in, out_valid                              : out std_logic;
            addr_0, addr_1                                  : out unsigned (3 downto 0)
        );
    end component;

    component dual_ports_ROM is
        port(
            -- input side
            enable                  : in  std_logic;
            address_0, address_1    : in  unsigned (3 downto 0);
            -- output side
            out_valid               : out std_logic;
            data_out_0, data_out_1  : out signed (5 downto 0)
        );
    end component;

    component exect_unit is
        port (
            -- input side
            clk, rst, in_valid          : in  std_logic;
            data_in_0, data_in_1        : in  signed (5 downto 0);
            -- output side
            data_out                    : out signed (9 downto 0);
            out_valid                   : out std_logic
        );
    end component;

    signal fetch_unit_out_valid                     : std_logic;
    signal fetch_unit_addr_0, fetch_unit_addr_1     : unsigned (3 downto 0);
    signal dp_rom_out_valid                         : std_logic;
    signal dp_rom_data_out_0, dp_rom_data_out_1     : signed (5 downto 0);

begin
    -- Instantiate fetch unit
    fetch_unit_inst: fetch_unit
        port map (
            -- input side
            clk => clk,
            rst => rst,
            in_valid => in_valid,
            data_in_0 => data_in_0,
            data_in_1 => data_in_1,
            data_in_2 => data_in_2,
            data_in_3 => data_in_3,
            -- output side
            next_in => next_in,
            out_valid => fetch_unit_out_valid,
            addr_0 => fetch_unit_addr_0,
            addr_1 => fetch_unit_addr_1
        );

    -- Instantiate ROM
    dp_rom_inst : dual_ports_ROM
        port map (
            -- input side
            enable => fetch_unit_out_valid,
            address_0 => fetch_unit_addr_0,
            address_1 => fetch_unit_addr_1,
            -- output side
            out_valid => dp_rom_out_valid,
            data_out_0 => dp_rom_data_out_0,
            data_out_1 => dp_rom_data_out_1
        );
    
    -- Instantiate executing unit
    excut_unit_inst: exect_unit
        port map (
            -- input side
            clk => clk,
            rst => rst,
            in_valid => dp_rom_out_valid,
            data_in_0 => dp_rom_data_out_0,
            data_in_1 => dp_rom_data_out_1,
            -- output side
            data_out => data_out,
            out_valid => out_valid
        );

end arch;
