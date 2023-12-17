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
use ieee.numeric_std.all;

use work.iu_pac.all;
use work.iufwu_pac.all;
use work.iualu_pac.all;
use work.iusft_pac.all;
use work.iucmp_pac.all;
use work.iucond_pac.all;

use work.iuidex_pac.all;
use work.iuexma_pac.all;

use work.iuexstg_pac.all;

entity iuexstg is
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
end iuexstg;

architecture rtl of iuexstg is

    -- IU Forwarding Unit I/F
    signal iufwpastu_rs1_sig : std_logic_vector(31 downto 0);
    signal iufwpastu_rs2_sig : std_logic_vector(31 downto 0);
    signal iufwpastu_rs3_sig : std_logic_vector(31 downto 0);

    -- Arithmetic Logic Unit I/F
    signal iualu_do_sig  : std_logic_vector(31 downto 0);

    -- Shifter Unit I/F
    signal iusft_do_sig  : std_logic_vector(31 downto 0);

    -- Compare Unit I/F
    signal iucmp_do_sig  : std_logic;

    -- Condition Code Execution I/F
    signal iucond_do_sig : std_logic;

    signal algnchk_sig   : std_logic;
    signal branch_sig    : std_logic;

begin
    -----------------------------------------------------------
    -- IU Forwarding Unit (Past)                             --
    -----------------------------------------------------------
    IU_Forwarding_Unit : iufwpastu
    port map (
        iufwpastu_rs1_fw_in  => iuexstg_rs1_fw_in,
        iufwpastu_rs1_di_in  => iuexstg_rs1_di_in,

        iufwpastu_rs2_fw_in  => iuexstg_rs2_fw_in,
        iufwpastu_rs2_di_in  => iuexstg_rs2_di_in,

        iufwpastu_rs3_fw_in  => iuexstg_rs3_fw_in,
        iufwpastu_rs3_di_in  => iuexstg_rs3_di_in,

        iufwpastu_ma_rd_in   => iuexstg_ma_rd_in,
        iufwpastu_wb_rd_in   => iuexstg_wb_rd_in,

        iufwpastu_rs1_do_out => iufwpastu_rs1_sig,
        iufwpastu_rs2_do_out => iufwpastu_rs2_sig,
        iufwpastu_rs3_do_out => iufwpastu_rs3_sig
    );

    -----------------------------------------------------------
    -- Arithmetic Logic Unit                                 --
    -----------------------------------------------------------
    IU_Arithmetic_Logic_Unit : iualu
    port map (
        iualu_cs_in   => iuexstg_alu_cs_in,
        iualu_op_in   => iuexstg_opecode_in,
        iualu_di1_in  => iufwpastu_rs1_sig,
        iualu_di2_in  => iufwpastu_rs2_sig,
        iualu_do_out  => iualu_do_sig
    );

    -----------------------------------------------------------
    -- Shifter Unit                                          --
    -----------------------------------------------------------
    IU_Shifter_Unit : iusft
    port map (
        iusft_cs_in    => iuexstg_sft_cs_in,
        iusft_op_in    => iuexstg_opecode_in,
        iusft_di_in    => iufwpastu_rs1_sig,
        iusft_shcnt_in => iufwpastu_rs2_sig(4 downto 0),
        iusft_do_out   => iusft_do_sig
    );

    -----------------------------------------------------------
    -- Compare Unit                                          --
    -----------------------------------------------------------
    IU_Compare_Unit : iucmp
    port map (
        iucmp_cs_in  => iuexstg_cmp_cs_in,
        iucmp_op_in  => iuexstg_opecode_in,
        iucmp_di1_in => iufwpastu_rs1_sig,
        iucmp_di2_in => iufwpastu_rs2_sig,
        iucmp_do_out => iucmp_do_sig
    );

    -----------------------------------------------------------
    -- Condition Code Execution                              --
    -----------------------------------------------------------
    IU_Condition_Code_Unit : iucond
    port map (
        iucond_cs_in   => iuexstg_cond_cs_in,
        iucond_cond_in => iuexstg_cond_di_in,
        iucond_di_in   => iufwpastu_rs3_sig,
        iucond_do_out  => iucond_do_sig
    );

    -- to instruction fetch stage
    algnchk_sig <= '1' when ((iualu_do_sig( 1 downto 0) /= "00")
                         and (iuexstg_branch_in          = '1' )) else
                   '0';

    iuexstg_intr_algnchk_out <= algnchk_sig;

    branch_sig <= (iucond_do_sig xor iuexstg_token_in) and (not algnchk_sig);

    iuexstg_branch_we_out   <= iuexstg_branch_in         and branch_sig;
    iuexstg_branch_addr_out <= iualu_do_sig(31 downto 2) and (31 downto 2 =>  branch_sig);

    iuexstg_rs1_data_out <= iufwpastu_rs1_sig;
    iuexstg_rs2_data_out <= iufwpastu_rs2_sig;
    iuexstg_rs3_data_out <= iufwpastu_rs3_sig;

    iuexstg_do_out <= iualu_do_sig
                   or iusft_do_sig
                   or X"0000000" & "000" & iucmp_do_sig;

end rtl;
