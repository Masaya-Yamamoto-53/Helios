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
use ieee.numeric_std.all;

use work.iucall_pac.all;
use work.iubprc_pac.all;
use work.iurett_pac.all;
use work.iuifid_pac.all;

use work.iuifstg_pac.all;

entity iuifstg is
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
end iuifstg;

architecture rtl of iuifstg is

    -- IU IF Stage Unit I/F
    signal intr_cs_sig       : std_logic;
    signal norm_cs_sig       : std_logic;
    signal intr_req_sig      : std_logic;
    signal intr_inst_sig     : std_logic_vector(31 downto 0);
    signal norm_inst_sig     : std_logic_vector(31 downto 0);
    signal pc_sig            : std_logic_vector(29 downto 0);
    signal op_sig            : std_logic_vector( 1 downto 0);
    signal op2_sig           : std_logic_vector( 1 downto 0);
    signal op3_sig           : std_logic_vector( 5 downto 0);
    signal p_sig             : std_logic;

    -- IU Call and Link Controller I/F
    signal iucall_token_sig  : std_logic;
    signal iucall_addr_sig   : std_logic_vector(29 downto 0);

    -- IU Branch Prediction Controller I/F
    signal iubprc_token_sig  : std_logic;
    signal iubprc_disp19_sig : std_logic_vector(18 downto 0);
    signal iubprc_addr_sig   : std_logic_vector(29 downto 0);

    -- IU RETT Instruction Pre-decoder I/F
    signal iurett_en_sig     : std_logic;

begin

    intr_req_sig  <= iuifstg_intr_req_in;
    pc_sig        <= iuifstg_pc_in;

    intr_cs_sig   <= (    iuifstg_intr_req_in);
    norm_cs_sig   <= (not iuifstg_intr_req_in);

    intr_inst_sig <= iuifstg_intr_inst_in and (31 downto 0 => intr_cs_sig);
    norm_inst_sig <= iuifstg_norm_inst_in and (31 downto 0 => norm_cs_sig);

    op_sig  <= norm_inst_sig(31 downto 30);
    op2_sig <= norm_inst_sig( 4 downto  3);
    op3_sig <= norm_inst_sig(24 downto 19);
    p_sig   <= norm_inst_sig(13);

    -----------------------------------------------------------
    -- IU Call and Link Controller                           --
    -----------------------------------------------------------
    IU_Call_and_Link : iucall
    port map (
        iucall_op_in     => op_sig,
        iucall_addr_in   => norm_inst_sig(29 downto  0),
        iucall_token_out => iucall_token_sig,
        iucall_addr_out  => iucall_addr_sig
    );

    -----------------------------------------------------------
    -- IU Branch Prediction Controller                       --
    -----------------------------------------------------------
    iubprc_disp19_sig <= norm_inst_sig(29 downto 14)
                       & norm_inst_sig( 2 downto  0);

    IU_Branch_Prediction_Controller : iubprc
    port map (
        iubprc_op_in     => op_sig,
        iubprc_p_in      => p_sig,
        iubprc_op2_in    => op2_sig,
        iubprc_disp19_in => iubprc_disp19_sig,
        iubprc_token_out => iubprc_token_sig,
        iubprc_addr_out  => iubprc_addr_sig
    );

    iuifstg_token_out <= iucall_token_sig
                      or iubprc_token_sig;

    iuifstg_addr_out  <= iucall_addr_sig
                      or iubprc_addr_sig;

    -----------------------------------------------------------
    -- IU RETT Instruction Pre-decoder                       --
    -----------------------------------------------------------
    IU_RETT_Instruction_Pre_Decoder : iurett
    port map (
        iurett_op_in  => op_sig,
        iurett_op3_in => op3_sig,
        iurett_en_out => iurett_en_sig
    );

    iuifstg_rett_out <= iurett_en_sig;

    iuifstg_do_out.intr_req <= intr_req_sig;
    iuifstg_do_out.pc       <= pc_sig;
    iuifstg_do_out.token    <= iubprc_token_sig;
    iuifstg_do_out.inst     <= intr_inst_sig or norm_inst_sig;

end rtl;
