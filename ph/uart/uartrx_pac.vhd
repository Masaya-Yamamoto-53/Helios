library ieee;
use ieee.std_logic_1164.all;

package uartrx_pac is

    component uartrx
        port (
            uartrx_re_in      : in    std_logic;
            uartrx_clk_in     : in    std_logic;
            uartrx_rst_in     : in    std_logic;
            uartrx_dis_in     : in    std_logic;
            uartrx_bclk_in    : in    std_logic;
            uartrx_chr_in     : in    std_logic;
            uartrx_pe_in      : in    std_logic;
            uartrx_pm_in      : in    std_logic;
            uartrx_stop_in    : in    std_logic;
            uartrx_sdi_in     : in    std_logic;
            uartrx_orer_out   :   out std_logic;
            uartrx_fer_out    :   out std_logic;
            uartrx_per_out    :   out std_logic;
            uartrx_rdrf_in    : in    std_logic;
            uartrx_rdrf_out   :   out std_logic;
            uartrx_rx_end_out :   out std_logic;
            uartrx_rsr_out    :   out std_logic_vector( 7 downto 0)
        );
    end component;

end uartrx_pac;

-- package body uartrx_pac is
-- end uartrx_pac;
