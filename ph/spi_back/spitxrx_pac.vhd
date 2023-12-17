library ieee;
use ieee.std_logic_1164.all;

package spitxrx_pac is

    component spitxrx
        port (
            spitxrx_cs_in     : in    std_logic;
            spitxrx_clk_in    : in    std_logic;
            spitxrx_rst_in    : in    std_logic;

            spitxrx_we_in     : in    std_logic;
            spitxrx_addr_in   : in    std_logic_vector (3 downto 0);
            spitxrx_di_in     : in    std_logic_vector (7 downto 0);

            spitxrx_bclk_in   : in    std_logic;
            spitxrx_ckp_in    : in    std_logic;
            spitxrx_cke_in    : in    std_logic;

            spitxrx_start_out :   out std_logic;

            spitxrx_tend_out  :   out std_logic;
            spitxrx_tei_out   :   out std_logic;

            spitxrx_sctd_out  :   out std_logic_vector (7 downto 0);
            spitxrx_scrd_out  :   out std_logic_vector (7 downto 0);
            spitxrx_rdrf_out  :   out std_logic;

            spitxrx_csn_out   :   out std_logic;
            spitxrx_clk_out   :   out std_logic;
            spitxrx_sdi_in    : in    std_logic;
            spitxrx_sdo_out   :   out std_logic
        );
    end component;

end spitxrx_pac;

-- package body spitxrx_pac is
-- end spitxrx_pac;
