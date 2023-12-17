library ieee;
use ieee.std_logic_1164.all;

package segdispcks_pac is

    component segdispcks
        port (
            segdispcks_cs_in   : in    std_logic;
            segdispcks_clk_in  : in    std_logic;
            segdispcks_rst_in  : in    std_logic;
            segdispcks_cks_in  : in    std_logic_vector(1 downto 0);
            segdispcks_clk_out :   out std_logic
        );
    end component;

end segdispcks_pac;

-- package body segdispcks_pac is
-- end segdispcks_pac;
