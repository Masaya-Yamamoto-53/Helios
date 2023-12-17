library ieee;
use ieee.std_logic_1164.all;

package uarttdr_pac is

    component uarttdr
        port (
            uarttdr_cs_in   : in    std_logic;
            uarttdr_clk_in  : in    std_logic;
            uarttdr_rst_in  : in    std_logic;

            uarttdr_te_in   : in    std_logic;

            uarttdr_we_in   : in    std_logic;
            uarttdr_addr_in : in    std_logic_vector( 3 downto 0);
            uarttdr_di_in   : in    std_logic_vector( 7 downto 0);
            uarttdr_do_out  :   out std_logic_vector( 7 downto 0)
        );
    end component;

end uarttdr_pac;

-- package body uarttdr_pac is
-- end uarttdr_pac;
