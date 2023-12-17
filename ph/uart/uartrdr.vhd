library ieee;
use ieee.std_logic_1164.all;

use work.uart_pac.all;
use work.uartrdr_pac.all;

entity uartrdr is
    port (
        uartrdr_cs_in     : in    std_logic;
        uartrdr_clk_in    : in    std_logic;
        uartrdr_rst_in    : in    std_logic;

        uartrdr_chr_in    : in    std_logic;
        uartrdr_rx_end_in : in    std_logic;

        uartrdr_di_in     : in    std_logic_vector( 7 downto 0);
        uartrdr_do_out    :   out std_logic_vector( 7 downto 0)
    );
end uartrdr;

architecture rtl of uartrdr is

    signal rdr_reg : std_logic_vector(7 downto 0) := (others => '0');

begin

    UART_Receive_Data_Register : process (
        uartrdr_clk_in,
        uartrdr_rst_in,
        uartrdr_di_in,
        uartrdr_chr_in,
        uartrdr_rx_end_in
    )
    begin
        if (uartrdr_clk_in'event and uartrdr_clk_in = '1') then
            if (uartrdr_rst_in = '1') then
                rdr_reg <= (others => '0');
            else
                if (uartrdr_rx_end_in = '1') then
                    -- character length 8bit or 7bit
                    if (uartrdr_chr_in = '0') then -- 8bits
                        rdr_reg <= uartrdr_di_in;
                    else                           -- 7bits
                        rdr_reg <= "0" & uartrdr_di_in(7 downto 1);
                    end if;
                else
                    rdr_reg <= rdr_reg;
                end if;
            end if;
        end if;
    end process;

    uartrdr_do_out <= rdr_reg;

end rtl;
