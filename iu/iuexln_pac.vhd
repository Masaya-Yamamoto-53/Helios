--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Execute Unit
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.iu_pac.all;
use work.iuidex_pac.all;
use work.iuexma_pac.all;
use work.iufwu_pac.all;
use work.iumul32_pac.all;

package iuexln_pac is

    component iuexln
        port (
            iuexln_clk_in           : in    std_logic;
            iuexln_rst_in           : in    std_logic;
            iuexln_wen_in           : in    std_logic;
            iuexln_flash_in         : in    std_logic;
            iuexln_di_in            : in    st_iuidex_if;
            iuexln_wb_rd_in         : in    st_iufwpast_if;
            iuexln_branch_we_out    :   out std_logic;
            iuexln_branch_addr_out  :   out std_logic_vector(29 downto 0);
            iuexln_intr_dis_out     :   out std_logic;
            iuexln_intr_unimp_out   :   out std_logic;
            iuexln_intr_algnchk_out :   out std_logic;
            iuexln_excep_we_out     :   out std_logic;
            iuexln_excep_addr_out   :   out std_logic_vector(29 downto 0);
            iuexln_do_out           :   out st_iuexma_if;
            iuexln_mul_out          :   out st_iumul32_if
        );
    end component;

end iuexln_pac;

-- package body iuexln_pac is
-- end iuexln_pac;
