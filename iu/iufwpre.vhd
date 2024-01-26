--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Fowarding Pre Unit
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iu_pac.all;
use work.iufwu_pac.all;

entity iufwpre is
    port (
        iufwpre_sel_in   : in    std_logic_vector( 4 downto 0);
        iufwpre_ex_rd_in : in    st_iufwpre_if;
        iufwpre_ma_rd_in : in    st_iufwpre_if;
        iufwpre_fw_out   :   out std_logic_vector( 1 downto 0)
    );
end iufwpre;

architecture rtl of iufwpre is

begin

    iufwpre_fw_out(IUFWU_EX) <= '1' when ((iufwpre_ex_rd_in.we  = '1'           )
                                      and (iufwpre_ex_rd_in.sel = iufwpre_sel_in)) else
                                '0';

    iufwpre_fw_out(IUFWU_MA) <= '1' when ((iufwpre_ma_rd_in.we  = '1'           )
                                      and (iufwpre_ma_rd_in.sel = iufwpre_sel_in)) else
                                '0';

end rtl;
