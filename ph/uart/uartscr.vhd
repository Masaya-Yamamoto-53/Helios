library ieee;
use ieee.std_logic_1164.all;

use work.uartscr_pac.all;
use work.uart_pac.all;

entity uartscr is
    port (
        uartscr_cs_in   : in    std_logic;
        uartscr_clk_in  : in    std_logic;
        uartscr_rst_in  : in    std_logic;

        uartscr_we_in   : in    std_logic;
        uartscr_addr_in : in    std_logic_vector( 3 downto 0);
        uartscr_di_in   : in    std_logic_vector( 7 downto 0);
        uartscr_do_out  :   out st_uartscr_if
    );
end uartscr;

architecture rtl of uartscr is

    signal scr_reg : st_uartscr_if := st_uartscr_if_INIT;

begin

    Serial_Control_Register : process (
        uartscr_cs_in,
        uartscr_clk_in,
        uartscr_rst_in,
        uartscr_addr_in,
        uartscr_we_in
    ) begin
        if (uartscr_clk_in'event and uartscr_clk_in = '1') then
            if (uartscr_rst_in = '1') then
                scr_reg.tie_reg  <= st_uartscr_if_INIT.tie_reg;
                scr_reg.rie_reg  <= st_uartscr_if_INIT.rie_reg;
                scr_reg.te_reg   <= st_uartscr_if_INIT.te_reg;
                scr_reg.re_reg   <= st_uartscr_if_INIT.re_reg;
                scr_reg.teie_reg <= st_uartscr_if_INIT.teie_reg;
            else
                if ((uartscr_cs_in   = '1'          )
                and (uartscr_addr_in = UART_ADDR_SCR)
                and (uartscr_we_in   = '1'          )) then
                    scr_reg.tie_reg  <= uartscr_di_in(7);
                    scr_reg.rie_reg  <= uartscr_di_in(6);
                    scr_reg.te_reg   <= uartscr_di_in(5);
                    scr_reg.re_reg   <= uartscr_di_in(4);
                    scr_reg.teie_reg <= uartscr_di_in(2);
                end if;
            end if;
        end if;
    end process;

    uartscr_do_out <= scr_reg;

end rtl;
