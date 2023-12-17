library ieee;
use ieee.std_logic_1164.all;

use work.uart_pac.all;
use work.uarttdr_pac.all;

entity uarttdr is
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
end uarttdr;

architecture rtl of uarttdr is

    signal tdr_reg : std_logic_vector(7 downto 0) := (others => '0');

begin

    Transmit_Data_Register : process (
        uarttdr_te_in,
        uarttdr_clk_in,
        uarttdr_rst_in,
        uarttdr_we_in,
        uarttdr_addr_in,
        uarttdr_di_in
    )
    begin
        if (uarttdr_clk_in'event and uarttdr_clk_in = '1') then
            if ((uarttdr_rst_in = '1')
             or (uarttdr_te_in  = '0')) then
                tdr_reg <= (others => '0');
            else
                if ((uarttdr_cs_in   = '1'           )
                and (uarttdr_addr_in = UART_ADDR_TDR)
                and (uarttdr_we_in   = '1'           )) then
                    tdr_reg <= uarttdr_di_in;
                end if;
            end if;
        end if;
    end process;

    uarttdr_do_out <= tdr_reg;

end rtl;
