library ieee;
use ieee.std_logic_1164.all;

package uartbrr_pac is

    component uartbrr
        port (
            uartbrr_cs_in   : in    std_logic;
            uartbrr_clk_in  : in    std_logic;
            uartbrr_rst_in  : in    std_logic;

            uartbrr_we_in   : in    std_logic;
            uartbrr_addr_in : in    std_logic_vector( 3 downto 0);
            uartbrr_di_in   : in    std_logic_vector( 7 downto 0);
            uartbrr_do_out  :   out std_logic_vector( 7 downto 0)
        );
    end component;

end uartbrr_pac;

-- package body uartbrr_pac is
-- end uartbrr_pac;
