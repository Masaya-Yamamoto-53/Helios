--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Instruction Decode Stage
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iuctrl_pac.all;
use work.iufwu_pac.all;

use work.iuifid_pac.all;
use work.iuidex_pac.all;
use work.iumawb_pac.all;
use work.iubprc_pac.all;

use work.iuidstg_pac.all;

entity iuidstg is
    port (
        iuidstg_intr_req_in  : in    std_logic;
        iuidstg_inst_in      : in    std_logic_vector(31 downto 0);
        iuidstg_token_in     : in    std_logic;
        iuidstg_rs1_sel_out  :   out std_logic_vector( 4 downto 0);
        iuidstg_rs2_sel_out  :   out std_logic_vector( 4 downto 0);
        iuidstg_rs3_sel_out  :   out std_logic_vector( 4 downto 0);
        iuidstg_rs1_di_in    : in    std_logic_vector(31 downto 0);
        iuidstg_rs2_di_in    : in    std_logic_vector(31 downto 0);
        iuidstg_rs3_di_in    : in    std_logic_vector(31 downto 0);
        iuidstg_pc_in        : in    std_logic_vector(29 downto 0);
        iuidstg_ex_rd_in     : in    st_iufwpre_if;
        iuidstg_ma_rd_in     : in    st_iufwpre_if;
        iuidstg_ex_read_in   : in    std_logic;
        iuidstg_data_hzd_out :   out std_logic;
        iuidstg_do_out       :   out st_iuidex_if
    );
end iuidstg;

architecture rtl of iuidstg is

    -- IU Controller I/F
    signal iuctrl_do_sig       : st_iuctrl_if;

    -- IU Forwarding Unit Signals I/F
    signal iufwpreu_rs1_fw_sig : std_logic_vector(1 downto 0);
    signal iufwpreu_rs2_fw_sig : std_logic_vector(1 downto 0);
    signal iufwpreu_rs3_fw_sig : std_logic_vector(1 downto 0);

begin

    -----------------------------------------------------------
    -- IU Controller                                         --
    -----------------------------------------------------------
    IU_Controller : iuctrl
    port map (
        iuctrl_intr_in  => iuidstg_intr_req_in,
        iuctrl_inst_in  => iuidstg_inst_in,
        iuctrl_token_in => iuidstg_token_in,
        iuctrl_do_out   => iuctrl_do_sig
    );

    iuidstg_rs1_sel_out <= iuctrl_do_sig.rs1_sel;
    iuidstg_rs2_sel_out <= iuctrl_do_sig.rs2_sel;
    iuidstg_rs3_sel_out <= iuctrl_do_sig.rs3_sel;

    -----------------------------------------------------------
    -- IU Forwarding Unit (Previous)                         --
    -----------------------------------------------------------
    IU_Forwarding_Previous_Unit : iufwpreu
    port map (
        iufwpreu_rs1_sel_in => iuctrl_do_sig.rs1_sel,
        iufwpreu_rs2_sel_in => iuctrl_do_sig.rs2_sel,
        iufwpreu_rs3_sel_in => iuctrl_do_sig.rs3_sel,
        iufwpreu_ex_rd_in   => iuidstg_ex_rd_in,
        iufwpreu_ma_rd_in   => iuidstg_ma_rd_in,
        iufwpreu_rs1_fw_out => iufwpreu_rs1_fw_sig,
        iufwpreu_rs2_fw_out => iufwpreu_rs2_fw_sig,
        iufwpreu_rs3_fw_out => iufwpreu_rs3_fw_sig
    );

    iuidstg_data_hzd_out <= iuidstg_ex_read_in
                       and (iufwpreu_rs1_fw_sig(IUFWU_EX)
                         or iufwpreu_rs2_fw_sig(IUFWU_EX)
                         or iufwpreu_rs3_fw_sig(IUFWU_EX));

    iuidstg_do_out.rs1_fw    <= iufwpreu_rs1_fw_sig;
    iuidstg_do_out.rs1_data  <= iuidstg_rs1_di_in;

    iuidstg_do_out.rs2_fw    <= iufwpreu_rs2_fw_sig;
    iuidstg_do_out.rs2_data  <= iuidstg_sign_extend_simm13 (iuctrl_do_sig.imm_data)
                             or iubprc_sign_extend_disp19 (iuctrl_do_sig.disp19) & "00"
                             or iuctrl_do_sig.sethi & "000000000"
                             or iuidstg_rs2_di_in;

    iuidstg_do_out.rs3_fw    <= iufwpreu_rs3_fw_sig;
    iuidstg_do_out.rs3_data  <= iuidstg_rs3_di_in;

    iuidstg_do_out.opecode   <= iuctrl_do_sig.opecode;
    iuidstg_do_out.cond_cs   <= iuctrl_do_sig.cond_cs;
    iuidstg_do_out.cond      <= iuctrl_do_sig.cond;

    iuidstg_do_out.alu_cs    <= iuctrl_do_sig.alu_cs;
    iuidstg_do_out.mul_cs    <= iuctrl_do_sig.mul_cs;
    iuidstg_do_out.sft_cs    <= iuctrl_do_sig.sft_cs;
    iuidstg_do_out.cmp_cs    <= iuctrl_do_sig.cmp_cs;

    iuidstg_do_out.rd_we     <= iuctrl_do_sig.rd_we;
    iuidstg_do_out.rd_sel    <= iuctrl_do_sig.rd_sel;

    iuidstg_do_out.intr_req  <= iuidstg_intr_req_in;

    iuidstg_do_out.token     <= iuidstg_token_in;
    iuidstg_do_out.branch    <= iuctrl_do_sig.branch;

    iuidstg_do_out.pc        <= iuidstg_pc_in;
    iuidstg_do_out.rett      <= iuctrl_do_sig.rett;

    iuidstg_do_out.psr_read  <= iuctrl_do_sig.psr_read;
    iuidstg_do_out.s_we      <= iuctrl_do_sig.s_we;
    iuidstg_do_out.et_we     <= iuctrl_do_sig.et_we;
    iuidstg_do_out.pil_we    <= iuctrl_do_sig.pil_we;

    iuidstg_do_out.mem_write <= iuctrl_do_sig.mem_write;
    iuidstg_do_out.mem_read  <= iuctrl_do_sig.mem_read;
    iuidstg_do_out.mem_sign  <= iuctrl_do_sig.mem_sign;
    iuidstg_do_out.mem_type  <= iuctrl_do_sig.mem_type;

    iuidstg_do_out.inst_a    <= iuctrl_do_sig.inst_a;
    iuidstg_do_out.unimp     <= iuctrl_do_sig.unimp;

end rtl;
