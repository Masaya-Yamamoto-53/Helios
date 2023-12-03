library ieee;
use ieee.std_logic_1164.all;

use work.iuctrl_pac.all;

package iufmt3dec_pac is

    component iufmt3dec
        port (
            iufmt3dec_cs_in       : in    std_logic;
            iufmt3dec_op3_in      : in    std_logic_vector( 5 downto 0);
            iufmt3dec_rd_sel_in   : in    std_logic_vector( 4 downto 0);
            iufmt3dec_rs1_sel_in  : in    std_logic_vector( 4 downto 0);
            iufmt3dec_rs2_sel_in  : in    std_logic_vector( 4 downto 0);
            iufmt3dec_imm_sel_in  : in    std_logic;
            iufmt3dec_imm_data_in : in    std_logic_vector(12 downto 0);
            iufmt3dec_do_out      :   out st_iuctrl_if
        );
    end component;

end iufmt3dec_pac;

-- package body iufmt3dec_pac is
-- end iufmt3dec_pac;
