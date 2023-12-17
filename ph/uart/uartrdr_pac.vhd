library ieee;
use ieee.std_logic_1164.all;

package uartrdr_pac is

    component uartrdr
        port (
            uartrdr_cs_in     : in    std_logic;
            uartrdr_clk_in    : in    std_logic;
            uartrdr_rst_in    : in    std_logic;

            uartrdr_chr_in    : in    std_logic;
            uartrdr_rx_end_in : in    std_logic;

            uartrdr_di_in     : in    std_logic_vector( 7 downto 0);
            uartrdr_do_out    :   out std_logic_vector( 7 downto 0)
        );
    end component;

end uartrdr_pac;

-- package body uartrdr_pac is
-- end uartrdr_pac;
