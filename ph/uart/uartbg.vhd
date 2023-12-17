library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uartbg is
    port (
        uartbg_en_in   : in    std_logic;
        uartbg_clk_in  : in    std_logic;
        uartbg_rst_in  : in    std_logic;
        uartbg_scbr_in : in    std_logic_vector(7 downto 0);
        uartbg_clk_out :   out std_logic
    );
end uartbg;

architecture rtl of uartbg is

    signal clkgn_cnt_reg : std_logic_vector(7 downto 0);
    signal clkgn_reg     : std_logic;

    signal bclk_reg       : std_logic;

begin

    UART_Baud_Rate_Generator : process (
        uartbg_en_in,
        uartbg_clk_in,
        uartbg_rst_in,
        uartbg_scbr_in
    ) begin
        if (uartbg_clk_in'event and uartbg_clk_in = '1') then
            if ((uartbg_rst_in = '1')
             or (uartbg_en_in  = '0')) then
                clkgn_cnt_reg <= (others => '0');
                clkgn_reg     <= '0';
            else
                if (clkgn_cnt_reg = uartbg_scbr_in) then
                    clkgn_cnt_reg <= (others => '0');
                    clkgn_reg     <= not clkgn_reg;
                else
                    clkgn_cnt_reg <= std_logic_vector(unsigned(clkgn_cnt_reg) + 1);
                    clkgn_reg     <=     clkgn_reg;
                end if;
            end if;
        end if;
    end process;

    UART_Base_Clock_Generator : process (
        uartbg_clk_in,
        uartbg_rst_in,
        clkgn_reg,
        bclk_reg
    )
    begin
        if (uartbg_clk_in'event and uartbg_clk_in = '1') then
            if    (uartbg_rst_in = '1') then
                bclk_reg <= '0';
            else
                bclk_reg <= clkgn_reg;
            end if;
        end if;
    end process;

    uartbg_clk_out <= '1' when bclk_reg = '0' and clkgn_reg = '1' else
                      '0';

end rtl;
