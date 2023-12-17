--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Interruption Decode
-- Description:
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iuctrl_pac.all;
use work.iurf_pac.all;
use work.iualu_pac.all;
use work.iuldst_pac.all;

entity iuintrdec is
    port (
        iuintrdec_cs_in  : in    std_logic;
        iuintrdec_di_in  : in    std_logic_vector(8 downto 0);
        iuintrdec_do_out :   out st_iuctrl_if
    );
end iuintrdec;

architecture rtl of iuintrdec is

    constant INTR_PHASE0 : std_logic_vector(2 downto 0) := "000";
    constant INTR_PHASE1 : std_logic_vector(2 downto 0) := "001";
    constant INTR_PHASE2 : std_logic_vector(2 downto 0) := "010";
    constant INTR_PHASE3 : std_logic_vector(2 downto 0) := "011";
    constant INTR_PHASE4 : std_logic_vector(2 downto 0) := "100";

    signal phase_sig : std_logic_vector(2 downto 0);
    signal rett_sig  : std_logic;
    signal excep_sig : std_logic;
    signal irl_sig   : std_logic_vector(3 downto 0);

begin

    phase_sig <= iuintrdec_di_in(2 downto 0);
    rett_sig  <= iuintrdec_di_in(3);
    excep_sig <= iuintrdec_di_in(4);
    irl_sig   <= iuintrdec_di_in(8 downto 5);

    IU_Interrupt_Decoder : process (
        iuintrdec_cs_in,
        phase_sig,
        rett_sig,
        excep_sig,
        irl_sig
    )
    begin
        if (iuintrdec_cs_in = '0') then
            iuintrdec_do_out <= st_iuctrl_if_INIT;
        else
            if    (phase_sig = INTR_PHASE0) then
                iuintrdec_do_out <= st_iuctrl_if_INIT;
            elsif (rett_sig = '0') then
                case phase_sig is
                    when INTR_PHASE1 =>
                        iuintrdec_do_out.rs1_sel    <= IURF_R_SP;
                        iuintrdec_do_out.rs2_sel    <= (others => '0');
                        iuintrdec_do_out.rs3_sel    <= (others => '0');
                        iuintrdec_do_out.imm_data   <= "1" & X"FF8";
                    when INTR_PHASE2 =>
                        iuintrdec_do_out.rs1_sel    <= IURF_R_SP;
                        iuintrdec_do_out.rs2_sel    <= (others => '0');
                        iuintrdec_do_out.rs3_sel    <= (others => '0');
                        iuintrdec_do_out.imm_data   <= "0" & X"000";
                    when INTR_PHASE3 =>
                        iuintrdec_do_out.rs1_sel    <= IURF_R_SP;
                        iuintrdec_do_out.rs2_sel    <= (others => '0');
                        iuintrdec_do_out.rs3_sel    <= IURF_R_PC;
                        iuintrdec_do_out.imm_data   <= "0" & X"004";
                    when INTR_PHASE4 =>
                        iuintrdec_do_out.rs1_sel    <= (others => '0');
                        iuintrdec_do_out.rs2_sel    <= (others => '0');
                        iuintrdec_do_out.rs3_sel    <= (others => '0');
                        if (excep_sig = '0') then
                            iuintrdec_do_out.imm_data   <= X"0" & "000"
                                                           & '1' -- s
                                                           & '0' -- et
                                                           & irl_sig;
                        else
                            iuintrdec_do_out.imm_data   <= X"0" & "000"
                                                           & '1' -- s
                                                           & '0' -- et
                                                           & "0000";
                        end if;
                    when others =>
                        iuintrdec_do_out.rs1_sel    <= (others => '0');
                        iuintrdec_do_out.rs2_sel    <= (others => '0');
                        iuintrdec_do_out.rs3_sel    <= (others => '0');
                        iuintrdec_do_out.imm_data   <= (others => '0');
                end case;

                iuintrdec_do_out.opecode    <= IUALU_OP_ADD;
                iuintrdec_do_out.cond_cs    <= '0';
                iuintrdec_do_out.cond       <= (others => '0');

                iuintrdec_do_out.alu_cs     <= '1';
                iuintrdec_do_out.mul_cs     <= '0';
                iuintrdec_do_out.sft_cs     <= '0';
                iuintrdec_do_out.cmp_cs     <= '0';

                if    (phase_sig = INTR_PHASE1) then
                    iuintrdec_do_out.rd_we      <= '1';
                    iuintrdec_do_out.rd_sel     <= IURF_R_SP;
                else
                    iuintrdec_do_out.rd_we      <= '0';
                    iuintrdec_do_out.rd_sel     <= (others => '0');
                end if;

                iuintrdec_do_out.sethi      <= (others => '0');

                iuintrdec_do_out.branch     <= '0';
                iuintrdec_do_out.rett       <= '0';
                iuintrdec_do_out.disp19     <= (others => '0');

                case phase_sig is
                    when INTR_PHASE2 =>
                        iuintrdec_do_out.psr_read   <= '1';
                        iuintrdec_do_out.s_we       <= '0';
                        iuintrdec_do_out.et_we      <= '0';
                        iuintrdec_do_out.pil_we     <= '0';
                    when INTR_PHASE4 =>
                        iuintrdec_do_out.psr_read   <= '0';
                        iuintrdec_do_out.s_we       <= '1';
                        iuintrdec_do_out.et_we      <= '1';
                        iuintrdec_do_out.pil_we     <= '1';
                    when others =>
                        iuintrdec_do_out.psr_read   <= '0';
                        iuintrdec_do_out.s_we       <= '0';
                        iuintrdec_do_out.et_we      <= '0';
                        iuintrdec_do_out.pil_we     <= '0';
                end case;

                if    (phase_sig = INTR_PHASE2)
                   or (phase_sig = INTR_PHASE3) then
                    iuintrdec_do_out.mem_read   <= '0';
                    iuintrdec_do_out.mem_write  <= '1';
                    iuintrdec_do_out.mem_sign   <= '0';
                    iuintrdec_do_out.mem_type   <= IULDST_MEM_TYPE_WORD;
                    iuintrdec_do_out.inst_a     <= '0';
                else
                    iuintrdec_do_out.mem_read   <= '0';
                    iuintrdec_do_out.mem_write  <= '0';
                    iuintrdec_do_out.mem_sign   <= '0';
                    iuintrdec_do_out.mem_type   <= (others => '0');
                    iuintrdec_do_out.inst_a     <= '0';
                end if;
                iuintrdec_do_out.unimp      <= '0';
            elsif (rett_sig = '1') then
                case phase_sig is
                    when INTR_PHASE1 =>
                        iuintrdec_do_out.rs1_sel    <= IURF_R_SP;
                        iuintrdec_do_out.rs2_sel    <= (others => '0');
                        iuintrdec_do_out.rs3_sel    <= (others => '0');
                        iuintrdec_do_out.imm_data   <= "0" & X"000";
                    when INTR_PHASE2 =>
                        iuintrdec_do_out.rs1_sel    <= IURF_R_SP;
                        iuintrdec_do_out.rs2_sel    <= (others => '0');
                        iuintrdec_do_out.rs3_sel    <= (others => '0');
                        iuintrdec_do_out.imm_data   <= "0" & X"008";
                    when INTR_PHASE3 =>
                        iuintrdec_do_out.rs1_sel    <= (others => '0');
                        iuintrdec_do_out.rs2_sel    <= (others => '0');
                        iuintrdec_do_out.rs3_sel    <= (others => '0');
                        iuintrdec_do_out.imm_data   <= "0" & X"000";
                    when INTR_PHASE4 =>
                        iuintrdec_do_out.rs1_sel    <= (others => '0');
                        iuintrdec_do_out.rs2_sel    <= (others => '0');
                        iuintrdec_do_out.rs3_sel    <= (others => '0');
                        iuintrdec_do_out.imm_data   <= "0" & X"000";
                    when others =>
                        iuintrdec_do_out.rs1_sel    <= (others => '0');
                        iuintrdec_do_out.rs2_sel    <= (others => '0');
                        iuintrdec_do_out.rs3_sel    <= (others => '0');
                        iuintrdec_do_out.imm_data   <= (others => '0');
                end case;
                iuintrdec_do_out.opecode    <= IUALU_OP_ADD;
                iuintrdec_do_out.cond_cs    <= '0';
                iuintrdec_do_out.cond       <= (others => '0');

                if    (phase_sig = INTR_PHASE1)
                   or (phase_sig = INTR_PHASE2) then
                    iuintrdec_do_out.alu_cs     <= '1';
                else
                    iuintrdec_do_out.alu_cs     <= '0';
                end if;
                iuintrdec_do_out.mul_cs     <= '0';
                iuintrdec_do_out.sft_cs     <= '0';
                iuintrdec_do_out.cmp_cs     <= '0';

                if    (phase_sig = INTR_PHASE2) then
                    iuintrdec_do_out.rd_we      <= '1';
                    iuintrdec_do_out.rd_sel     <= IURF_R_SP;
                else
                    iuintrdec_do_out.rd_we      <= '0';
                    iuintrdec_do_out.rd_sel     <= (others => '0');
                end if;

                iuintrdec_do_out.sethi      <= (others => '0');

                iuintrdec_do_out.branch     <= '0';
                iuintrdec_do_out.rett       <= '0';
                iuintrdec_do_out.disp19     <= (others => '0');

                if    (phase_sig = INTR_PHASE1) then
                    iuintrdec_do_out.psr_read   <= '0';
                    iuintrdec_do_out.s_we       <= '1';
                    iuintrdec_do_out.et_we      <= '1';
                    iuintrdec_do_out.pil_we     <= '1';
                else
                    iuintrdec_do_out.psr_read   <= '0';
                    iuintrdec_do_out.s_we       <= '0';
                    iuintrdec_do_out.et_we      <= '0';
                    iuintrdec_do_out.pil_we     <= '0';
                end if;

                if    (phase_sig = INTR_PHASE1) then
                    iuintrdec_do_out.mem_read   <= '1';
                    iuintrdec_do_out.mem_write  <= '0';
                    iuintrdec_do_out.mem_sign   <= '0';
                    iuintrdec_do_out.mem_type   <= IULDST_MEM_TYPE_WORD;
                    iuintrdec_do_out.inst_a     <= '0';
                else
                    iuintrdec_do_out.mem_read   <= '0';
                    iuintrdec_do_out.mem_write  <= '0';
                    iuintrdec_do_out.mem_sign   <= '0';
                    iuintrdec_do_out.mem_type   <= (others => '0');
                    iuintrdec_do_out.inst_a     <= '0';
                end if;
                iuintrdec_do_out.unimp      <= '0';
            else
                iuintrdec_do_out <= st_iuctrl_if_INIT;
            end if;
        end if;
    end process IU_Interrupt_Decoder;

 end rtl;
