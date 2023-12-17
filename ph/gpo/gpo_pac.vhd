library ieee;
use ieee.std_logic_1164.all;

package gpo_pac is

    component gpo
        generic (
            WIDTH : integer := 1
        );
        port (
            gpo_cs_in  : in    std_logic;
            gpo_clk_in : in    std_logic;
            gpo_rst_in : in    std_logic;
            gpo_we_in  : in    std_logic;
            gpo_di_in  : in    std_logic_vector(WIDTH-1 downto 0);
            gpo_do_out :   out std_logic_vector(WIDTH-1 downto 0)
        );
    end component;

end gpo_pac;

-- package body gpo_pac is
-- end gpo_pac;
