library ieee;
use ieee.std_logic_1164.all;

package rgbled_pac is

    constant RGBLED_ADDR_STR   : std_logic_vector(1 downto 0) := "00"; -- Start Register      : Base address +  0
    constant RGBLED_ADDR_RDATA : std_logic_vector(1 downto 0) := "01"; -- Red Data Register   : Base address +  4
    constant RGBLED_ADDR_GDATA : std_logic_vector(1 downto 0) := "10"; -- Green Data Register : Base address +  8
    constant RGBLED_ADDR_BDATA : std_logic_vector(1 downto 0) := "10"; -- Blue Data Register  : Base address + 16

    component rgbled
        generic (
            C_GEN_PW_EXP : integer := 8
        );
        port (
            rgbled_cs_in     : in    std_logic;
            rgbled_clk_in    : in    std_logic;
            rgbled_rst_in    : in    std_logic;

            rgbled_we_in     : in    std_logic;
            rgbled_addr_in   : in    std_logic_vector(1 downto 0);
            rgbled_di_in     : in    std_logic_vector(C_GEN_PW_EXP-1 downto 0);
            rgbled_do_out    :   out std_logic_vector(C_GEN_PW_EXP-1 downto 0);

            rgbled_r_out     :   out std_logic;
            rgbled_g_out     :   out std_logic;
            rgbled_b_out     :   out std_logic
        );
    end component;

end rgbled_pac;

-- package body rgbled_pac is
-- end rgbled_pac;
