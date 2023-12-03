library ieee;
use ieee.std_logic_1164.all;

package iustdqm_pac is

    component iustdqm
        port (
            iustdqm_write_in : in    std_logic;
            iustdqm_type_in  : in    std_logic_vector( 1 downto 0);
            iustdqm_addr_in  : in    std_logic_vector( 1 downto 0);
            iustdqm_dqm_out  :   out std_logic_vector( 3 downto 0)
        );
    end component;

end iustdqm_pac;

-- package body iustdqm_pac is
-- end iustdqm_pac;
