library ieee;
use ieee.std_logic_1164.all;

package iurett_pac is

    component iurett
        port (
            iurett_op_in  : in    std_logic_vector(1 downto 0);
            iurett_op3_in : in    std_logic_vector(5 downto 0);
            iurett_en_out :   out std_logic
        );
    end component;

end iurett_pac;

-- package body iurett_pac is
-- end iurett_pac;
