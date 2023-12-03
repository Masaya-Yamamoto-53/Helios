library ieee;
use ieee.std_logic_1164.all;

use work.iuctrl_pac.all;

package iufmt0dec_pac is

    component iufmt0dec
        port (
            iufmt0dec_cs_in      : in    std_logic;
            iufmt0dec_op2_in     : in    std_logic_vector( 1 downto 0);
            iufmt0dec_rs3_sel_in : in    std_logic_vector( 4 downto 0);
            iufmt0dec_cond_in    : in    std_logic_vector( 2 downto 0);
            iufmt0dec_token_in   : in    std_logic;
            iufmt0dec_sethi_in   : in    std_logic_vector(22 downto 0);
            iufmt0dec_disp19_in  : in    std_logic_vector(18 downto 0);
            iufmt0dec_do_out     :   out st_iuctrl_if
        );
    end component;

end iufmt0dec_pac;

-- package body iufmt0dec_pac is
-- end iufmt0dec_pac;
