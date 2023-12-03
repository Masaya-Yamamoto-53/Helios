library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ius_pac.all;

entity ius is
    port (
        ius_clk_in : in    std_logic;
        ius_rst_in : in    std_logic;
        ius_we_in  : in    std_logic;
        ius_di_in  : in    std_logic;
        ius_do_out :   out std_logic
    );
end ius;

architecture rtl of ius is

    signal s_reg : std_logic := '1';

begin

    IU_Supervisor_Register : process (
        ius_clk_in,
        ius_rst_in,
        ius_we_in,
        ius_di_in,
        s_reg
    )
    begin
        if (ius_clk_in'event and ius_clk_in = '1') then
            if (ius_rst_in = '1') then
                s_reg <= '1';
            elsif (ius_we_in = '1') then
                s_reg <= ius_di_in;
            end if;
        end if;
    end process IU_Supervisor_Register;

    ius_do_out <= s_reg;

end rtl;
