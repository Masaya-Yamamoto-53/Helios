library ieee;
use ieee.std_logic_1164.all;

package iupil_pac is

    component iupil
        port (
            iupil_clk_in : in    std_logic;
            iupil_rst_in : in    std_logic;
            iupil_we_in  : in    std_logic;
            iupil_di_in  : in    std_logic_vector(3 downto 0);
            iupil_do_out :   out std_logic_vector(3 downto 0)
        );
    end component;

end iupil_pac;

-- package body iupil_pac is
-- end iupil_pac;
