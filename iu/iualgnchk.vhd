library ieee;
use ieee.std_logic_1164.all;

use work.iuldst_pac.all;

entity iualgnchk is
    port (
        iualgnchk_cs_in   : in    std_logic;
        iualgnchk_type_in : in    std_logic_vector(1 downto 0);
        iualgnchk_addr_in : in    std_logic_vector(1 downto 0);
        iualgnchk_do_out  :   out std_logic
    );
end iualgnchk;

architecture rtl of iualgnchk is

    signal type_sig : std_logic_vector(1 downto 0);
    signal addr_sig : std_logic_vector(1 downto 0);
    signal half_sig : std_logic;
    signal word_sig : std_logic;

begin

    type_sig <= iualgnchk_type_in and ( 1 downto 0 => iualgnchk_cs_in);
    addr_sig <= iualgnchk_addr_in and ( 1 downto 0 => iualgnchk_cs_in);

    half_sig <= '1' when ((type_sig     = IULDST_MEM_TYPE_HALF)
                      and (addr_sig(0) /= '0'                 )) else
                '0';

    word_sig <= '1' when ((type_sig     = IULDST_MEM_TYPE_WORD)
                      and (addr_sig    /= "00"                )) else
                '0';

    iualgnchk_do_out <= half_sig
                     or word_sig;

end rtl;
