library ieee;
use ieee.std_logic_1164.all;

package uartbg_pac is

    component uartbg
        port (
            uartbg_en_in   : in    std_logic;
            uartbg_clk_in  : in    std_logic;
            uartbg_rst_in  : in    std_logic;
            uartbg_scbr_in : in    std_logic_vector(7 downto 0);
            uartbg_clk_out :   out std_logic
        );
    end component;

end uartbg_pac;

-- package body uartbg_pac is
-- end uartbg_pac;
