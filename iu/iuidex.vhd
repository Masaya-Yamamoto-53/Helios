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

use work.iuidex_pac.all;

entity iuidex is
    port (
        iuidex_clk_in   : in    std_logic;
        iuidex_rst_in   : in    std_logic;
        iuidex_wen_in   : in    std_logic;
        iuidex_flash_in : in    std_logic;
        iuidex_di_in    : in    st_iuidex_if;
        iuidex_do_out   :   out st_iuidex_if
    );
end iuidex;

architecture rtl of iuidex is

    signal iuidex_reg : st_iuidex_if := st_iuidex_if_INIT;

begin

    -----------------------------------------------------------
    -- IU ID/EX Pipeline Register with Reset                 --
    -----------------------------------------------------------
    IDEX_Pipeline_Register_with_Reset : process (
        iuidex_clk_in,
        iuidex_rst_in,
        iuidex_wen_in,
        iuidex_flash_in,
        iuidex_di_in
    )
    begin
        if (iuidex_clk_in'event and iuidex_clk_in = '1') then
            if ((iuidex_rst_in = '1') or (iuidex_flash_in = '1')) then
                iuidex_reg.cond_cs   <= st_iuidex_if_INIT.cond_cs;
                iuidex_reg.alu_cs    <= st_iuidex_if_INIT.alu_cs;
                iuidex_reg.mul_cs    <= st_iuidex_if_INIT.mul_cs;
                iuidex_reg.sft_cs    <= st_iuidex_if_INIT.sft_cs;
                iuidex_reg.cmp_cs    <= st_iuidex_if_INIT.cmp_cs;
                iuidex_reg.rd_we     <= st_iuidex_if_INIT.rd_we;
                iuidex_reg.intr_req  <= st_iuidex_if_INIT.intr_req;
                iuidex_reg.token     <= st_iuidex_if_INIT.token;
                iuidex_reg.branch    <= st_iuidex_if_INIT.branch;
                iuidex_reg.rett      <= st_iuidex_if_INIT.rett;
                iuidex_reg.psr_read  <= st_iuidex_if_INIT.psr_read;
                iuidex_reg.s_we      <= st_iuidex_if_INIT.s_we;
                iuidex_reg.et_we     <= st_iuidex_if_INIT.et_we;
                iuidex_reg.pil_we    <= st_iuidex_if_INIT.pil_we;
                iuidex_reg.mem_read  <= st_iuidex_if_INIT.mem_read;
                iuidex_reg.mem_write <= st_iuidex_if_INIT.mem_write;
                iuidex_reg.inst_a    <= st_iuidex_if_INIT.inst_a;
                iuidex_reg.unimp     <= st_iuidex_if_INIT.unimp;
            else
                if (iuidex_wen_in = '0') then
                    iuidex_reg.cond_cs   <= iuidex_di_in.cond_cs;
                    iuidex_reg.alu_cs    <= iuidex_di_in.alu_cs;
                    iuidex_reg.mul_cs    <= iuidex_di_in.mul_cs;
                    iuidex_reg.sft_cs    <= iuidex_di_in.sft_cs;
                    iuidex_reg.cmp_cs    <= iuidex_di_in.cmp_cs;
                    iuidex_reg.rd_we     <= iuidex_di_in.rd_we;
                    iuidex_reg.intr_req  <= iuidex_di_in.intr_req;
                    iuidex_reg.token     <= iuidex_di_in.token;
                    iuidex_reg.branch    <= iuidex_di_in.branch;
                    iuidex_reg.rett      <= iuidex_di_in.rett;
                    iuidex_reg.psr_read  <= iuidex_di_in.psr_read;
                    iuidex_reg.s_we      <= iuidex_di_in.s_we;
                    iuidex_reg.et_we     <= iuidex_di_in.et_we;
                    iuidex_reg.pil_we    <= iuidex_di_in.pil_we;
                    iuidex_reg.mem_read  <= iuidex_di_in.mem_read;
                    iuidex_reg.mem_write <= iuidex_di_in.mem_write;
                    iuidex_reg.inst_a    <= iuidex_di_in.inst_a;
                    iuidex_reg.unimp     <= iuidex_di_in.unimp;
                end if;
            end if;
        end if;
    end process IDEX_Pipeline_Register_with_Reset;

    -----------------------------------------------------------
    -- IU ID/EX Pipeline Register without Reset              --
    -----------------------------------------------------------
    IDEX_Pipeline_Register_without_Reset : process (
        iuidex_clk_in,
        iuidex_wen_in,
        iuidex_di_in
    )
    begin
        if (iuidex_clk_in'event and iuidex_clk_in = '1') then
            if (iuidex_wen_in = '0') then
                iuidex_reg.rs1_data <= iuidex_di_in.rs1_data;
                iuidex_reg.rs1_fw   <= iuidex_di_in.rs1_fw;
                iuidex_reg.rs2_data <= iuidex_di_in.rs2_data;
                iuidex_reg.rs2_fw   <= iuidex_di_in.rs2_fw;
                iuidex_reg.rs3_data <= iuidex_di_in.rs3_data;
                iuidex_reg.rs3_fw   <= iuidex_di_in.rs3_fw;
                iuidex_reg.opecode  <= iuidex_di_in.opecode;
                iuidex_reg.cond     <= iuidex_di_in.cond;
                iuidex_reg.rd_sel   <= iuidex_di_in.rd_sel;
                iuidex_reg.pc       <= iuidex_di_in.pc;
                iuidex_reg.mem_sign <= iuidex_di_in.mem_sign;
                iuidex_reg.mem_type <= iuidex_di_in.mem_type;
            end if;
        end if;
    end process IDEX_Pipeline_Register_without_Reset;

    iuidex_do_out <= iuidex_reg;

end rtl;
