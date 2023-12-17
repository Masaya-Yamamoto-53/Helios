--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Format 3 Decoder
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iuctrl_pac.all;
use work.iurf_pac.all;
use work.iualu_pac.all;
use work.iucond_pac.all;
use work.iuldst_pac.all;

entity iufmt3dec is
    port (
        iufmt3dec_cs_in       : in    std_logic;
        iufmt3dec_op3_in      : in    std_logic_vector( 5 downto 0);
        iufmt3dec_rd_sel_in   : in    std_logic_vector( 4 downto 0);
        iufmt3dec_rs1_sel_in  : in    std_logic_vector( 4 downto 0);
        iufmt3dec_rs2_sel_in  : in    std_logic_vector( 4 downto 0);
        iufmt3dec_imm_sel_in  : in    std_logic;
        iufmt3dec_imm_data_in : in    std_logic_vector(12 downto 0);
        iufmt3dec_do_out      :   out st_iuctrl_if
    );
end iufmt3dec;

architecture rtl of iufmt3dec is

    constant IUFMT3DEC_INST_LD   : std_logic_vector(2 downto 0) := "000";
    constant IUFMT3DEC_INST_LDA  : std_logic_vector(2 downto 0) := "100";
    constant IUFMT3DEC_INST_ST   : std_logic_vector(2 downto 0) := "001";
    constant IUFMT3DEC_INST_STA  : std_logic_vector(2 downto 0) := "101";

    constant IUFMT3DEC_INST_RETT : std_logic_vector(5 downto 3) := "010";

