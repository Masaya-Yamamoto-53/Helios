--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Control
-- Description:
--   Decode the instruction code and generate control signals
--   for each unit in the EX stage.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iufmt0dec_pac.all;
use work.iufmt1dec_pac.all;
use work.iufmt2dec_pac.all;
use work.iufmt3dec_pac.all;
use work.iuintrdec_pac.all;
use work.iuctrl_pac.all;

entity iuctrl is
    port (
        iuctrl_intr_in  : in    std_logic;
        iuctrl_inst_in  : in    std_logic_vector(31 downto 0);
        iuctrl_token_in : in    std_logic;
        iuctrl_do_out   :   out st_iuctrl_if
    );
end iuctrl;

architecture rtl of iuctrl is

    signal op_sig           : std_logic_vector( 1 downto 0);
    -- op_sig = "00": Branch Prediction & SETHI Instruction
    --  31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
    -- +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    -- | fmt |                           set23hi                         |      rd      | op2 |set23lo |
    -- +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    -- | fmt |                          disp19hi             | p|  cond  |      rs3     | op2 |disp19lo|
    -- +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

    -- op_sig = "01": Call and Link Instruction
    --  31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
    -- +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    -- | fmt |                                        disp30                                           |
    -- +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

    -- op_sig = "10": Arithmetic Instruction
    --  31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
    -- +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    -- | fmt |      rd      |       op3       |      rs1     | i|  cond  |      rs3     |      rs2     |
    -- +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    -- | fmt |      rd      |       op3       |      rs1     | i|               simm13                 |
    -- +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

    -- op_sig = "11": Load/Store Instruction
    --  31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
    -- +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    -- | fmt |      rd      |       op3       |      rs1     | i|  cond  |      rs3     |      rs2     |
    -- +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    -- | fmt |      rd      |       op3       |      rs1     | i|               simm13                 |
    -- +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

    signal op2_sig          : std_logic_vector( 1 downto 0);
    signal cond_sig         : std_logic_vector( 2 downto 0);
    -- +--+--+--+--+--+----------+---------------------------------------------------------------------+
    -- | op2 |  cond  | Mnemonic | Instruction                                                         |
    -- +--+--+--+--+--+----------+---------------------------------------------------------------------+
    -- | 0| 0|        | SETHI    | Set High 23 bits of rs3 Register                                    |
    -- +-----+--------+----------+---------------------------------------------------------------------+
    -- | 0| 1| 0| 0| 0| BRLBC    | Branch if Register Low Bit is Clear                                 |
    -- | 0| 1| 0| 0| 1| BRZ      | Branch of Register Zero                                             |
    -- | 0| 1| 0| 1| 0| BRLZ     | Branch on Register Less Than Zero                                   |
    -- | 0| 1| 0| 1| 1| BRLEZ    | Branch on Register Less Than or Equal to Zero                       |
    -- | 0| 1| 1| 0| 0| BRLBS    | Branch if Register Low Bit is Set                                   |
    -- | 0| 1| 1| 0| 1| BRNZ     | Branch on Register Not Zero                                         |
    -- | 0| 1| 1| 1| 0| BRGZ     | Branch on Register Greater Than Zero                                |
    -- | 0| 1| 1| 1| 1| BRGEZ    | Branch on Register Greater Than or Equal to Zero                    |
    -- +--+--+--+--+--+----------+---------------------------------------------------------------------+
    -- | 1| 0|        -          | -                                                                   |
    -- +-----+--------+----------+---------------------------------------------------------------------+
    -- | 1| 1|        -          | -                                                                   |
    -- +-----+--------+----------+---------------------------------------------------------------------+

    signal op3_sig          : std_logic_vector( 5 downto 0);
    -- fmt=2, op3<5>=0
    -- +--+--+--+--+--+----------+-------------------------------+--+--+--+--+--+----------+-------------------------------------+
    -- |   op3<4:0>   | Mnemonic |                               |   op3<4:0>   | Mnemonic |                                     |
    -- +--+--+--+--+--+----------+-------------------------------+--+--+--+--+--+----------+-------------------------------------+
    -- | 0| 0| 0| 0| 0| ADD      | Add                           | 1| 0| 0| 0| 0| -        |                                     |
    -- | 0| 0| 0| 0| 1| AND      | And                           | 1| 0| 0| 0| 1| SLL      | Shift left Logical                  |
    -- | 0| 0| 0| 1| 0| OR       | Inclusive-or                  | 1| 0| 0| 1| 0| SRL      | Shift right logical                 |
    -- | 0| 0| 0| 1| 1| XOR      | Exclusive-or                  | 1| 0| 0| 1| 1| SRA      | Shift right arithmetic              |
    -- | 0| 0| 1| 0| 0| SUB      | Subtract                      | 1| 0| 1| 0| 0| SEXTB    | Signed extended byte                |
    -- | 0| 0| 1| 0| 1| ANDN     | And not                       | 1| 0| 1| 0| 1| SEXTH    | Signed extended half word           |
    -- | 0| 0| 1| 1| 0| ORN      | Inclusive-or not              | 1| 0| 1| 1| 0| -        |                                     |
    -- | 0| 0| 1| 1| 1| XNOR     | Exclusive-nor                 | 1| 0| 1| 1| 1| -        |                                     |
    -- +--+--+--+--+--+----------+-------------------------------+--+--+--+--+--+----------+-------------------------------------+
    -- | 0| 1| 0| 0| 0| MUL      | Multiply 32-bit integer       | 1| 1| 0| 0| 0| CMPEQ    | Compare equal                       |
    -- | 0| 1| 0| 0| 1| UMULH    | Unsigned multiply 32-bit high | 1| 1| 0| 0| 1| -        |                                     |
    -- | 0| 1| 0| 1| 0| -        |                               | 1| 1| 0| 1| 0| CMPLT    | Compare less than                   |
    -- | 0| 1| 0| 1| 1| -        |                               | 1| 1| 0| 1| 1| CMPLE    | Compare signed less than or equal   |
    -- | 0| 1| 1| 0| 0| -        |                               | 1| 1| 1| 0| 0| CMPNEQ   | Compare signed not equal            |
    -- | 0| 1| 1| 0| 1| -        |                               | 1| 1| 1| 0| 1| -        |                                     |
    -- | 0| 1| 1| 1| 0| -        |                               | 1| 1| 1| 1| 0| CMPLTU   | Compare unsigned less than          |
    -- | 0| 1| 1| 1| 1| -        |                               | 1| 1| 1| 1| 1| CMPLEU   | Compare unsigned less than or equal |
    -- +--+--+--+--+--+----------+-------------------------------+--+--+--+--+--+----------+-------------------------------------+
    --
    -- fmt=3, op3<5>=0
    -- +--+--+--+--+--+----------+-------------------------------+--+--+--+--+--+----------+-------------------------------------+
    -- |   op3<4:0>   | Mnemonic |                               |   op3<4:0>   | Mnemonic |                                     |
    -- +--+--+--+--+--+----------+-------------------------------+--+--+--+--+--+----------+-------------------------------------+
    -- | 0| 0| 0| 0| 0| LDUB     | Load unsigned byte            | 1| 0| 0| 0| 0| JMPL     | Jump and link                       |
    -- | 0| 0| 0| 0| 1| LDUH     | Load unsigned half word       | 1| 0| 0| 0| 1| RETT     | Return from trap                    |
    -- | 0| 0| 0| 1| 0| LD       | Load                          | 1| 0| 0| 1| 0| -        |                                     |
    -- | 0| 0| 0| 1| 1| -        |                               | 1| 0| 0| 1| 1| -        |                                     |
    -- | 0| 0| 1| 0| 0| LDSB     | Load signed byte              | 1| 0| 1| 0| 0| PRRD†    | Read processor register             |
    -- | 0| 0| 1| 0| 1| LDSH     | Load signed half word         | 1| 0| 1| 0| 1| PRWR†    | Write processor register            |
    -- | 0| 0| 1| 1| 0| -        |                               | 1| 0| 1| 1| 0| ET_W†    | Write enable trap                   |
    -- | 0| 0| 1| 1| 1| -        |                               | 1| 0| 1| 1| 1| PIL_W†   | Write Processor Interrupt Level     |
    -- +--+--+--+--+--+----------+-------------------------------+--+--+--+--+--+----------+-------------------------------------+
    -- | 0| 1| 0| 0| 0| STB      | Store byte                    | 1| 1| 0| 0| 0| -        |                                     |
    -- | 0| 1| 0| 0| 1| STH      | Store helf word               | 1| 1| 0| 0| 1| -        |                                     |
    -- | 0| 1| 0| 1| 0| ST       | Store                         | 1| 1| 0| 1| 0| -        |                                     |
    -- | 0| 1| 0| 1| 1| -        |                               | 1| 1| 0| 1| 1| -        |                                     |
    -- | 0| 1| 1| 0| 0| -        |                               | 1| 1| 1| 0| 0| -        |                                     |
    -- | 0| 1| 1| 0| 1| -        |                               | 1| 1| 1| 0| 1| -        |                                     |
    -- | 0| 1| 1| 1| 0| -        |                               | 1| 1| 1| 1| 0| -        |                                     |
    -- | 0| 1| 1| 1| 1| -        |                               | 1| 1| 1| 1| 1| -        |                                     |
    -- +--+--+--+--+--+----------+-------------------------------+--+--+--+--+--+----------+-------------------------------------+

    -- fmt=3, op3<5>=1
    -- +--+--+--+--+--+----------+-------------------------------+--+--+--+--+--+----------+-------------------------------------+
    -- |   op3<4:0>   | Mnemonic |                               |   op3<4:0>   | Mnemonic |                                     |
    -- +--+--+--+--+--+----------+-------------------------------+--+--+--+--+--+----------+-------------------------------------+
    -- | 0| 0| 0| 0| 0| LDUBA†   | Load unsigned byte            | 1| 0| 0| 0| 0| -        |                                     |
    -- | 0| 0| 0| 0| 1| LDUHA†   | Load unsigned half word       | 1| 0| 0| 0| 1| -        |                                     |
    -- | 0| 0| 0| 1| 0| LDA†     | Load                          | 1| 0| 0| 1| 0| -        |                                     |
    -- | 0| 0| 0| 1| 1| -        |                               | 1| 0| 0| 1| 1| -        |                                     |
    -- | 0| 0| 1| 0| 0| LDSBA†   | Load signed byte              | 1| 0| 1| 0| 0| -        |                                     |
    -- | 0| 0| 1| 0| 1| LDSHA†   | Load signed half word         | 1| 0| 1| 0| 1| -        |                                     |
    -- | 0| 0| 1| 1| 0| -        |                               | 1| 0| 1| 1| 0| -        |                                     |
    -- | 0| 0| 1| 1| 1| -        |                               | 1| 0| 1| 1| 1| -        |                                     |
    -- +--+--+--+--+--+----------+-------------------------------+--+--+--+--+--+----------+-------------------------------------+
    -- | 0| 1| 0| 0| 0| STBA†    | Store byte                    | 1| 1| 0| 0| 0| -        |                                     |
    -- | 0| 1| 0| 0| 1| STHA†    | Store helf word               | 1| 1| 0| 0| 1| -        |                                     |
    -- | 0| 1| 0| 1| 0| STA†     | Store                         | 1| 1| 0| 1| 0| -        |                                     |
    -- | 0| 1| 0| 1| 1| -        |                               | 1| 1| 0| 1| 1| -        |                                     |
    -- | 0| 1| 1| 0| 0| -        |                               | 1| 1| 1| 0| 0| -        |                                     |
    -- | 0| 1| 1| 0| 1| -        |                               | 1| 1| 1| 0| 1| -        |                                     |
    -- | 0| 1| 1| 1| 0| -        |                               | 1| 1| 1| 1| 0| -        |                                     |
    -- | 0| 1| 1| 1| 1| -        |                               | 1| 1| 1| 1| 1| -        |                                     |
    -- +--+--+--+--+--+----------+-------------------------------+--+--+--+--+--+----------+-------------------------------------+
    --
    -- † Privileged instruction

    signal rd_sig           : std_logic_vector( 4 downto 0);
    signal rs1_sig          : std_logic_vector( 4 downto 0);
    signal rs2_sig          : std_logic_vector( 4 downto 0);
    signal rs3_sig          : std_logic_vector( 4 downto 0);

    signal disp19_sig       : std_logic_vector(18 downto 0);

    signal sethi_sig        : std_logic_vector(22 downto 0);

    signal imm_sel_sig      : std_logic;
    signal imm_data_sig     : std_logic_vector(12 downto 0);

    signal cs_sig           : std_logic_vector( 3 downto 0);
    signal iufmt0dec_cs_sig : std_logic;
    signal iufmt1dec_cs_sig : std_logic;
    signal iufmt2dec_cs_sig : std_logic;
    signal iufmt3dec_cs_sig : std_logic;

    signal iufmt0dec_do_sig : st_iuctrl_if;
    signal iufmt1dec_do_sig : st_iuctrl_if;
    signal iufmt2dec_do_sig : st_iuctrl_if;
    signal iufmt3dec_do_sig : st_iuctrl_if;
    signal iuintrdec_do_sig : st_iuctrl_if;

