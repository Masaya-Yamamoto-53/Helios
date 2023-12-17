--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Control
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package iuctrl_pac is

    constant IUCTRL_OP_BRPR    : std_logic_vector(1 downto 0) := "00"; -- Branch Prediction Instruction Format
    constant IUCTRL_OP_CALL    : std_logic_vector(1 downto 0) := "01"; -- Call and Link Instruction Format
    constant IUCTRL_OP_ARTH    : std_logic_vector(1 downto 0) := "10"; -- Arithmetic Instruction Format
    constant IUCTRL_OP_LDST    : std_logic_vector(1 downto 0) := "11"; -- Load/Store Instruction Format

    constant IUCTRL_OP2_SET    : std_logic_vector(1 downto 0) := "00"; -- SETHI Instuction 
    constant IUCTRL_OP2_IBR    : std_logic_vector(1 downto 0) := "01"; -- Integer Conditional Branch Instuction

    constant IUCTRL_INST_JMPL  : std_logic_vector(5 downto 0) := "010000";
    constant IUCTRL_INST_RETT  : std_logic_vector(5 downto 0) := "010001";

    constant IUCTRL_INST_PRRD  : std_logic_vector(5 downto 0) := "010100";
    constant IUCTRL_INST_PRWR  : std_logic_vector(5 downto 0) := "010101";
    constant IUCTRL_INST_ET_W  : std_logic_vector(5 downto 0) := "010110";
    constant IUCTRL_INST_PIL_W : std_logic_vector(5 downto 0) := "010111";

    -- IU Controller Interface
    type st_iuctrl_if is
    record
        rs1_sel    : std_logic_vector( 4 downto 0);
        rs2_sel    : std_logic_vector( 4 downto 0);
        rs3_sel    : std_logic_vector( 4 downto 0);

        imm_data   : std_logic_vector(12 downto 0); -- Signed 13-bit immediate data
        sethi      : std_logic_vector(22 downto 0);
        disp19     : std_logic_vector(18 downto 0);

        opecode    : std_logic_vector( 2 downto 0);

        cond_cs    : std_logic;
        cond       : std_logic_vector( 2 downto 0);

        alu_cs     : std_logic;
        mul_cs     : std_logic;
        sft_cs     : std_logic;
        cmp_cs     : std_logic;

        rd_we      : std_logic;
        rd_sel     : std_logic_vector( 4 downto 0);

        branch     : std_logic;
        rett       : std_logic;

        psr_read   : std_logic;
        s_we       : std_logic;
        et_we      : std_logic;
        pil_we     : std_logic;

        mem_read   : std_logic;
        mem_write  : std_logic;
        mem_sign   : std_logic;
        mem_type   : std_logic_vector( 1 downto 0);
        inst_a     : std_logic;

        unimp      : std_logic;
    end record;
    constant st_iuctrl_if_INIT : st_iuctrl_if := (
        (others => '0'), -- rs1_sel
        (others => '0'), -- rs2_sel
        (others => '0'), -- rs3_sel
        (others => '0'), -- imm_data
        (others => '0'), -- sethi
        (others => '0'), -- disp19
        (others => '0'), -- opecode
        '0',             -- cond_cs
        (others => '0'), -- cond
        '0',             -- alu_cs
        '0',             -- mul_cs
        '0',             -- sft_cs
        '0',             -- cmp_cs
        '0',             -- rd_we
        (others => '0'), -- rd_sel
        '0',             -- branch
        '0',             -- rett
        '0',             -- psr_read
        '0',             -- s_we
        '0',             -- et_we
        '0',             -- pil_we
        '0',             -- mem_read
        '0',             -- mem_write
        '0',             -- mem_sign
        (others => '0'), -- mem_type
        '0',             -- inst_a
        '0'              -- unimp
    );
    constant st_iuctrl_if_ERR : st_iuctrl_if := (
        (others => '0'), -- rs1_sel
        (others => '0'), -- rs2_sel
        (others => '0'), -- rs3_sel
        (others => '0'), -- imm_data
        (others => '0'), -- sethi
        (others => '0'), -- disp19
        (others => '0'), -- opecode
        '0',             -- cond_cs
        (others => '0'), -- cond
        '0',             -- alu_cs
        '0',             -- mul_cs
        '0',             -- sft_cs
        '0',             -- cmp_cs
        '0',             -- rd_we
        (others => '0'), -- rd_sel
        '0',             -- branch
        '0',             -- rett
        '0',             -- psr_read
        '0',             -- s_we
        '0',             -- et_we
        '0',             -- pil_we
        '0',             -- mem_read
        '0',             -- mem_write
        '0',             -- mem_sign
        (others => '0'), -- mem_type
        '0',             -- inst_a
        '1'              -- unimp
    );

    type array_st_iuctrl_if is array (0 to 1) of st_iuctrl_if;

    component iuctrl
        port (
            iuctrl_intr_in  : in    std_logic;
            iuctrl_inst_in  : in    std_logic_vector(31 downto 0);
            iuctrl_token_in : in    std_logic;
            iuctrl_do_out   :   out st_iuctrl_if
        );
    end component;

end iuctrl_pac;

-- package body iuctrl_pac is
-- end iuctrl_pac;