begin

    IU_Format3_Decoder : process (
        iufmt3dec_cs_in,
        iufmt3dec_op3_in,
        iufmt3dec_rd_sel_in,
        iufmt3dec_rs1_sel_in,
        iufmt3dec_rs2_sel_in,
        iufmt3dec_imm_sel_in,
        iufmt3dec_imm_data_in
    )
    begin
        if (iufmt3dec_cs_in = '0') then
            iufmt3dec_do_out <= st_iuctrl_if_INIT;
        else
            iufmt3dec_do_out.rs1_sel    <= iufmt3dec_rs1_sel_in;

            if (iufmt3dec_imm_sel_in = '0') then
                iufmt3dec_do_out.rs2_sel    <= iufmt3dec_rs2_sel_in;
                iufmt3dec_do_out.imm_data   <= (others => '0');
            else
                iufmt3dec_do_out.rs2_sel    <= (others => '0');
                iufmt3dec_do_out.imm_data   <= iufmt3dec_imm_data_in;
            end if;

            if   ((iufmt3dec_op3_in(5 downto 3) = IUFMT3DEC_INST_ST )
               or (iufmt3dec_op3_in(5 downto 3) = IUFMT3DEC_INST_STA)) then
                iufmt3dec_do_out.rs3_sel    <= iufmt3dec_rd_sel_in;
            else
                iufmt3dec_do_out.rs3_sel    <= (others => '0');
            end if;

            if ((iufmt3dec_op3_in(5 downto 0) = IUCTRL_INST_PRWR )
             or (iufmt3dec_op3_in(5 downto 0) = IUCTRL_INST_ET_W )
             or (iufmt3dec_op3_in(5 downto 0) = IUCTRL_INST_PIL_W)) then
                iufmt3dec_do_out.opecode    <= IUALU_OP_XOR;
            else
                iufmt3dec_do_out.opecode    <= IUALU_OP_ADD;
            end if;

            if    (iufmt3dec_op3_in(5 downto 0) = IUCTRL_INST_JMPL) then
                iufmt3dec_do_out.cond_cs    <= '1';
                iufmt3dec_do_out.cond       <= IUCOND_BRLBC;
            else
                iufmt3dec_do_out.cond_cs    <= '0';
                iufmt3dec_do_out.cond       <= (others => '0');
            end if;

            iufmt3dec_do_out.alu_cs     <= '1';
            iufmt3dec_do_out.mul_cs     <= '0';
            iufmt3dec_do_out.sft_cs     <= '0';
            iufmt3dec_do_out.cmp_cs     <= '0';

            if   ((iufmt3dec_op3_in(5 downto 3) = IUFMT3DEC_INST_LD )
               or (iufmt3dec_op3_in(5 downto 3) = IUFMT3DEC_INST_LDA)
               or (iufmt3dec_op3_in(5 downto 0) = IUCTRL_INST_JMPL  )
               or (iufmt3dec_op3_in(5 downto 0) = IUCTRL_INST_RETT  )
               or (iufmt3dec_op3_in(5 downto 0) = IUCTRL_INST_PRRD  )) then
                if (iufmt3dec_rd_sel_in = IURF_R_ZERO
                 or iufmt3dec_rd_sel_in = IURF_R_PC  ) then
                    iufmt3dec_do_out.rd_we      <= '0';
                else
                    iufmt3dec_do_out.rd_we      <= '1';
                end if;
                iufmt3dec_do_out.rd_sel     <= iufmt3dec_rd_sel_in;
            else
                iufmt3dec_do_out.rd_we      <= '0';
                iufmt3dec_do_out.rd_sel     <= (others => '0');
            end if;

            iufmt3dec_do_out.sethi      <= (others => '0');

            if    (iufmt3dec_op3_in(5 downto 0) = IUCTRL_INST_JMPL) then
                iufmt3dec_do_out.branch     <= '1';
            else
                iufmt3dec_do_out.branch     <= '0';
            end if;

            if    (iufmt3dec_op3_in(5 downto 0) = IUCTRL_INST_RETT) then
                iufmt3dec_do_out.rett       <= '1';
            else
                iufmt3dec_do_out.rett       <= '0';
            end if;

            iufmt3dec_do_out.disp19     <= (others => '0');

            case iufmt3dec_op3_in(5 downto 0) is
                when IUCTRL_INST_PRRD =>
                    iufmt3dec_do_out.psr_read   <= '1';
                    iufmt3dec_do_out.s_we       <= '0';
                    iufmt3dec_do_out.et_we      <= '0';
                    iufmt3dec_do_out.pil_we     <= '0';
                when IUCTRL_INST_PRWR =>
                    iufmt3dec_do_out.psr_read   <= '0';
                    iufmt3dec_do_out.s_we       <= '1';
                    iufmt3dec_do_out.et_we      <= '1';
                    iufmt3dec_do_out.pil_we     <= '1';
                when IUCTRL_INST_ET_W =>
                    iufmt3dec_do_out.psr_read   <= '0';
                    iufmt3dec_do_out.s_we       <= '0';
                    iufmt3dec_do_out.et_we      <= '1';
                    iufmt3dec_do_out.pil_we     <= '0';
                when IUCTRL_INST_PIL_W =>
                    iufmt3dec_do_out.psr_read   <= '0';
                    iufmt3dec_do_out.s_we       <= '0';
                    iufmt3dec_do_out.et_we      <= '0';
                    iufmt3dec_do_out.pil_we     <= '1';
                when others =>
                    iufmt3dec_do_out.psr_read   <= '0';
                    iufmt3dec_do_out.s_we       <= '0';
                    iufmt3dec_do_out.et_we      <= '0';
                    iufmt3dec_do_out.pil_we     <= '0';
            end case;

            case iufmt3dec_op3_in(5 downto 3) is
                when IUFMT3DEC_INST_LD | IUFMT3DEC_INST_LDA =>
                    iufmt3dec_do_out.mem_write  <= '0';
                    iufmt3dec_do_out.mem_read   <= '1';
                    iufmt3dec_do_out.mem_sign   <= iufmt3dec_op3_in(2);
                    iufmt3dec_do_out.mem_type   <= iufmt3dec_op3_in(1 downto 0);
                when IUFMT3DEC_INST_ST | IUFMT3DEC_INST_STA =>
                    iufmt3dec_do_out.mem_write  <= '1';
                    iufmt3dec_do_out.mem_read   <= '0';
                    iufmt3dec_do_out.mem_sign   <= '0';
                    iufmt3dec_do_out.mem_type   <= iufmt3dec_op3_in(1 downto 0);
                when IUFMT3DEC_INST_RETT =>
                    if (iufmt3dec_op3_in(2 downto 0) = IUCTRL_INST_RETT(2 downto 0)) then
                        iufmt3dec_do_out.mem_write  <= '0';
                        iufmt3dec_do_out.mem_read   <= '1';
                        iufmt3dec_do_out.mem_sign   <= '0';
                        iufmt3dec_do_out.mem_type   <= IULDST_MEM_TYPE_WORD;
                    else
                        iufmt3dec_do_out.mem_write  <= '0';
                        iufmt3dec_do_out.mem_read   <= '0';
                        iufmt3dec_do_out.mem_sign   <= '0';
                        iufmt3dec_do_out.mem_type   <= (others => '0');
                    end if;
                when others =>
                    iufmt3dec_do_out.mem_write  <= '0';
                    iufmt3dec_do_out.mem_read   <= '0';
                    iufmt3dec_do_out.mem_sign   <= '0';
                    iufmt3dec_do_out.mem_type   <= (others => '0');
            end case;

            if   ((iufmt3dec_op3_in(5 downto 0) = IUCTRL_INST_PRRD  )
               or (iufmt3dec_op3_in(5 downto 0) = IUCTRL_INST_PRWR  )
               or (iufmt3dec_op3_in(5 downto 0) = IUCTRL_INST_ET_W  )
               or (iufmt3dec_op3_in(5 downto 0) = IUCTRL_INST_PIL_W )
               or (iufmt3dec_op3_in(5 downto 3) = IUFMT3DEC_INST_LDA)
               or (iufmt3dec_op3_in(5 downto 3) = IUFMT3DEC_INST_STA)
               or (iufmt3dec_op3_in(5 downto 0) = IUCTRL_INST_RETT  )) then
                iufmt3dec_do_out.inst_a     <= '1';
            else
                iufmt3dec_do_out.inst_a     <= '0';
            end if;
            iufmt3dec_do_out.unimp      <= '0';

            if    ((iufmt3dec_op3_in(4 downto 3) = "00")
               and ((iufmt3dec_op3_in(2 downto 0) = "011")
                 or (iufmt3dec_op3_in(2 downto 0) = "110")
                 or (iufmt3dec_op3_in(2 downto 0) = "111"))) then
                iufmt3dec_do_out <= st_iuctrl_if_ERR;
            end if;
            if ((iufmt3dec_op3_in(4 downto 3) = "01")
               and ((iufmt3dec_op3_in(2 downto 0) = "011")
                 or (iufmt3dec_op3_in(2 downto 0) = "100")
                 or (iufmt3dec_op3_in(2 downto 0) = "101")
                 or (iufmt3dec_op3_in(2 downto 0) = "110")
                 or (iufmt3dec_op3_in(2 downto 0) = "111"))) then
                iufmt3dec_do_out <= st_iuctrl_if_ERR;
            end if;
            if ((iufmt3dec_op3_in(5 downto 3) = "010")
               and ((iufmt3dec_op3_in(2 downto 0) = "010")
                 or (iufmt3dec_op3_in(2 downto 0) = "011"))) then
                iufmt3dec_do_out <= st_iuctrl_if_ERR;
            end if;
            if  (iufmt3dec_op3_in(5 downto 3) = "110") then
                iufmt3dec_do_out <= st_iuctrl_if_ERR;
            end if;
            if  (iufmt3dec_op3_in(4 downto 3) = "11") then
                iufmt3dec_do_out <= st_iuctrl_if_ERR;
            end if;
        end if;
    end process IU_Format3_Decoder;

end rtl;
