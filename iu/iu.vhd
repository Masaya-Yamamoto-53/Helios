--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU(Integer Unit)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iu_pac.all;

use work.iuintr_pac.all;
use work.iuhdu_pac.all;
use work.iufwu_pac.all;

use work.iuifid_pac.all;
use work.iuidex_pac.all;
use work.iuexma_pac.all;
use work.iumawb_pac.all;

use work.iumul32_pac.all;

use work.iuifln_pac.all;
use work.iuidln_pac.all;
use work.iuexln_pac.all;
use work.iumaln_pac.all;

entity iu is
    port (
        iu_sys_clk_in    : in    std_logic;
        iu_sys_rst_in    : in    std_logic;

        iu_inst_addr_out :   out std_logic_vector(29 downto 0);
        iu_inst_data_in  : in    std_logic_vector(31 downto 0);

        iu_data_re_out   :   out std_logic;
        iu_data_we_out   :   out std_logic;
        iu_data_dqm_out  :   out std_logic_vector( 3 downto 0);
        iu_data_addr_out :   out std_logic_vector(31 downto 0);
        iu_data_a_out    :   out std_logic;
        iu_data_di_out   :   out std_logic_vector(31 downto 0);
        iu_data_do_in    : in    std_logic_vector(31 downto 0);

        iu_intr_int_in   : in    std_logic;
        iu_intr_irl_in   : in    std_logic_vector( 3 downto 0);
        iu_intr_ack_out  :   out std_logic
    );
end iu;

architecture rtl of iu is

    -- IU Interrupt Control Unit I/F
    signal iuintr_dis_sig             : std_logic;
    signal iuintr_rett_sig            : std_logic;
    signal iuintr_privileged_sig      : std_logic;
    signal iuintr_unimp_sig           : std_logic;
    signal iuintr_algnchk_sig         : std_logic;
    signal iuintr_excep_req_sig       : std_logic_vector(15 downto 0);
    signal iuintr_intr_req_sig        : std_logic;
    signal iuintr_intr_inst_sig       : std_logic_vector(31 downto 0);
    signal iuintr_vec_we_sig          : std_logic;
    signal iuintr_vec_addr_sig        : iu_addr_if;

    -- IU Hazard Detection Unit I/F
    signal iuhdu_ma_excep_sig         : std_logic;
    signal iuhdu_ex_excep_sig         : std_logic;
    signal iuhdu_pc_wen_sig           : std_logic;
    signal iuhdu_ifid_wen_sig         : std_logic;
    signal iuhdu_ifid_flash_sig       : std_logic;
    signal iuhdu_idex_wen_sig         : std_logic;
    signal iuhdu_idex_flash_sig       : std_logic;
    signal iuhdu_exma_wen_sig         : std_logic;
    signal iuhdu_exma_flash_sig       : std_logic;
    signal iuhdu_mawb_wen_sig         : std_logic;
    signal iuhdu_mawb_flash_sig       : std_logic;

    signal iuifln_rett_sig            : std_logic;

    -- IU ID Pipeline I/F
    signal iuifln_do_sig              : st_iuifid_if;

    -- IU ID Pipeline I/F
    signal iuidln_data_hzd_sig        : std_logic;
    signal iuidln_intr_dis_sig        : std_logic;
    signal iuidln_do_sig              : st_iuidex_if;

    -- IU EX Pipeline I/F
    signal iuexln_mul_sig             : st_iumul32_if;
    signal iuexln_branch_we_sig       : std_logic;
    signal iuexln_branch_addr_sig     : iu_addr_if;
    signal iuexln_intr_dis_sig        : std_logic;
    signal iuexln_intr_unimp_sig      : std_logic;
    signal iuexln_intr_algnchk_sig    : std_logic;
    signal iuexln_excep_we_sig        : std_logic;
    signal iuexln_excep_addr_sig      : iu_addr_if;
    signal iuexln_do_sig              : st_iuexma_if;

    -- IU MA Pipeline I/F
    signal iumaln_rd_sig              : st_iufwpre_if;
    signal iumaln_intr_dis_sig        : std_logic;
    signal iumaln_intr_pil_sig        : std_logic_vector( 3 downto 0);
    signal iumaln_intr_privileged_sig : std_logic;
    signal iumaln_intr_algnchk_sig    : std_logic;
    signal iumaln_excep_we_sig        : std_logic;
    signal iumaln_excep_addr_sig      : iu_addr_if;
    signal iumaln_intr_rett_sig       : std_logic;
    signal iumaln_rett_we_sig         : std_logic;
    signal iumaln_rett_addr_sig       : iu_addr_if;
    signal iumaln_wb_rd_sig           : st_iufwpast_if;
    signal iumaln_do_sig              : st_iumawb_if;

