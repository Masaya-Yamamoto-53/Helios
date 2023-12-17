library ieee;
use ieee.std_logic_1164.all;

package uarttx_pac is

    component uarttx
        port (
            uarttx_cs_in    : in    std_logic;
            uarttx_te_in    : in    std_logic;
            uarttx_clk_in   : in    std_logic;
            uarttx_rst_in   : in    std_logic;
            uarttx_we_in    : in    std_logic;
            uarttx_addr_in  : in    std_logic_vector(3 downto 0);
            uarttx_di_in    : in    std_logic_vector(7 downto 0);
            uarttx_bclk_in  : in    std_logic;
            uarttx_chr_in   : in    std_logic;
            uarttx_pe_in    : in    std_logic;
            uarttx_pm_in    : in    std_logic;
            uarttx_stop_in  : in    std_logic;
            uarttx_tdr_in   : in    std_logic_vector(7 downto 0);
            uarttx_tend_out :   out std_logic;
            uarttx_tei_out  :   out std_logic;
            uarttx_sdo_out  :   out std_logic
        );
    end component;

end uarttx_pac;

-- package body uarttx_pac is
-- end uarttx_pac;
