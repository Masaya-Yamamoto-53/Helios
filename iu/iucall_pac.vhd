--------------------------------------------------------------------------------
-- Design Name: IU CALL Instruction Address Generator
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package iucall_pac is

    component iucall
        port (
            iucall_op_in     : in    std_logic_vector( 1 downto 0);
            iucall_addr_in   : in    std_logic_vector(29 downto 0);
            iucall_token_out :   out std_logic;
            iucall_addr_out  :   out std_logic_vector(29 downto 0)
        );
    end component;

end iucall_pac;

-- package body iucall_pac is
-- end iucall_pac;
