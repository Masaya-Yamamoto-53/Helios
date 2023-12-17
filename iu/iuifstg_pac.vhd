--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Instruction Fetch Stage
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.iuifid_pac.all;

package iuifstg_pac is

    component iuifstg
        port (
            iuifstg_intr_req_in  : in    std_logic;
            iuifstg_intr_inst_in : in    std_logic_vector(31 downto 0);
            iuifstg_norm_inst_in : in    std_logic_vector(31 downto 0);
            iuifstg_pc_in        : in    std_logic_vector(29 downto 0);
            iuifstg_token_out    :   out std_logic;
            iuifstg_addr_out     :   out std_logic_vector(29 downto 0);
            iuifstg_rett_out     :   out std_logic;
            iuifstg_do_out       :   out st_iuifid_if
        );
    end component;

end iuifstg_pac;

-- package body iuifstg_pac is
-- end iuifstg_pac;
