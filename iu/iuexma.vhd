--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU EX/MA Pipeline Register
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.iuexma_pac.all;

entity iuexma is
    port (
        iuexma_clk_in   : in    std_logic;
        iuexma_rst_in   : in    std_logic;
        iuexma_wen_in   : in    std_logic;
        iuexma_flash_in : in    std_Logic;
        iuexma_di_in    : in    st_iuexma_if;
        iuexma_do_out   :   out st_iuexma_if
    );
end iuexma;

architecture rtl of iuexma is

    signal iuexma_reg : st_iuexma_if := st_iuexma_if_INIT;

begin

    -----------------------------------------------------------
    -- IU EX/MA Pipeline Register with Reset                 --
    -----------------------------------------------------------
    EXMA_Pipeline_Register_with_Reset : process (
        iuexma_clk_in,
        iuexma_rst_in,
        iuexma_wen_in,
        iuexma_flash_in,
        iuexma_di_in
    )
    begin
        if (iuexma_clk_in'event and iuexma_clk_in = '1') then
            if ((iuexma_rst_in = '1') or (iuexma_flash_in = '1')) then
                iuexma_reg.mul_cs    <= st_iuexma_if_INIT.mul_cs;
                iuexma_reg.rd_we     <= st_iuexma_if_INIT.rd_we;
                iuexma_reg.psr_read  <= st_iuexma_if_INIT.psr_read;
                iuexma_reg.s_we      <= st_iuexma_if_INIT.s_we;
                iuexma_reg.et_we     <= st_iuexma_if_INIT.et_we;
                iuexma_reg.pil_we    <= st_iuexma_if_INIT.pil_we;
                iuexma_reg.intr_req  <= st_iuexma_if_INIT.intr_req;
                iuexma_reg.branch    <= st_iuexma_if_INIT.branch;
                iuexma_reg.rett      <= st_iuexma_if_INIT.rett;
                iuexma_reg.mem_read  <= st_iuexma_if_INIT.mem_read;
                iuexma_reg.mem_write <= st_iuexma_if_INIT.mem_write;
                iuexma_reg.inst_a    <= st_iuexma_if_INIT.inst_a;
            else
                if (iuexma_wen_in = '0') then
                    iuexma_reg.mul_cs    <= iuexma_di_in.mul_cs;
                    iuexma_reg.rd_we     <= iuexma_di_in.rd_we;
                    iuexma_reg.psr_read  <= iuexma_di_in.psr_read;
                    iuexma_reg.s_we      <= iuexma_di_in.s_we;
                    iuexma_reg.et_we     <= iuexma_di_in.et_we;
                    iuexma_reg.pil_we    <= iuexma_di_in.pil_we;
                    iuexma_reg.intr_req  <= iuexma_di_in.intr_req;
                    iuexma_reg.branch    <= iuexma_di_in.branch;
                    iuexma_reg.rett      <= iuexma_di_in.rett;
                    iuexma_reg.mem_read  <= iuexma_di_in.mem_read;
                    iuexma_reg.mem_write <= iuexma_di_in.mem_write;
                    iuexma_reg.inst_a    <= iuexma_di_in.inst_a;
                end if;
            end if;
        end if;
    end process EXMA_Pipeline_Register_with_Reset;

    -----------------------------------------------------------
    -- IU EX/MA Pipeline Register without Reset              --
    -----------------------------------------------------------
    EXMA_Pipeline_Register_without_Reset : process (
        iuexma_clk_in,
        iuexma_wen_in,
        iuexma_di_in
    )
    begin
        if (iuexma_clk_in'event and iuexma_clk_in = '1') then
            if (iuexma_wen_in = '0') then
                iuexma_reg.rd_sel   <= iuexma_di_in.rd_sel;
                iuexma_reg.rd_data  <= iuexma_di_in.rd_data;
                iuexma_reg.pc       <= iuexma_di_in.pc;
                iuexma_reg.mem_sign <= iuexma_di_in.mem_sign;
                iuexma_reg.mem_type <= iuexma_di_in.mem_type;
                iuexma_reg.mem_data <= iuexma_di_in.mem_data;
            end if;
        end if;
    end process EXMA_Pipeline_Register_without_Reset;

    iuexma_do_out <= iuexma_reg;

end rtl;
