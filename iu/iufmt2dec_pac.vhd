--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Format 2 Decoder
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.iuctrl_pac.all;

package iufmt2dec_pac is

    component iufmt2dec
        port (
            iufmt2dec_cs_in       : in    std_logic;
            iufmt2dec_op3_in      : in    std_logic_vector( 5 downto 0);
            iufmt2dec_rd_sel_in   : in    std_logic_vector( 4 downto 0);
            iufmt2dec_rs1_sel_in  : in    std_logic_vector( 4 downto 0);
            iufmt2dec_rs2_sel_in  : in    std_logic_vector( 4 downto 0);
            iufmt2dec_imm_sel_in  : in    std_logic;
            iufmt2dec_imm_data_in : in    std_logic_vector(12 downto 0);
            iufmt2dec_do_out      :   out st_iuctrl_if
        );
    end component;

end iufmt2dec_pac;

-- package body iufmt2dec_pac is
-- end iufmt2dec_pac;
