library ieee;
use ieee.std_logic_1164.all;

package cmtcks_pac is

    component cmtcks
        port (
            cmtcks_cs_in   : in    std_logic;
            cmtcks_clk_in  : in    std_logic;
            cmtcks_rst_in  : in    std_logic;
            cmtcks_cks_in  : in    std_logic_vector (1 downto 0);
            cmtcks_clk_out :   out std_logic
        );
    end component;

end cmtcks_pac;

-- package body cmtcks_pac is
-- end cmtcks_pac;
