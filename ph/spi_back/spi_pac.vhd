library ieee;
use ieee.std_logic_1164.all;

package spi_pac is

    constant SPI_ADDR_SCSM : std_logic_vector(3 downto 0) := "0000";
    constant SPI_ADDR_SCBR : std_logic_vector(3 downto 0) := "0001";
    constant SPI_ADDR_SCSC : std_logic_vector(3 downto 0) := "0010";
    constant SPI_ADDR_SCTD : std_logic_vector(3 downto 0) := "0011";
    constant SPI_ADDR_SCSS : std_logic_vector(3 downto 0) := "0100";
    constant SPI_ADDR_SCRD : std_logic_vector(3 downto 0) := "0101";

    component spi
        port (
            spi_cs_in   : in    std_logic;                     -- Chip Select
            spi_clk_in  : in    std_logic;                     -- Base Clock
            spi_rst_in  : in    std_logic;                     -- Reset

            spi_we_in   : in    std_logic;                     -- Register Write Enable
            spi_addr_in : in    std_logic_vector( 3 downto 0); -- Register Address
            spi_di_in   : in    std_logic_vector( 7 downto 0); -- Register Data Input
            spi_do_out  :   out std_logic_vector( 7 downto 0); -- Register Data Output

            spi_ti_out  :   out std_logic;                     -- Transmit Data Empty Interrupt
            spi_rxi_out :   out std_logic;                     -- Receive Data Full Interrupt
            spi_tei_out :   out std_logic;                     -- Transmit End Interrupt

            spi_csn_out :   out std_logic;
            spi_clk_out :   out std_logic;
            spi_sdi_in  : in    std_logic;                     -- Serial Data Input
            spi_sdo_out :   out std_logic                      -- Serial Data Output

        );
    end component;

end spi_pac;

-- package body spi_pac is
-- end spi_pac;