begin

    op_sig       <= iuctrl_inst_in(31 downto 30);
    rd_sig       <= iuctrl_inst_in(29 downto 25);
    op3_sig      <= iuctrl_inst_in(24 downto 19);
    rs1_sig      <= iuctrl_inst_in(18 downto 14);
    disp19_sig   <= iuctrl_inst_in(29 downto 14) & iuctrl_inst_in( 2 downto  0);
    imm_sel_sig  <= iuctrl_inst_in(13);
    imm_data_sig <= iuctrl_inst_in(12 downto  0);
    cond_sig     <= iuctrl_inst_in(12 downto 10);
    rs3_sig      <= iuctrl_inst_in( 9 downto  5);
    op2_sig      <= iuctrl_inst_in( 4 downto  3);
    rs2_sig      <= iuctrl_inst_in( 4 downto  0);

    sethi_sig    <= iuctrl_inst_in(29 downto 10) & iuctrl_inst_in( 2 downto  0);

    with op_sig select
    cs_sig <= "0001" when IUCTRL_OP_BRPR,
              "0010" when IUCTRL_OP_CALL,
              "0100" when IUCTRL_OP_ARTH,
              "1000" when others;
    iufmt0dec_cs_sig <= cs_sig(0) and (not iuctrl_intr_in);
    iufmt1dec_cs_sig <= cs_sig(1) and (not iuctrl_intr_in);
    iufmt2dec_cs_sig <= cs_sig(2) and (not iuctrl_intr_in);
    iufmt3dec_cs_sig <= cs_sig(3) and (not iuctrl_intr_in);

    -----------------------------------------------------------
    -- IU Format0 Decoder                                    --
    -----------------------------------------------------------
    IU_Format0_Decoder : iufmt0dec
    port map (
        iufmt0dec_cs_in      => iufmt0dec_cs_sig,
        iufmt0dec_op2_in     => op2_sig,
        iufmt0dec_rs3_sel_in => rs3_sig,
        iufmt0dec_cond_in    => cond_sig,
        iufmt0dec_token_in   => iuctrl_token_in,
        iufmt0dec_sethi_in   => sethi_sig,
        iufmt0dec_disp19_in  => disp19_sig,
        iufmt0dec_do_out     => iufmt0dec_do_sig
    );

    -----------------------------------------------------------
    -- IU Format1 Decoder                                    --
    -----------------------------------------------------------
    IU_Format1_Decoder : iufmt1dec
    port map (
        iufmt1dec_cs_in  => iufmt1dec_cs_sig,
        iufmt1dec_do_out => iufmt1dec_do_sig
    );

    -----------------------------------------------------------
    -- IU Format2 Decoder                                    --
    -----------------------------------------------------------
    IU_Format2_Decoder : iufmt2dec
    port map (
        iufmt2dec_cs_in       => iufmt2dec_cs_sig,
        iufmt2dec_op3_in      => op3_sig,
        iufmt2dec_rd_sel_in   => rd_sig,
        iufmt2dec_rs1_sel_in  => rs1_sig,
        iufmt2dec_rs2_sel_in  => rs2_sig,
        iufmt2dec_imm_sel_in  => imm_sel_sig,
        iufmt2dec_imm_data_in => imm_data_sig,
        iufmt2dec_do_out      => iufmt2dec_do_sig
    );

    -----------------------------------------------------------
    -- IU Format3 Decoder                                    --
    -----------------------------------------------------------
    IU_Format3_Decoder : iufmt3dec
    port map (
        iufmt3dec_cs_in       => iufmt3dec_cs_sig,
        iufmt3dec_op3_in      => op3_sig,
        iufmt3dec_rd_sel_in   => rd_sig,
        iufmt3dec_rs1_sel_in  => rs1_sig,
        iufmt3dec_rs2_sel_in  => rs2_sig,
        iufmt3dec_imm_sel_in  => imm_sel_sig,
        iufmt3dec_imm_data_in => imm_data_sig,
        iufmt3dec_do_out      => iufmt3dec_do_sig
    );

    -----------------------------------------------------------
    -- IU Interrupt Decoder                                  --
    -----------------------------------------------------------
    IU_Interrupt_Decoder : iuintrdec
    port map (
        iuintrdec_cs_in  => iuctrl_intr_in,
        iuintrdec_di_in  => iuctrl_inst_in(8 downto 0),
        iuintrdec_do_out => iuintrdec_do_sig
    );

    iuctrl_do_out.rs1_sel   <= iufmt0dec_do_sig.rs1_sel
                            or iufmt1dec_do_sig.rs1_sel
                            or iufmt2dec_do_sig.rs1_sel
                            or iufmt3dec_do_sig.rs1_sel
                            or iuintrdec_do_sig.rs1_sel;

    iuctrl_do_out.rs2_sel   <= iufmt0dec_do_sig.rs2_sel
                            or iufmt1dec_do_sig.rs2_sel
                            or iufmt2dec_do_sig.rs2_sel
                            or iufmt3dec_do_sig.rs2_sel
                            or iuintrdec_do_sig.rs2_sel;

    iuctrl_do_out.rs3_sel   <= iufmt0dec_do_sig.rs3_sel
                            or iufmt1dec_do_sig.rs3_sel
                            or iufmt2dec_do_sig.rs3_sel
                            or iufmt3dec_do_sig.rs3_sel
                            or iuintrdec_do_sig.rs3_sel;

    iuctrl_do_out.imm_data  <= iufmt0dec_do_sig.imm_data
                            or iufmt1dec_do_sig.imm_data
                            or iufmt2dec_do_sig.imm_data
                            or iufmt3dec_do_sig.imm_data
                            or iuintrdec_do_sig.imm_data;

    iuctrl_do_out.sethi     <= iufmt0dec_do_sig.sethi
                            or iufmt1dec_do_sig.sethi
                            or iufmt2dec_do_sig.sethi
                            or iufmt3dec_do_sig.sethi
                            or iuintrdec_do_sig.sethi;

    iuctrl_do_out.disp19    <= iufmt0dec_do_sig.disp19
                            or iufmt1dec_do_sig.disp19
                            or iufmt2dec_do_sig.disp19
                            or iufmt3dec_do_sig.disp19
                            or iuintrdec_do_sig.disp19;

    iuctrl_do_out.opecode   <= iufmt0dec_do_sig.opecode
                            or iufmt1dec_do_sig.opecode
                            or iufmt2dec_do_sig.opecode
                            or iufmt3dec_do_sig.opecode
                            or iuintrdec_do_sig.opecode;

    iuctrl_do_out.cond_cs   <= iufmt0dec_do_sig.cond_cs
                            or iufmt1dec_do_sig.cond_cs
                            or iufmt2dec_do_sig.cond_cs
                            or iufmt3dec_do_sig.cond_cs
                            or iuintrdec_do_sig.cond_cs;

    iuctrl_do_out.cond      <= iufmt0dec_do_sig.cond
                            or iufmt1dec_do_sig.cond
                            or iufmt2dec_do_sig.cond
                            or iufmt3dec_do_sig.cond
                            or iuintrdec_do_sig.cond;

    iuctrl_do_out.alu_cs    <= iufmt0dec_do_sig.alu_cs
                            or iufmt1dec_do_sig.alu_cs
                            or iufmt2dec_do_sig.alu_cs
                            or iufmt3dec_do_sig.alu_cs
                            or iuintrdec_do_sig.alu_cs;

    iuctrl_do_out.mul_cs    <= iufmt0dec_do_sig.mul_cs
                            or iufmt1dec_do_sig.mul_cs
                            or iufmt2dec_do_sig.mul_cs
                            or iufmt3dec_do_sig.mul_cs
                            or iuintrdec_do_sig.mul_cs;

    iuctrl_do_out.sft_cs    <= iufmt0dec_do_sig.sft_cs
                            or iufmt1dec_do_sig.sft_cs
                            or iufmt2dec_do_sig.sft_cs
                            or iufmt3dec_do_sig.sft_cs
                            or iuintrdec_do_sig.sft_cs;

    iuctrl_do_out.cmp_cs    <= iufmt0dec_do_sig.cmp_cs
                            or iufmt1dec_do_sig.cmp_cs
                            or iufmt2dec_do_sig.cmp_cs
                            or iufmt3dec_do_sig.cmp_cs
                            or iuintrdec_do_sig.cmp_cs;

    iuctrl_do_out.rd_we     <= iufmt0dec_do_sig.rd_we
                            or iufmt1dec_do_sig.rd_we
                            or iufmt2dec_do_sig.rd_we
                            or iufmt3dec_do_sig.rd_we
                            or iuintrdec_do_sig.rd_we;

    iuctrl_do_out.rd_sel    <= iufmt0dec_do_sig.rd_sel
                            or iufmt1dec_do_sig.rd_sel
                            or iufmt2dec_do_sig.rd_sel
                            or iufmt3dec_do_sig.rd_sel
                            or iuintrdec_do_sig.rd_sel;

    iuctrl_do_out.branch    <= iufmt0dec_do_sig.branch
                            or iufmt1dec_do_sig.branch
                            or iufmt2dec_do_sig.branch
                            or iufmt3dec_do_sig.branch
                            or iuintrdec_do_sig.branch;

    iuctrl_do_out.rett      <= iufmt0dec_do_sig.rett
                            or iufmt1dec_do_sig.rett
                            or iufmt2dec_do_sig.rett
                            or iufmt3dec_do_sig.rett
                            or iuintrdec_do_sig.rett;

    iuctrl_do_out.psr_read  <= iufmt0dec_do_sig.psr_read
                            or iufmt1dec_do_sig.psr_read
                            or iufmt2dec_do_sig.psr_read
                            or iufmt3dec_do_sig.psr_read
                            or iuintrdec_do_sig.psr_read;

    iuctrl_do_out.s_we      <= iufmt0dec_do_sig.s_we
                            or iufmt1dec_do_sig.s_we
                            or iufmt2dec_do_sig.s_we
                            or iufmt3dec_do_sig.s_we
                            or iuintrdec_do_sig.s_we;

    iuctrl_do_out.et_we     <= iufmt0dec_do_sig.et_we
                            or iufmt1dec_do_sig.et_we
                            or iufmt2dec_do_sig.et_we
                            or iufmt3dec_do_sig.et_we
                            or iuintrdec_do_sig.et_we;

    iuctrl_do_out.pil_we    <= iufmt0dec_do_sig.pil_we
                            or iufmt1dec_do_sig.pil_we
                            or iufmt2dec_do_sig.pil_we
                            or iufmt3dec_do_sig.pil_we
                            or iuintrdec_do_sig.pil_we;

    iuctrl_do_out.mem_read  <= iufmt0dec_do_sig.mem_read
                            or iufmt1dec_do_sig.mem_read
                            or iufmt2dec_do_sig.mem_read
                            or iufmt3dec_do_sig.mem_read
                            or iuintrdec_do_sig.mem_read;

    iuctrl_do_out.mem_write <= iufmt0dec_do_sig.mem_write
                            or iufmt1dec_do_sig.mem_write
                            or iufmt2dec_do_sig.mem_write
                            or iufmt3dec_do_sig.mem_write
                            or iuintrdec_do_sig.mem_write;

    iuctrl_do_out.mem_sign  <= iufmt0dec_do_sig.mem_sign
                            or iufmt1dec_do_sig.mem_sign
                            or iufmt2dec_do_sig.mem_sign
                            or iufmt3dec_do_sig.mem_sign
                            or iuintrdec_do_sig.mem_sign;

    iuctrl_do_out.mem_type  <= iufmt0dec_do_sig.mem_type
                            or iufmt1dec_do_sig.mem_type
                            or iufmt2dec_do_sig.mem_type
                            or iufmt3dec_do_sig.mem_type
                            or iuintrdec_do_sig.mem_type;

    iuctrl_do_out.inst_a    <= iufmt0dec_do_sig.inst_a
                            or iufmt1dec_do_sig.inst_a
                            or iufmt2dec_do_sig.inst_a
                            or iufmt3dec_do_sig.inst_a
                            or iuintrdec_do_sig.inst_a;

    iuctrl_do_out.unimp     <= iufmt0dec_do_sig.unimp
                            or iufmt1dec_do_sig.unimp
                            or iufmt2dec_do_sig.unimp
                            or iufmt3dec_do_sig.unimp
                            or iuintrdec_do_sig.unimp;

end rtl;
