library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uartcks is
    port (
        uartcks_en_in   : in    std_logic;
        uartcks_clk_in  : in    std_logic;
        uartcks_rst_in  : in    std_logic;
        uartcks_cks_in  : in    std_logic_vector(1 downto 0);
        uartcks_clk_out :   out std_logic
    );
end uartcks;

architecture rtl of uartcks is

    signal clk_reg : std_logic_vector(5 downto 0) := (others => '0');

begin

    UART_Clock_Selector : process (
        uartcks_en_in,
        uartcks_clk_in,
        uartcks_rst_in
    )
    begin
        if (uartcks_clk_in'event and uartcks_clk_in = '1') then
            if ((uartcks_rst_in = '1')
             or (uartcks_en_in  = '0')) then
                clk_reg <= (others => '0');
            else
                clk_reg <= std_logic_vector(unsigned(clk_reg) + 1);
            end if;
        end if;
    end process;

    uartcks_clk_out <= uartcks_clk_in when uartcks_cks_in = "00" else -- PΦ
                       clk_reg(1)     when uartcks_cks_in = "01" else -- PΦ/4
                       clk_reg(3)     when uartcks_cks_in = "10" else -- PΦ/16
                       clk_reg(5);                                    -- PΦ/64

end rtl;
