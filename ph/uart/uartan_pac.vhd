library ieee;
use ieee.std_logic_1164.all;

package uartan_pac is

    component uartan
        port (
            uartan_clk_in  : in    std_logic;
            uartan_rst_in  : in    std_logic;
            uartan_sdi_in  : in    std_logic;
            uartan_sdi_out :   out std_logic
        );
    end component;

end uartan_pac;

-- package body uartan_pac is
-- end uartan_pac;
