--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Execute Stage
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.iufwu_pac.all;

package iuexstg_pac is

    component iuexstg
        port (
            iuexstg_rs1_fw_in        : in std_logic_vector( 3 downto 0);
            iuexstg_rs1_di_in        : in std_logic_vector(31 downto 0);

            iuexstg_rs2_fw_in        : in std_logic_vector( 3 downto 0);
            iuexstg_rs2_di_in        : in std_logic_vector(31 downto 0);

            iuexstg_rs3_fw_in        : in std_logic_vector( 3 downto 0);
            iuexstg_rs3_di_in        : in std_logic_vector(31 downto 0);

            iuexstg_ma_rd_in         : st_iufwpast_if;
            iuexstg_wb_rd_in         : st_iufwpast_if;

            iuexstg_alu_cs_in        : in    std_logic;
            iuexstg_sft_cs_in        : in    std_logic;
            iuexstg_cmp_cs_in        : in    std_logic;
            iuexstg_cond_cs_in       : in    std_logic;
            iuexstg_cond_di_in       : in    std_logic_vector( 2 downto 0);
            iuexstg_opecode_in       : in    std_logic_vector( 2 downto 0);

            iuexstg_token_in         : in    std_logic;
            iuexstg_branch_in        : in    std_logic;

            iuexstg_intr_algnchk_out :   out std_logic;

            iuexstg_branch_we_out    :   out std_logic;
            iuexstg_branch_addr_out  :   out std_logic_vector(29 downto 0);

            iuexstg_rs1_data_out     :   out std_logic_vector(31 downto 0);
            iuexstg_rs2_data_out     :   out std_logic_vector(31 downto 0);
            iuexstg_rs3_data_out     :   out std_logic_vector(31 downto 0);

            iuexstg_do_out           :   out std_logic_vector(31 downto 0)
        );
    end component;

end iuexstg_pac;

-- package body iuexstg_pac is
-- end iuexstg_pac;
