library ieee;
use ieee.std_logic_1164.all;

use work.uartsmr_pac.all;
use work.uart_pac.all;

entity uartsmr is
    port (
        uartsmr_cs_in   : in    std_logic;
        uartsmr_clk_in  : in    std_logic;
        uartsmr_rst_in  : in    std_logic;

        uartsmr_we_in   : in    std_logic;
        uartsmr_addr_in : in    std_logic_vector( 3 downto 0);
        uartsmr_di_in   : in    std_logic_vector( 7 downto 0);
        uartsmr_do_out  :   out st_uartsmr_if
    );
end uartsmr;

architecture rtl of uartsmr is

    signal smr_reg : st_uartsmr_if := st_uartsmr_if_INIT;

begin

    Serial_Mode_Register : process (
        uartsmr_cs_in,
        uartsmr_clk_in,
        uartsmr_rst_in,
        uartsmr_addr_in,
        uartsmr_we_in
    ) begin
        if (uartsmr_clk_in'event and uartsmr_clk_in = '1') then
            if (uartsmr_rst_in = '1') then
                smr_reg.chr_reg  <= st_uartsmr_if_INIT.chr_reg;
                smr_reg.pe_reg   <= st_uartsmr_if_INIT.pe_reg;
                smr_reg.pm_reg   <= st_uartsmr_if_INIT.pm_reg;
                smr_reg.stop_reg <= st_uartsmr_if_INIT.stop_reg;
                smr_reg.cks_reg  <= st_uartsmr_if_INIT.cks_reg;
            else
                if ((uartsmr_cs_in   = '1'           )
                and (uartsmr_addr_in = UART_ADDR_SMR )
                and (uartsmr_we_in   = '1'           )) then
                    smr_reg.chr_reg  <= uartsmr_di_in(6);
                    smr_reg.pe_reg   <= uartsmr_di_in(5);
                    smr_reg.pm_reg   <= uartsmr_di_in(4);
                    smr_reg.stop_reg <= uartsmr_di_in(3);
                    smr_reg.cks_reg  <= uartsmr_di_in(1 downto 0);
                end if;
            end if;
        end if;
    end process;

    uartsmr_do_out <= smr_reg;

end rtl;
