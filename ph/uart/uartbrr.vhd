library ieee;
use ieee.std_logic_1164.all;

use work.uart_pac.all;
use work.uartbrr_pac.all;

entity uartbrr is
    port (
        uartbrr_cs_in   : in    std_logic;
        uartbrr_clk_in  : in    std_logic;
        uartbrr_rst_in  : in    std_logic;

        uartbrr_we_in   : in    std_logic;
        uartbrr_addr_in : in    std_logic_vector( 3 downto 0);
        uartbrr_di_in   : in    std_logic_vector( 7 downto 0);
        uartbrr_do_out  :   out std_logic_vector( 7 downto 0)
    );
end uartbrr;

architecture rtl of uartbrr is

    signal brr_reg : std_logic_vector(7 downto 0) := (others => '0');

begin

    Bit_Rate_Register : process (
        uartbrr_cs_in,
        uartbrr_clk_in,
        uartbrr_rst_in,
        uartbrr_addr_in,
        uartbrr_di_in
    ) begin
        if (uartbrr_clk_in'event and uartbrr_clk_in = '1') then
            if (uartbrr_rst_in = '1') then
                brr_reg <= (others => '0');
            else
                if ((uartbrr_cs_in   = '1'           )
                and (uartbrr_addr_in = UART_ADDR_BRR )
                and (uartbrr_we_in   = '1'           )) then
                    brr_reg <= uartbrr_di_in;
                end if;
            end if;
        end if;
    end process Bit_Rate_Register;

    uartbrr_do_out <= brr_reg;

end rtl;
