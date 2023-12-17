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
use ieee.numeric_std.all;

use work.iu_pac.all;
use work.iuidex_pac.all;
use work.iufwu_pac.all;

use work.iuexstg_pac.all;
use work.iumul32_pac.all;
use work.iuexma_pac.all;

use work.iuexln_pac.all;

entity iuexln is
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
end iuexln;

architecture rtl of iuexln is
    -- IU EX Stage I/F
    signal iuexstg_intr_algnchk_sig : std_logic;
    signal iuexstg_branch_we_sig    : std_logic;
    signal iuexstg_branch_addr_sig  : iu_addr_if;
    signal iuexstg_rs1_data_sig     : iu_data_if;
    signal iuexstg_rs2_data_sig     : iu_data_if;
    signal iuexstg_rs3_data_sig     : iu_data_if;
    signal iuexstg_do_sig           : iu_data_if;

    -- IU 32-bit Multiply Unit (Pre) I/F
    signal iumul32pre_cs_sig        : std_logic;
    signal iumul32pre_hi_sig        : std_logic;
    signal iumul32pre_di1_sig       : std_logic_vector(31 downto 0);
    signal iumul32pre_di2_sig       : std_logic_vector(31 downto 0);

    -- IU EX/MA Pipeline Register Unit (MUL) I/F
    signal iumul32reg_wen_sig       : std_logic;
    signal iumul32reg_di_sig        : st_iumul32_if;
    signal iumul32reg_do_sig        : st_iumul32_if;

    signal iuexln_di_sig            : st_iuexma_if;
    signal iuexln_do_sig            : st_iuexma_if;
    signal iuexln_ma_rd_sig         : st_iufwpast_if;

    signal excep_we_sig             : std_logic;

