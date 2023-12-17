--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Instruction Fetch Stage
-- Description:
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iu_pac.all;

use work.iupc_pac.all;
use work.iuifstg_pac.all;
use work.iuifid_pac.all;

use work.iuifln_pac.all;

entity iuifln is
    port (
        iuifln_clk_in           : in    std_logic;
        iuifln_rst_in           : in    std_logic;

        iuifln_inst_addr_out    :   out std_logic_vector(29 downto 0);
        iuifln_inst_data_in     : in    iu_data_if;

        iuifln_excep_ex_we_in   : in    std_logic;
        iuifln_excep_ex_addr_in : in    std_logic_vector(29 downto 0);
        iuifln_excep_ma_we_in   : in    std_logic;
        iuifln_excep_ma_addr_in : in    std_logic_vector(29 downto 0);

        iuifln_intr_req_in      : in    std_logic;
        iuifln_intr_inst_in     : in    std_logic_vector(31 downto 0);
        iuifln_intr_vec_we_in   : in    std_logic;
        iuifln_intr_vec_addr_in : in    std_logic_vector(29 downto 0);

        iuifln_bprc_we_in       : in    std_logic;
        iuifln_bprc_addr_in     : in    std_logic_vector(29 downto 0);

        iuifln_pc_wen_in        : in    std_logic;

        iuifln_wen_in           : in    std_logic;
        iuifln_flash_in         : in    std_logic;

        iuifln_rett_out         :   out std_logic;

        iuifln_do_out           :   out st_iuifid_if
    );
end iuifln;

architecture rtl of iuifln is

    -- IU Program Counter I/F
    signal iupc_di_sig       : iu_addr_if;
    signal iupc_do_sig       : iu_addr_if;
    signal iupc_next_sig     : iu_addr_if;
    signal iupc_base_sig     : iu_addr_if;
    signal iupc_npc_sig      : iu_addr_if;

    -- IF Stage I/F
    signal iuifstg_token_sig : std_logic;
    signal iuifstg_addr_sig  : iu_addr_if;
    signal iuifstg_rett_sig  : std_logic;

    -- IF/ID Pipeline Register I/F
    signal iuifid_wen_sig    : std_logic;
    signal iuifid_flash_sig  : std_logic;
    signal iuifid_di_sig     : st_iuifid_if;
    signal iuifid_do_sig     : st_iuifid_if;

begin

    -----------------------------------------------------------
    -- Multiplexer : PC Select                               --
    -----------------------------------------------------------
    iupc_di_sig <= iuifln_excep_ma_addr_in when iuifln_excep_ma_we_in = '1' else
                   iuifln_excep_ex_addr_in when iuifln_excep_ex_we_in = '1' else
                   iuifln_intr_vec_addr_in when iuifln_intr_vec_we_in = '1' else
                   iupc_do_sig             when iuifln_intr_req_in    = '1' else
                   iuifln_bprc_addr_in     when iuifln_bprc_we_in     = '1' else
                   iupc_npc_sig;

    -----------------------------------------------------------
    -- IU Program Counter                                    --
    -----------------------------------------------------------
    IU_Program_Counter : iupc
    port map (
        iupc_clk_in  => iuifln_clk_in,
        iupc_rst_in  => iuifln_rst_in,
        iupc_wen_in  => iuifln_pc_wen_in,
        iupc_di_in   => iupc_di_sig,
        iupc_do_out  => iupc_do_sig
    );

    iupc_base_sig <= iuifid_di_sig.pc when iuifstg_token_sig = '1' else
                     iupc_do_sig;

    iupc_next_sig <= iuifstg_addr_sig when iuifstg_token_sig = '1' else
                     X"0000000" & "01";

    iupc_npc_sig  <= std_logic_vector(unsigned(iupc_base_sig)
                                    + unsigned(iupc_next_sig));

    -----------------------------------------------------------
    -- Instruction Bus I/F                                   --
    -----------------------------------------------------------
    iuifln_inst_addr_out <= iupc_do_sig (29 downto 0);

    -----------------------------------------------------------
    -- IF Stage                                              --
    -----------------------------------------------------------
    IU_IF_Stage : iuifstg
    port map (
        iuifstg_intr_req_in  => iuifln_intr_req_in,
        iuifstg_intr_inst_in => iuifln_intr_inst_in,
        iuifstg_norm_inst_in => iuifln_inst_data_in,
        iuifstg_pc_in        => iupc_do_sig,
        iuifstg_token_out    => iuifstg_token_sig,
        iuifstg_addr_out     => iuifstg_addr_sig,
        iuifstg_rett_out     => iuifstg_rett_sig,
        iuifstg_do_out       => iuifid_di_sig
    );

    iuifln_rett_out <= iuifstg_rett_sig;
    -----------------------------------------------------------
    -- IF/ID Pipeline Register                               --
    -----------------------------------------------------------
    iuifid_wen_sig   <= iuifln_wen_in   and (not iuifid_di_sig.intr_req);
    iuifid_flash_sig <= iuifln_flash_in and (not iuifid_di_sig.intr_req);

    IU_IFID_Pipeline_Register : iuifid
    port map (
        iuifid_clk_in   => iuifln_clk_in,
        iuifid_rst_in   => iuifln_rst_in,
        iuifid_wen_in   => iuifid_wen_sig,
        iuifid_flash_in => iuifid_flash_sig,
        iuifid_di_in    => iuifid_di_sig,
        iuifid_do_out   => iuifid_do_sig
    );

    iuifln_do_out <= iuifid_do_sig;

end rtl;
