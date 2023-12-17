library ieee;
use ieee.std_logic_1164.all;

package uartcks_pac is

    component uartcks
        port (
            uartcks_en_in   : in    std_logic;
            uartcks_clk_in  : in    std_logic;
            uartcks_rst_in  : in    std_logic;
            uartcks_cks_in  : in    std_logic_vector(1 downto 0);
            uartcks_clk_out :   out std_logic
        );
    end component;

end uartcks_pac;

-- package body uartcks_pac is
-- end uartcks_pac;
