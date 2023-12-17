library ieee;
use ieee.std_logic_1164.all;

package uartssr_pac is

    type st_uartssr_if is
    record
        tdre_reg    : std_logic; -- bit7  : Transmit Data Empty
        rdrf_reg    : std_logic; -- bit6  : Receive Data Register Full
        orer_reg    : std_logic; -- bit5  : Overrun Error
        fer_reg     : std_logic; -- bit4  : Framing Error
        per_reg     : std_logic; -- bit3  : Parity  Error
        tend_reg    : std_logic; -- bit2  : Transmit End
    end record;
    constant st_uartssr_if_INIT : st_uartssr_if :=(
        '1', -- tdre_reg
        '0', -- rdrf_reg
        '0', -- orer_reg
        '0', -- fer_reg
        '0', -- per_reg
        '1'  -- tend_reg
    );

    component uartssr
        port (
            uartssr_cs_in   : in    std_logic;
            uartssr_clk_in  : in    std_logic;
            uartssr_rst_in  : in    std_logic;

            uartssr_tei_in  : in    std_logic;
            uartssr_rdrf_in : in    std_logic;

            uartssr_orer_in : in    std_logic;
            uartssr_fer_in  : in    std_logic;
            uartssr_per_in  : in    std_logic;

            uartssr_tend_in : in    std_logic;

            uartssr_we_in   : in    std_logic;
            uartssr_addr_in : in    std_logic_vector( 3 downto 0);
            uartssr_di_in   : in    std_logic_vector( 7 downto 0);
            uartssr_do_out  :   out st_uartssr_if
        );
    end component;

end uartssr_pac;

-- package body uartssr_pac is
-- end uartssr_pac;