begin

    iuintr_unimp_sig      <= iuexln_intr_unimp_sig;

    iuintr_privileged_sig <= iumaln_intr_privileged_sig;

    iuintr_algnchk_sig    <= iuexln_intr_algnchk_sig
                          or iumaln_intr_algnchk_sig;

    -----------------------------------------------------------
    -- IU Interrupt Control Unit                             --
    -----------------------------------------------------------
    iuintr_excep_req_sig( 0) <= '0';
    iuintr_excep_req_sig( 1) <= '0';
    iuintr_excep_req_sig( 2) <= '0';
    iuintr_excep_req_sig( 3) <= '0';
    iuintr_excep_req_sig( 4) <= '0';
    iuintr_excep_req_sig( 5) <= iuintr_privileged_sig; -- privileged instruction
    iuintr_excep_req_sig( 6) <= iuintr_unimp_sig;      -- illegal instruction
    iuintr_excep_req_sig( 7) <= '0';
    iuintr_excep_req_sig( 8) <= '0';
    iuintr_excep_req_sig( 9) <= iuintr_algnchk_sig;    -- memory address not aligned
    iuintr_excep_req_sig(10) <= '0';
    iuintr_excep_req_sig(11) <= '0';
    iuintr_excep_req_sig(12) <= '0';
    iuintr_excep_req_sig(13) <= '0';
    iuintr_excep_req_sig(14) <= '0';
    iuintr_excep_req_sig(15) <= '0';

    iuintr_dis_sig     <= iuidln_intr_dis_sig
                       or iuexln_intr_dis_sig
                       or iumaln_intr_dis_sig;

    iuintr_rett_sig    <= iumaln_intr_rett_sig;

    IU_Interrupt_Controller_Unit : iuintr
    port map (
        iuintr_clk_in        => iu_sys_clk_in,
        iuintr_rst_in        => iu_sys_rst_in,

        iuintr_dis_in        => iuintr_dis_sig,

        iuintr_excep_req_in  => iuintr_excep_req_sig,

        iuintr_rett_req_in   => iuintr_rett_sig,
        iuintr_rett_we_in    => iumaln_rett_we_sig,
        iuintr_rett_addr_in  => iumaln_rett_addr_sig,

        iuintr_intr_in       => iu_intr_int_in,
        iuintr_irl_in        => iu_intr_irl_in,
        iuintr_pil_in        => iumaln_intr_pil_sig,

        iuintr_vec_we_out    => iuintr_vec_we_sig,
        iuintr_vec_addr_out  => iuintr_vec_addr_sig,

        iuintr_intr_req_out  => iuintr_intr_req_sig,
        iuintr_intr_inst_out => iuintr_intr_inst_sig,
        iuintr_intr_ack_out  => iu_intr_ack_out
    );

    -----------------------------------------------------------
    -- IU Hazard Detection Unit                              --
    -----------------------------------------------------------
    iuhdu_ma_excep_sig <= iumaln_intr_algnchk_sig
                       or iumaln_intr_privileged_sig
                       or iumaln_intr_rett_sig;

    iuhdu_ex_excep_sig <= iuexln_intr_unimp_sig
                       or iuexln_intr_algnchk_sig;

    IU_Hazard_Detection_Unit : iuhdu
    port map (
        iuhdu_ma_excep_in       => iuhdu_ma_excep_sig,
        iuhdu_ex_excep_in       => iuhdu_ex_excep_sig,
        iuhdu_ex_branch_in      => iuexln_branch_we_sig,
        iuhdu_id_read_in        => iuidln_data_hzd_sig,

        iuhdu_pc_wen_out        => iuhdu_pc_wen_sig,
        iuhdu_ifid_wen_out      => iuhdu_ifid_wen_sig,
        iuhdu_ifid_flash_out    => iuhdu_ifid_flash_sig,
        iuhdu_idex_wen_out      => iuhdu_idex_wen_sig,
        iuhdu_idex_flash_out    => iuhdu_idex_flash_sig,
        iuhdu_exma_wen_out      => iuhdu_exma_wen_sig,
        iuhdu_exma_flash_out    => iuhdu_exma_flash_sig,
        iuhdu_mawb_wen_out      => iuhdu_mawb_wen_sig,
        iuhdu_mawb_flash_out    => iuhdu_mawb_flash_sig
    );

    -----------------------------------------------------------
    -- IU IF Pipeline                                        --
    -----------------------------------------------------------
    IU_IF_Pipeline : iuifln
    port map (
        iuifln_clk_in            => iu_sys_clk_in,
        iuifln_rst_in            => iu_sys_rst_in,
        
        iuifln_inst_addr_out     => iu_inst_addr_out,
        iuifln_inst_data_in      => iu_inst_data_in,

        iuifln_excep_ex_we_in    => iuexln_excep_we_sig,
        iuifln_excep_ex_addr_in  => iuexln_excep_addr_sig,
        iuifln_excep_ma_we_in    => iumaln_excep_we_sig,
        iuifln_excep_ma_addr_in  => iumaln_excep_addr_sig,

        iuifln_intr_req_in       => iuintr_intr_req_sig,
        iuifln_intr_inst_in      => iuintr_intr_inst_sig,
        iuifln_intr_vec_we_in    => iuintr_vec_we_sig,
        iuifln_intr_vec_addr_in  => iuintr_vec_addr_sig,

        iuifln_bprc_we_in        => iuexln_branch_we_sig,
        iuifln_bprc_addr_in      => iuexln_branch_addr_sig,

        iuifln_pc_wen_in         => iuhdu_pc_wen_sig,
        iuifln_rett_out          => iuifln_rett_sig,
---------------------------------------------------------------
-- IF/ID Stage                                               --
---------------------------------------------------------------
        iuifln_wen_in            => iuhdu_ifid_wen_sig,
        iuifln_flash_in          => iuhdu_ifid_flash_sig,
        iuifln_do_out            => iuifln_do_sig
    );

    -----------------------------------------------------------
    -- IU ID Pipeline                                        --
    -----------------------------------------------------------
    IU_ID_Pipeline : iuidln
    port map (
        iuidln_clk_in         => iu_sys_clk_in,
        iuidln_rst_in         => iu_sys_rst_in,
        iuidln_wen_in         => iuhdu_idex_wen_sig,
        iuidln_flash_in       => iuhdu_idex_flash_sig,
        iuidln_if_di_in       => iuifln_do_sig,
        iuidln_wb_di_in       => iumaln_do_sig,
        iuidln_ma_rd_in       => iumaln_rd_sig,
        iuidln_data_hzd_out   => iuidln_data_hzd_sig,
        iuidln_intr_dis_out   => iuidln_intr_dis_sig,
---------------------------------------------------------------
-- ID/EX Stage                                               --
---------------------------------------------------------------
        iuidln_do_out         => iuidln_do_sig
    );

    -----------------------------------------------------------
    -- IU EX Pipeline                                        --
    -----------------------------------------------------------
    IU_EX_Pipeline : iuexln
    port map (
        iuexln_clk_in           => iu_sys_clk_in,
        iuexln_rst_in           => iu_sys_rst_in,
        iuexln_wen_in           => iuhdu_exma_wen_sig,
        iuexln_flash_in         => iuhdu_exma_flash_sig,
        iuexln_di_in            => iuidln_do_sig,
        iuexln_wb_rd_in         => iumaln_wb_rd_sig,
        iuexln_branch_we_out    => iuexln_branch_we_sig,
        iuexln_branch_addr_out  => iuexln_branch_addr_sig,
        iuexln_intr_dis_out     => iuexln_intr_dis_sig,
        iuexln_intr_unimp_out   => iuexln_intr_unimp_sig,
        iuexln_intr_algnchk_out => iuexln_intr_algnchk_sig,
        iuexln_excep_we_out     => iuexln_excep_we_sig,
        iuexln_excep_addr_out   => iuexln_excep_addr_sig,
--------------------------------------------------------------------------------
-- EX/MA Stage                                                                --
--------------------------------------------------------------------------------
        iuexln_mul_out          => iuexln_mul_sig,
        iuexln_do_out           => iuexln_do_sig
    );

    -----------------------------------------------------------
    -- IU MA Pipeline                                        --
    -----------------------------------------------------------
    IU_MA_Pipeline : iumaln
    port map (
        iumaln_clk_in              => iu_sys_clk_in,
        iumaln_rst_in              => iu_sys_rst_in,
        iumaln_wen_in              => iuhdu_mawb_wen_sig,
        iumaln_flash_in            => iuhdu_mawb_flash_sig,
        iumaln_di_in               => iuexln_do_sig,

        iumaln_mul_in              => iuexln_mul_sig,

        iumaln_ma_rd_out           => iumaln_rd_sig,

        iumaln_intr_dis_out        => iumaln_intr_dis_sig,
        iumaln_intr_pil_out        => iumaln_intr_pil_sig,

        iumaln_intr_privileged_out => iumaln_intr_privileged_sig,
        iumaln_intr_algnchk_out    => iumaln_intr_algnchk_sig,
        iumaln_intr_rett_out       => iumaln_intr_rett_sig,

        iumaln_mem_re_out          => iu_data_re_out,
        iumaln_mem_we_out          => iu_data_we_out,
        iumaln_mem_dqm_out         => iu_data_dqm_out,
        iumaln_mem_addr_out        => iu_data_addr_out,
        iumaln_mem_a_out           => iu_data_a_out,
        iumaln_mem_di_out          => iu_data_di_out,
        iumaln_mem_do_in           => iu_data_do_in,

        iumaln_excep_we_out        => iumaln_excep_we_sig,
        iumaln_excep_addr_out      => iumaln_excep_addr_sig,

        iumaln_rett_we_out         => iumaln_rett_we_sig,
        iumaln_rett_addr_out       => iumaln_rett_addr_sig,
--------------------------------------------------------------------------------
-- MA/WB Stage                                                                --
--------------------------------------------------------------------------------
        iumaln_wb_rd_out           => iumaln_wb_rd_sig,
        iumaln_do_out              => iumaln_do_sig
    );

end rtl;
