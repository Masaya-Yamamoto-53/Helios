library ieee;
use ieee.std_logic_1164.all;

package sunburst_pac is

    component sunburst
        port (
            h_sys_clk_in       : in    std_logic;
            --h_sys_rst_in       : in    std_logic;

            h_sys_led_out      :   out std_logic_vector( 1 downto 0);

            h_sys_sw_in        : in    std_logic_vector( 1 downto 0);

            h_sys_r_led_out    :   out std_logic;
            h_sys_g_led_out    :   out std_logic;
            h_sys_b_led_out    :   out std_logic;

            h_sys_uart_sdi_in  : in    std_logic;
            h_sys_uart_sdo_out :   out std_logic

            --h_sys_spi_csn_out  :   out std_logic;
            --h_sys_spi_clk_out  :   out std_logic;
            --h_sys_spi_sdi_in   : in    std_logic;
            --h_sys_spi_sdo_out  :   out std_logic
        );
    end component;

end sunburst_pac;

-- package body sunburst_pac is
-- end sunburst_pac;
