library ieee;
use ieee.std_logic_1164.all;

package gpi_pac is

    component gpi
        generic (
            WIDTH : integer := 1
        );
        port (
            gpi_clk_in : in    std_logic;
            gpi_rst_in : in    std_logic;
            gpi_di_in  : in    std_logic_vector(WIDTH-1 downto 0);
            gpi_do_out :   out std_logic_vector(WIDTH-1 downto 0)
        );
    end component;

end gpi_pac;

-- package body gpi_pac is
-- end gpi_pac;
