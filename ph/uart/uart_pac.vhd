library ieee;
use ieee.std_logic_1164.all;

package uart_pac is
    constant UART_START_BIT : std_logic := '0';
    constant UART_STOP_BIT  : std_logic := '1';

    constant UART_ADDR_SMR : std_logic_vector(3 downto 0) := "0000"; -- Serial Mode Register    : Base address +  0
    constant UART_ADDR_BRR : std_logic_vector(3 downto 0) := "0001"; -- Bit Rate Register       : Base address +  4
    constant UART_ADDR_SCR : std_logic_vector(3 downto 0) := "0010"; -- Serial Control Register : Base address +  8
    constant UART_ADDR_TDR : std_logic_vector(3 downto 0) := "0011"; -- Transmit Data Register  : Base address + 12
    constant UART_ADDR_SSR : std_logic_vector(3 downto 0) := "0100"; -- Serial Status Register  : Base address + 16
    constant UART_ADDR_RDR : std_logic_vector(3 downto 0) := "0101"; -- Receive Data Register   : Base address + 20

    component uart
        port (
            uart_cs_in   : in    std_logic;                     -- Chip Select
            uart_clk_in  : in    std_logic;                     -- Base Clock
            uart_rst_in  : in    std_logic;                     -- Reset
            uart_sdi_in  : in    std_logic;                     -- Serial Data Input
            uart_sdo_out :   out std_logic;                     -- Serial Data Output

            uart_we_in   : in    std_logic;                     -- Register Write Enable
            uart_addr_in : in    std_logic_vector( 3 downto 0); -- Register Address
            uart_di_in   : in    std_logic_vector( 7 downto 0); -- Register Data Input
            uart_do_out  :   out std_logic_vector( 7 downto 0); -- Register Data Output

            uart_ti_out  :   out std_logic;                     -- Transmit Data Empty Interrupt
            uart_rxi_out :   out std_logic;                     -- Receive Data Full Interrupt
            uart_eri_out :   out std_logic;                     -- Receive Error Interrupt
            uart_tei_out :   out std_logic                      -- Transmit End Interrupt
        );
    end component;

end uart_pac;

-- package body uart_pac is
-- end uart_pac;
