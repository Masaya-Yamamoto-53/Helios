library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iuctrl_pac.all;
use work.iucall_pac.all;

entity iucall is
    port (
        iucall_op_in     : in    std_logic_vector( 1 downto 0);
        iucall_addr_in   : in    std_logic_vector(29 downto 0);
        iucall_token_out :   out std_logic;
        iucall_addr_out  :   out std_logic_vector(29 downto 0)
    );
end iucall;

architecture rtl of iucall is

    signal cs_sig : std_logic;

begin

    cs_sig <= '1' when iucall_op_in = IUCTRL_OP_CALL else
              '0';

    iucall_token_out <= cs_sig;
    iucall_addr_out  <= iucall_addr_in and (29 downto 0 => cs_sig);

end rtl;
