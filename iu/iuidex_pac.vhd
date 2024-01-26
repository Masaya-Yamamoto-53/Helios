--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU ID/EX Pipeline Register
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package iuidex_pac is

    type st_iuidex_if is
    record
        rs1_data  : std_logic_vector(31 downto 0);
        rs1_fw    : std_logic_vector( 1 downto 0);
        rs2_data  : std_logic_vector(31 downto 0);
        rs2_fw    : std_logic_vector( 1 downto 0);
        rs3_data  : std_logic_vector(31 downto 0);
        rs3_fw    : std_logic_vector( 1 downto 0);

        opecode   : std_logic_vector( 2 downto 0);
        cond_cs   : std_logic;
        cond      : std_logic_vector( 2 downto 0);

        alu_cs    : std_logic;
        mul_cs    : std_logic;
        sft_cs    : std_logic;
        cmp_cs    : std_logic;

        rd_we     : std_logic;
        rd_sel    : std_logic_vector( 4 downto 0);

        intr_req  : std_logic;

        token     : std_logic;
        branch    : std_logic;

        pc        : std_logic_vector(29 downto 0);
        rett      : std_logic;

        psr_read  : std_logic;
        s_we      : std_logic;
        et_we     : std_logic;
        pil_we    : std_logic;

        mem_read  : std_logic;
        mem_write : std_logic;
        mem_sign  : std_logic;
        mem_type  : std_logic_vector( 1 downto 0);

        inst_a    : std_logic;
        unimp     : std_logic;
    end record;
    constant st_iuidex_if_INIT : st_iuidex_if := (
        (others => '0'), -- rs1_data
        (others => '0'), -- rs1_fw
        (others => '0'), -- rs2_data
        (others => '0'), -- rs2_fw
        (others => '0'), -- rs3_data
        (others => '0'), -- rs3_fw
        (others => '0'), -- opecode
        '0',             -- cond_cs
        (others => '0'), -- cond
        '0',             -- alu_cs
        '0',             -- mul_cs
        '0',             -- sft_cs
        '0',             -- cmp_cs
        '0',             -- rd_we
        (others => '0'), -- rd_sel
        '0',             -- intr_req
        '0',             -- token
        '0',             -- branch
        (others => '0'), -- pc
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

    component iuidex
        port (
            iuidex_clk_in   : in    std_logic;
            iuidex_rst_in   : in    std_logic;
            iuidex_wen_in   : in    std_logic;
            iuidex_flash_in : in    std_logic;
            iuidex_di_in    : in    st_iuidex_if;
            iuidex_do_out   :   out st_iuidex_if
        );
    end component;

end iuidex_pac;

-- package body iuidex_pac is
-- end iuidex_pac;
