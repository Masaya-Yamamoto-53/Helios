library ieee;
use ieee.std_logic_1164.all;

package iuimem_pac is

    component iuimem
        port (
            iuimem_addr_in : in    std_logic_vector ( 8 downto 0);
            iuimem_do_out  :   out std_logic_vector (31 downto 0)
        );
    end component;

end iuimem_pac;

-- package body iuimem_pac is
-- end iuimem_pac;
