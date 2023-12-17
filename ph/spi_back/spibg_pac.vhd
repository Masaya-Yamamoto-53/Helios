library ieee;
use ieee.std_logic_1164.all;

package spibg_pac is

    component spibg
        port (
            spibg_en_in   : in    std_logic;
            spibg_clk_in  : in    std_logic;
            spibg_rst_in  : in    std_logic;
            spibg_scbr_in : in    std_logic_vector(7 downto 0);
            spibg_clk_out :   out std_logic
        );
    end component;

end spibg_pac;

-- package body spibg_pac is
-- end spibg_pac;
