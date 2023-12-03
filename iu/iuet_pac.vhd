library ieee;
use ieee.std_logic_1164.all;

package iuet_pac is

    component iuet
        port (
            iuet_clk_in : in    std_logic;
            iuet_rst_in : in    std_logic;
            iuet_we_in  : in    std_logic;
            iuet_di_in  : in    std_logic;
            iuet_do_out :   out std_logic
        );
    end component;

end iuet_pac;

-- package body iuet_pac is
-- end iuet_pac;
