library ieee;
use ieee.std_logic_1164.all;

use work.spicks_pac.all;
use work.spibg_pac.all;
use work.spitxrx_pac.all;

use work.spi_pac.all;

entity spi is
    port (
        spi_cs_in   : in    std_logic;
        spi_clk_in  : in    std_logic;
        spi_rst_in  : in    std_logic;

        spi_we_in   : in    std_logic;
        spi_addr_in : in    std_logic_vector( 3 downto 0);
        spi_di_in   : in    std_logic_vector( 7 downto 0);
        spi_do_out  :   out std_logic_vector( 7 downto 0);

        spi_ti_out  :   out std_logic;
        spi_rxi_out :   out std_logic;
        spi_tei_out :   out std_logic;

        spi_csn_out :   out std_logic;
        spi_clk_out :   out std_logic;
        spi_sdi_in  : in    std_logic;
        spi_sdo_out :   out std_logic
    );
end spi;

architecture rtl of spi is

    signal start_sig : std_logic;
    signal spicks_clk_sig  : std_logic;
    signal spibg_clk_sig : std_logic;

    signal cks_reg : std_logic_vector(1 downto 0) := "00";
    signal scbr_sig : std_logic_vector(7 downto 0) := (others => '0');

begin

    SPI_Clock_Selector : spicks
    port map (
        spicks_en_in   => start_sig,
        spicks_clk_in  => spi_clk_in,
        spicks_bclk_in => spibg_clk_sig,
        spicks_rst_in  => spi_rst_in,
        spicks_cks_in  => cks_reg,
        spicks_clk_out => spicks_clk_sig
    );

    SPI_Baud_Rate_Generator : spibg
    port map (
        spibg_en_in   => start_sig,
        spibg_clk_in  => spicks_clk_sig,
        spibg_rst_in  => spi_rst_in,
        spibg_scbr_in => scbr_sig,
        spibg_clk_out => spibg_clk_sig
    );

    SPI_Transmitter_and_Reveiver : spitxrx
    port map (
        spitxrx_cs_in     => spi_cs_in,
        spitxrx_clk_in    => spi_clk_in,
        spitxrx_rst_in    => spi_rst_in,

        spitxrx_we_in     => spi_we_in,
        spitxrx_addr_in   => spi_addr_in,
        spitxrx_di_in     => spi_di_in,

        spitxrx_bclk_in   => spibg_clk_sig,
        spitxrx_ckp_in    => '0', --ckp_reg,
        spitxrx_cke_in    => '0', --cke_reg,

        spitxrx_start_out => start_sig,

        spitxrx_tend_out  => open, --spitx_tend_sig,
        spitxrx_tei_out   => open, --spitx_tei_sig,

        spitxrx_sctd_out  => open, --sctd_sig,
        spitxrx_scrd_out  => open, --scrd_sig,
        spitxrx_rdrf_out  => open, --spirx_rdrf_sig,

        spitxrx_csn_out   => spi_csn_out,
        spitxrx_clk_out   => spi_clk_out,
        spitxrx_sdi_in    => spi_sdi_in,
        spitxrx_sdo_out   => spi_sdo_out
    );

end rtl;
