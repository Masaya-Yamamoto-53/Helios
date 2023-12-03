library ieee;
use ieee.std_logic_1164.all;

use work.iuctrl_pac.all;

package iuintrdec_pac is

    component iuintrdec
        port (
            iuintrdec_cs_in  : in    std_logic;
            iuintrdec_di_in  : in    std_logic_vector(8 downto 0);
            iuintrdec_do_out :   out st_iuctrl_if
        );
    end component;

end iuintrdec_pac;

-- package body iuintrdec_pac is
-- end iuintrdec_pac;
