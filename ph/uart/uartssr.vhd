library ieee;
use ieee.std_logic_1164.all;

use work.uartssr_pac.all;
use work.uart_pac.all;

entity uartssr is
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
end uartssr;

architecture rtl of uartssr is

    signal ssr_reg : st_uartssr_if := st_uartssr_if_INIT;
    signal tdre_we_reg : std_logic := '0'; -- TDRE Write Enable
    signal rdrf_we_reg : std_logic := '0'; -- RDRF Write Enable
    signal orer_we_reg : std_logic := '0'; -- ORER Write Enable
    signal fer_we_reg  : std_logic := '0'; -- FER  Write Enable
    signal per_we_reg  : std_logic := '0'; -- PER  Write Enable

begin

    Serial_Status_Register : process (
        uartssr_cs_in,
        uartssr_clk_in,
        uartssr_rst_in,
        uartssr_we_in,
        uartssr_addr_in,
        uartssr_di_in
    ) begin
        if (uartssr_clk_in'event and uartssr_clk_in = '1') then
            if (uartssr_rst_in = '1') then
                ssr_reg.tdre_reg <= st_uartssr_if_INIT.tdre_reg;
                ssr_reg.rdrf_reg <= st_uartssr_if_INIT.rdrf_reg;
                ssr_reg.orer_reg <= st_uartssr_if_INIT.orer_reg;
                ssr_reg.fer_reg  <= st_uartssr_if_INIT.fer_reg;
                ssr_reg.per_reg  <= st_uartssr_if_INIT.per_reg;
                ssr_reg.tend_reg <= st_uartssr_if_INIT.tend_reg;
                tdre_we_reg <= '0';
                rdrf_we_reg <= '0';
                orer_we_reg <= '0';
                fer_we_reg  <= '0';
                per_we_reg  <= '0';
            else
                -----------------------------------------------------------
                -- bit7 : Transmit Data Empty                            --
                -----------------------------------------------------------
                if     (uartssr_tei_in = '1')  then
                    ssr_reg.tdre_reg <= '1';
                    tdre_we_reg      <= '0';
                -- Notice:
                -- To clear this bit, the system needs to read the value once.
                elsif ((uartssr_cs_in   = '1'           )
                   and (uartssr_addr_in = UART_ADDR_SSR)
                   and (uartssr_we_in   = '0'           )) then
                   if (ssr_reg.tdre_reg = '1') then
                        tdre_we_reg <= '1';
                    else
                        tdre_we_reg <= '0';
                    end if;
                -- If the system has read the value once, allow it to write.
                elsif ((uartssr_cs_in   = '1'           )
                   and (uartssr_addr_in = UART_ADDR_SSR)
                   and (uartssr_we_in   = '1'           )
                   and (tdre_we_reg     = '1'           )) then
                    ssr_reg.tdre_reg <= uartssr_di_in(7);
                    tdre_we_reg      <= '0';
                end if;

                -----------------------------------------------------------
                -- bit6: RDRF : Receive Data Register Full               --
                -----------------------------------------------------------
                if     (uartssr_rdrf_in = '1')  then
                    ssr_reg.rdrf_reg <= '1';
                    rdrf_we_reg      <= '0';
                -- Notice:
                -- To clear this bit, the system needs to read the value once.
                elsif ((uartssr_cs_in   = '1'          )
                   and (uartssr_addr_in = UART_ADDR_SSR)
                   and (uartssr_we_in   = '0'          )) then
                    if (ssr_reg.rdrf_reg = '1') then
                        rdrf_we_reg <= '1';
                    else
                        rdrf_we_reg <= '0';
                    end if;
                -- If the system has read the value once, allow it to write.
                elsif ((uartssr_cs_in   = '1'          )
                   and (uartssr_addr_in = UART_ADDR_SSR)
                   and (uartssr_we_in   = '1'          )
                   and (rdrf_we_reg     = '1'          )) then
                    ssr_reg.rdrf_reg    <= uartssr_di_in(6);
                    rdrf_we_reg <= '0';
                end if;

                -----------------------------------------------------------
                -- bit5: ORER : Overrun Error                            --
                -----------------------------------------------------------
                if     (uartssr_orer_in = '1')  then
                    ssr_reg.orer_reg <= '1';
                    orer_we_reg      <= '0';
                -- Notice:
                -- To clear this bit, the system needs to read the value once.
                elsif ((uartssr_cs_in   = '1'          )
                   and (uartssr_addr_in = UART_ADDR_SSR)
                   and (uartssr_we_in   = '0'          )) then
                    if (ssr_reg.orer_reg = '1') then
                        orer_we_reg <= '1';
                    else
                        orer_we_reg <= '0';
                    end if;
                -- If the system has read the value once, allow it to write.
                elsif ((uartssr_cs_in   = '1'          )
                   and (uartssr_addr_in = UART_ADDR_SSR)
                   and (uartssr_we_in   = '1'          )
                   and (orer_we_reg     = '1'          )) then
                    ssr_reg.orer_reg <= uartssr_di_in(3);
                    orer_we_reg      <= '0';
                end if;

                -----------------------------------------------------------
                -- bit4: FER  : Framing Error                            --
                -----------------------------------------------------------
                if     (uartssr_fer_in  = '1')  then
                    ssr_reg.fer_reg    <= '1';
                    fer_we_reg <= '0';
                -- notice:
                -- to clear this bit, the system needs to read the value once.
                elsif ((uartssr_cs_in   = '1'          )
                   and (uartssr_addr_in = UART_ADDR_SSR)
                   and (uartssr_we_in   = '0'          )) then
                    if (ssr_reg.fer_reg = '1') then
                        fer_we_reg <= '1';
                    else
                        fer_we_reg <= '0';
                    end if;
                -- If the system has read the value once, allow it to write.
                elsif ((uartssr_cs_in   = '1'          )
                   and (uartssr_addr_in = UART_ADDR_SSR)
                   and (uartssr_we_in   = '1'          )
                   and (fer_we_reg      = '1'          )) then
                    ssr_reg.fer_reg    <= uartssr_di_in(5);
                    fer_we_reg <= '0';
                end if;

                -----------------------------------------------------------
                -- bit3: PER  : Parity  Error                            --
                -----------------------------------------------------------
                if     (uartssr_per_in  = '1')  then
                    ssr_reg.per_reg    <= '1';
                    per_we_reg <= '0';
                -- notice:
                -- to clear this bit, the system needs to read the value once.
                elsif ((uartssr_cs_in   = '1'          )
                   and (uartssr_addr_in = UART_ADDR_SSR)
                   and (uartssr_we_in   = '0'          )) then
                    if (ssr_reg.per_reg = '1') then
                        per_we_reg <= '1';
                    else
                        per_we_reg <= '0';
                    end if;
                -- If the system has read the value once, allow it to write.
                elsif ((uartssr_cs_in   = '1'          )
                   and (uartssr_addr_in = UART_ADDR_SSR)
                   and (uartssr_we_in   = '1'          )
                   and (per_we_reg      = '1'          )) then
                    ssr_reg.per_reg    <= uartssr_di_in(4);
                    per_we_reg <= '0';
                end if;

                -----------------------------------------------------------
                -- bit2: TEND : Transmit End
                -----------------------------------------------------------
                -- TEND is Read Only Register
                if    (uartssr_tend_in  = '1')  then
                    ssr_reg.tend_reg    <= '1';
                elsif ((uartssr_cs_in   = '1'          )
                   and (uartssr_addr_in = UART_ADDR_SSR)
                   and (uartssr_we_in   = '1'          )) then
                    ssr_reg.tend_reg <= uartssr_di_in(7);
                end if;
            end if;
        end if;
    end process;

    uartssr_do_out <= ssr_reg;

end rtl;
