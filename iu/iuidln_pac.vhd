--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Instruction Decode
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.iu_pac.all;
use work.iuifid_pac.all;
use work.iuidex_pac.all;
use work.iumawb_pac.all;
use work.iufwu_pac.all;

package iuidln_pac is

    component iuidln
        port (
            iuidln_clk_in       : in    std_logic;
            iuidln_rst_in       : in    std_logic;
            iuidln_wen_in       : in    std_logic;
            iuidln_flash_in     : in    std_logic;
            iuidln_if_di_in     : in    st_iuifid_if;
            iuidln_wb_di_in     : in    st_iumawb_if;
            iuidln_ma_rd_in     : in    st_iufwpre_if;
            iuidln_data_hzd_out :   out std_logic;
            iuidln_intr_dis_out :   out std_logic;
            iuidln_do_out       :   out st_iuidex_if
        );
    end component;

end iuidln_pac;

-- package body iuidln_pac is
-- end iuidln_pac;