begin

    -----------------------------------------------------------
    -- IU EX Stage                                           --
    -----------------------------------------------------------
    IU_EX_Stage : iuexstg
    port map (
        iuexstg_rs1_fw_in        => iuexln_di_in.rs1_fw,
        iuexstg_rs1_di_in        => iuexln_di_in.rs1_data,

        iuexstg_rs2_fw_in        => iuexln_di_in.rs2_fw,
        iuexstg_rs2_di_in        => iuexln_di_in.rs2_data,

        iuexstg_rs3_fw_in        => iuexln_di_in.rs3_fw,
        iuexstg_rs3_di_in        => iuexln_di_in.rs3_data,

        iuexstg_ma_rd_in         => iuexln_ma_rd_sig,
        iuexstg_wb_rd_in         => iuexln_wb_rd_in,

        iuexstg_alu_cs_in        => iuexln_di_in.alu_cs,
        iuexstg_sft_cs_in        => iuexln_di_in.sft_cs,
        iuexstg_cmp_cs_in        => iuexln_di_in.cmp_cs,
        iuexstg_cond_cs_in       => iuexln_di_in.cond_cs,
        iuexstg_cond_di_in       => iuexln_di_in.cond,
        iuexstg_opecode_in       => iuexln_di_in.opecode,

        iuexstg_token_in         => iuexln_di_in.token,
        iuexstg_branch_in        => iuexln_di_in.branch,

        iuexstg_intr_algnchk_out => iuexstg_intr_algnchk_sig,

        iuexstg_branch_we_out    => iuexstg_branch_we_sig,
        iuexstg_branch_addr_out  => iuexstg_branch_addr_sig,

        iuexstg_rs1_data_out     => iuexstg_rs1_data_sig,
        iuexstg_rs2_data_out     => iuexstg_rs2_data_sig,
        iuexstg_rs3_data_out     => iuexstg_rs3_data_sig,

        iuexstg_do_out           => iuexstg_do_sig
    );

    -----------------------------------------------------------
    -- IU 32-bit Multiply Unit (Pre)                         --
    -----------------------------------------------------------
    iumul32pre_cs_sig      <= iuexln_di_in.mul_cs;
    iumul32pre_hi_sig      <= iuexln_di_in.opecode(0);
    iumul32pre_di1_sig     <= iuexstg_rs1_data_sig;
    iumul32pre_di2_sig     <= iuexstg_rs2_data_sig;

    IU_Multiply_Unit_Pre : iumul32pre
    port map (
        iumul32pre_cs_in    => iumul32pre_cs_sig,
        iumul32pre_hi_in    => iumul32pre_hi_sig,
        iumul32pre_di1_in   => iumul32pre_di1_sig,
        iumul32pre_di2_in   => iumul32pre_di2_sig,
        iumul32pre_hi_out   => iumul32reg_di_sig.hi,
        iumul32pre_mul1_out => iumul32reg_di_sig.mul1_data,
        iumul32pre_mul2_out => iumul32reg_di_sig.mul2_data,
        iumul32pre_mul3_out => iumul32reg_di_sig.mul3_data,
        iumul32pre_mul4_out => iumul32reg_di_sig.mul4_data
    );

    -----------------------------------------------------------
    -- IU EX/MA Pipeline Register Unit                       --
    -----------------------------------------------------------
    iuexln_di_sig.mul_cs    <= iuexln_di_in.mul_cs;

    iuexln_di_sig.rd_we     <= iuexln_di_in.rd_we;
    iuexln_di_sig.rd_sel    <= iuexln_di_in.rd_sel;
    iuexln_di_sig.rd_data   <= iuexstg_do_sig;

    iuexln_di_sig.psr_read  <= iuexln_di_in.psr_read;
    iuexln_di_sig.s_we      <= iuexln_di_in.s_we;
    iuexln_di_sig.et_we     <= iuexln_di_in.et_we;
    iuexln_di_sig.pil_we    <= iuexln_di_in.pil_we;
    iuexln_di_sig.intr_req  <= iuexln_di_in.intr_req;

    iuexln_di_sig.branch    <= iuexstg_branch_we_sig;
    iuexln_di_sig.pc        <= iuexln_di_in.pc;
    iuexln_di_sig.rett      <= iuexln_di_in.rett;

    iuexln_di_sig.mem_write <= iuexln_di_in.mem_write;
    iuexln_di_sig.mem_read  <= iuexln_di_in.mem_read;
    iuexln_di_sig.mem_sign  <= iuexln_di_in.mem_sign;
    iuexln_di_sig.mem_type  <= iuexln_di_in.mem_type;
    iuexln_di_sig.mem_data  <= iuexstg_rs3_data_sig;

    iuexln_di_sig.inst_a    <= iuexln_di_in.inst_a;

    -- to interrupt control unit
    iuexln_intr_dis_out     <= iuexln_di_in.et_we;
			    --or iuexln_di_in.rett;

    excep_we_sig <= iuexln_di_in.unimp
                 or iuexstg_intr_algnchk_sig;

    iuexln_excep_we_out     <= excep_we_sig;
    iuexln_excep_addr_out   <= std_logic_vector(unsigned(iuexln_di_in.pc) + 1)
                        and (29 downto 0 => excep_we_sig);

    iuexln_branch_we_out   <= iuexstg_branch_we_sig;
    iuexln_branch_addr_out <= iuexstg_branch_addr_sig;

    iuexln_intr_unimp_out   <= iuexln_di_in.unimp;
    iuexln_intr_algnchk_out <= iuexstg_intr_algnchk_sig;

    -----------------------------------------------------------
    -- IU EX/MA Pipeline Register Unit                       --
    -----------------------------------------------------------
    IU_EXMA_Pipeline_Register : iuexma
    port map (
        iuexma_clk_in   => iuexln_clk_in,
        iuexma_rst_in   => iuexln_rst_in,
        iuexma_wen_in   => iuexln_wen_in,
        iuexma_flash_in => iuexln_flash_in,
        iuexma_di_in    => iuexln_di_sig,
        iuexma_do_out   => iuexln_do_sig
    );

    -----------------------------------------------------------
    -- IU EX/MA Pipeline Register Unit (MUL)                 --
    -----------------------------------------------------------
    iumul32reg_wen_sig   <= iuexln_wen_in;

    IU_EXMA_Pipeline_Register_mul : iumul32reg
    port map (
        iumul32reg_clk_in   => iuexln_clk_in,
        iumul32reg_wen_in   => iumul32reg_wen_sig,
        iumul32reg_di_in    => iumul32reg_di_sig,
        iumul32reg_do_out   => iumul32reg_do_sig
    );

    -- to forwarding unit (EX Stage)
    iuexln_ma_rd_sig.we   <= iuexln_do_sig.rd_we;
    iuexln_ma_rd_sig.data <= iuexln_do_sig.rd_data;

    -- to memory access stage
    iuexln_do_out  <= iuexln_do_sig;
    iuexln_mul_out <= iumul32reg_do_sig;

end rtl;
