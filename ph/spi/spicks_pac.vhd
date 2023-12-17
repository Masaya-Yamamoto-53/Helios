library ieee;
use ieee.std_logic_1164.all;

package spicks_pac is

    component spicks
        port (
            spicks_cs_in   : in    std_logic;
            spicks_clk_in  : in    std_logic;
            spicks_bclk_in : in    std_logic;
            spicks_rst_in  : in    std_logic;
            spicks_cks_in  : in    std_logic_vector(1 downto 0);
            spicks_clk_out :   out std_logic
        );
    end component;

end spicks_pac;

-- package body spicks_pac is
-- end spicks_pac;
