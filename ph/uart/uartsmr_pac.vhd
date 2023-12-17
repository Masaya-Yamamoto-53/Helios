library ieee;
use ieee.std_logic_1164.all;

package uartsmr_pac is

    type st_uartsmr_if is
    record
        chr_reg   : std_logic;                    -- bit6  : Character Length
        pe_reg    : std_logic;                    -- bit5  : Parity Enable
        pm_reg    : std_logic;                    -- bit4  : Parity Mode
        stop_reg  : std_logic;                    -- bit3  : Stop Bit
        cks_reg   : std_logic_vector(1 downto 0); -- bit1,0: Clock Select
    end record;
    constant st_uartsmr_if_INIT : st_uartsmr_if :=(
        '0',            -- chr_reg
        '0',            -- pe_reg
        '0',            -- pm_reg
        '0',            -- stop_reg
        (others => '0') -- cks_reg
    );

    component uartsmr
        port (
            uartsmr_cs_in   : in    std_logic;
            uartsmr_clk_in  : in    std_logic;
            uartsmr_rst_in  : in    std_logic;

            uartsmr_we_in   : in    std_logic;
            uartsmr_addr_in : in    std_logic_vector( 3 downto 0);
            uartsmr_di_in   : in    std_logic_vector( 7 downto 0);
            uartsmr_do_out  :   out st_uartsmr_if
        );
    end component;

end uartsmr_pac;

-- package body uartsmr_pac is
-- end uartsmr_pac;
