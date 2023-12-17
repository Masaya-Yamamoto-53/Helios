library ieee;
use ieee.std_logic_1164.all;

package intc_pac is

    -- Type of interrupt for each input
    -- 0: level, 1: Edge
    constant C_KIND_OF_INTR : std_logic_vector(15 downto 0) := "0000000000000000";

    component intc
        port (
            intc_clk_in  : in    std_logic;
            intc_rst_in  : in    std_logic;
            intc_inta_in : in    std_logic;
            intc_irq_in  : in    std_logic_vector(15 downto 0);
            intc_int_out :   out std_logic;
            intc_irl_out :   out std_logic_vector( 3 downto 0);

            intc_cs_in   : in    std_logic;
            intc_we_in   : in    std_logic;
            intc_addr_in : in    std_logic_vector( 1 downto 0);
            intc_di_in   : in    std_logic_vector(15 downto 0);
            intc_do_out  :   out std_logic_vector(15 downto 0)
        );
    end component;

end intc_pac;

-- package body intc_pac is
-- end intc_pac;
