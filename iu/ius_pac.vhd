library ieee;
use ieee.std_logic_1164.all;

package ius_pac is

    component ius
        port (
            ius_clk_in : in    std_logic;
            ius_rst_in : in    std_logic;
            ius_we_in  : in    std_logic;
            ius_di_in  : in    std_logic;
            ius_do_out :   out std_logic
        );
    end component;

end ius_pac;

-- package body ius_pac is
-- end ius_pac;
