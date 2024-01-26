--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Fowarding Past
-- Description:
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iu_pac.all;
use work.iufwu_pac.all;

entity iufwpast is
    port (
        iufwpast_fw_in      : in    std_logic_vector( 1 downto 0);
        iufwpast_ex_data_in : in    std_logic_vector(31 downto 0);
        iufwpast_ma_rd_in   : in    st_iufwpast_if;
        iufwpast_wb_rd_in   : in    st_iufwpast_if;
        iufwpast_data_out   :   out std_logic_vector(31 downto 0)
    );
end iufwpast;

architecture rtl of iufwpast is

begin

    iufwpast_data_out <= iufwpast_ma_rd_in.data when ((iufwpast_fw_in(IUFWU_EX) = '1')
                                                  and (iufwpast_ma_rd_in.we     = '1')) else
                         iufwpast_wb_rd_in.data when ((iufwpast_fw_in(IUFWU_MA) = '1')
                                                  and (iufwpast_wb_rd_in.we     = '1')) else
                         iufwpast_ex_data_in;

end rtl;
