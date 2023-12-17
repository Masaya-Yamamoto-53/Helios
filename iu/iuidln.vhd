--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Instruction Decode Block
-- Description:
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iu_pac.all;
use work.iuifid_pac.all;
use work.iumawb_pac.all;
use work.iufwu_pac.all;

use work.iuidstg_pac.all;
use work.iurf_pac.all;
use work.iuidex_pac.all;

use work.iuidln_pac.all;

entity iuidln is
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
end iuidln;

architecture rtl of iuidln is

    -- IU ID Stage I/F
    signal iuidstg_ex_rd_sig    : st_iufwpre_if;
    signal iuidstg_ex_read_sig  : std_logic;
    signal iuidstg_data_hzd_sig : std_logic;

    -- IU Register File I/F
    signal iurf_rs1_sel_sig     : iurf_rs_sel_if;
    signal iurf_rs2_sel_sig     : iurf_rs_sel_if;
    signal iurf_rs3_sel_sig     : iurf_rs_sel_if;
    signal iurf_rs1_do_sig      : iurf_rs_data_if;
    signal iurf_rs2_do_sig      : iurf_rs_data_if;
    signal iurf_rs3_do_sig      : iurf_rs_data_if;

    -- ID/EX Pipeline Register I/F
    signal iuidex_wen_sig       : std_logic;
    signal iuidex_flash_sig     : std_logic;
    signal iuidex_di_sig        : st_iuidex_if;
    signal iuidex_do_sig        : st_iuidex_if;

begin

    -----------------------------------------------------------
    -- IU ID Stage                                           --
    -----------------------------------------------------------
    IU_ID_Stage : iuidstg
    port map (
        iuidstg_intr_req_in  => iuidln_if_di_in.intr_req,
        iuidstg_inst_in      => iuidln_if_di_in.inst,
        iuidstg_token_in     => iuidln_if_di_in.token,
        iuidstg_rs1_sel_out  => iurf_rs1_sel_sig,
        iuidstg_rs2_sel_out  => iurf_rs2_sel_sig,
        iuidstg_rs3_sel_out  => iurf_rs3_sel_sig,
        iuidstg_rs1_di_in    => iurf_rs1_do_sig,
        iuidstg_rs2_di_in    => iurf_rs2_do_sig,
        iuidstg_rs3_di_in    => iurf_rs3_do_sig,
        iuidstg_pc_in        => iuidln_if_di_in.pc,
        iuidstg_ex_rd_in     => iuidstg_ex_rd_sig,
        iuidstg_ma_rd_in     => iuidln_ma_rd_in,
        iuidstg_ex_read_in   => iuidstg_ex_read_sig,
        iuidstg_data_hzd_out => iuidstg_data_hzd_sig,
        iuidstg_do_out       => iuidex_di_sig
    );

    -----------------------------------------------------------
    -- IU Register File                                      --
    -----------------------------------------------------------
    IU_Register_File : iurf
    port map (
        iurf_clk_in     => iuidln_clk_in,
        iurf_rs1_sel_in => iurf_rs1_sel_sig,
        iurf_rs2_sel_in => iurf_rs2_sel_sig,
        iurf_rs3_sel_in => iurf_rs3_sel_sig,
        iurf_w_in       => iuidln_wb_di_in,
        iurf_pc_in      => iuidln_if_di_in.pc,
        iurf_rs1_do_out => iurf_rs1_do_sig,
        iurf_rs2_do_out => iurf_rs2_do_sig,
        iurf_rs3_do_out => iurf_rs3_do_sig
    );

    -- to hazard detection unit
    iuidln_data_hzd_out <= iuidstg_data_hzd_sig;

    iuidln_intr_dis_out <= iuidex_di_sig.et_we;
			--or iuidex_di_sig.rett;

    -----------------------------------------------------------
    -- ID/EX Pipeline Register                               --
    -----------------------------------------------------------
    iuidex_wen_sig   <= iuidln_wen_in   and (not iuidex_di_sig.intr_req);
    iuidex_flash_sig <= iuidln_flash_in and (not iuidex_di_sig.intr_req);

    IU_IDEX_Pipeline_Register : iuidex
    port map (
        iuidex_clk_in   => iuidln_clk_in,
        iuidex_rst_in   => iuidln_rst_in,
        iuidex_wen_in   => iuidex_wen_sig,
        iuidex_flash_in => iuidex_flash_sig,
        iuidex_di_in    => iuidex_di_sig,
        iuidex_do_out   => iuidex_do_sig
    );

    iuidstg_ex_rd_sig.we  <= iuidex_do_sig.rd_we;
    iuidstg_ex_rd_sig.sel <= iuidex_do_sig.rd_sel;

    -- to data hazard detection signal
    iuidstg_ex_read_sig <= iuidex_do_sig.mul_cs
                        or iuidex_do_sig.psr_read
                        or iuidex_do_sig.mem_read;

    -- to execution stage
    iuidln_do_out <= iuidex_do_sig;

end rtl;
