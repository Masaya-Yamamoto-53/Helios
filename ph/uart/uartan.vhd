library ieee;
use ieee.std_logic_1164.all;

use work.uart_pac.all;

entity uartan is
    port (
        uartan_clk_in  : in    std_logic;
        uartan_rst_in  : in    std_logic;
        uartan_sdi_in  : in    std_logic;
        uartan_sdi_out :   out std_logic
    );
end uartan;

architecture rtl of uartan is

    signal a_reg   : std_logic;
    signal b_reg   : std_logic;
    signal c_reg   : std_logic;

begin

    UART_Anti_Noize : process (
        uartan_clk_in,
        uartan_rst_in,
        uartan_sdi_in
    ) begin
        if (uartan_clk_in'event and uartan_clk_in = '1') then
            if (uartan_rst_in = '1') then
                -- Clear the register to the value of the stop bit
                a_reg <= UART_STOP_BIT;
                b_reg <= UART_STOP_BIT;
                c_reg <= UART_STOP_BIT;
            else
                a_reg <= uartan_sdi_in;
                b_reg <= a_reg;
                c_reg <= b_reg;
            end if;
        end if;
    end process;

    --   |a|b|c|
    -- |a|\ O O
    -- |b|- \ O
    -- |c|- - \
    uartan_sdi_out <= ((a_reg and b_reg)
                    or (a_reg and c_reg)
                    or (b_reg and c_reg));

end rtl;
