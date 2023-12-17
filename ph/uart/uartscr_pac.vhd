library ieee;
use ieee.std_logic_1164.all;

package uartscr_pac is

    type st_uartscr_if is
    record
        tie_reg  : std_logic; -- bit7  : Transmit Interrupt Enable
        rie_reg  : std_logic; -- bit6  : Receive Interrupt Enable
        te_reg   : std_logic; -- bit5  : Transmit Enable
        re_reg   : std_logic; -- bit4  : Receive Enable
        teie_reg : std_logic; -- bit2  : Transmit End Interrupt Enable
    end record;

    constant st_uartscr_if_INIT : st_uartscr_if :=(
        '0', -- tie_reg
        '0', -- rie_reg
        '0', -- te_reg
        '0', -- re_reg
        '0'  -- teie_reg
    );

    component uartscr
        port (
            uartscr_cs_in   : in    std_logic;
            uartscr_clk_in  : in    std_logic;
            uartscr_rst_in  : in    std_logic;

            uartscr_we_in   : in    std_logic;
            uartscr_addr_in : in    std_logic_vector( 3 downto 0);
            uartscr_di_in   : in    std_logic_vector( 7 downto 0);
            uartscr_do_out  :   out st_uartscr_if
        );
    end component;

end uartscr_pac;

-- package body uartscr_pac is
-- end uartscr_pac;
