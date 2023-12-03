library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iuctrl_pac.all;
use work.iurf_pac.all;
use work.iusft_pac.all;
use work.iucmp_pac.all;

entity iufmt2dec is
    port (
        iufmt2dec_cs_in       : in    std_logic;
        iufmt2dec_op3_in      : in    std_logic_vector( 5 downto 0);
        iufmt2dec_rd_sel_in   : in    std_logic_vector( 4 downto 0);
        iufmt2dec_rs1_sel_in  : in    std_logic_vector( 4 downto 0);
        iufmt2dec_rs2_sel_in  : in    std_logic_vector( 4 downto 0);
        iufmt2dec_imm_sel_in  : in    std_logic;
        iufmt2dec_imm_data_in : in    std_logic_vector(12 downto 0);
        iufmt2dec_do_out      :   out st_iuctrl_if
    );
end iufmt2dec;

architecture rtl of iufmt2dec is

    constant IUFMT2DEC_INST_ALU : std_logic_vector(1 downto 0) := "00";
    constant IUFMT2DEC_INST_MUL : std_logic_vector(1 downto 0) := "01";
    constant IUFMT2DEC_INST_SFT : std_logic_vector(1 downto 0) := "10";
    constant IUFMT2DEC_INST_CMP : std_logic_vector(1 downto 0) := "11";

begin

    IU_Format2_Decoder : process (
        iufmt2dec_cs_in,
        iufmt2dec_op3_in,
        iufmt2dec_rd_sel_in,
        iufmt2dec_rs1_sel_in,
        iufmt2dec_rs2_sel_in,
        iufmt2dec_imm_sel_in,
        iufmt2dec_imm_data_in
    )
    begin
        if (iufmt2dec_cs_in = '0') then
            iufmt2dec_do_out <= st_iuctrl_if_INIT;
        else
            iufmt2dec_do_out.rs1_sel    <= iufmt2dec_rs1_sel_in;
            if (iufmt2dec_imm_sel_in = '0') then
                if ((iufmt2dec_op3_in(4 downto 3) = IUFMT2DEC_INST_SFT)
                and ((iufmt2dec_op3_in(2 downto 0) = IUSFT_OP_SEXTB)
                  or (iufmt2dec_op3_in(2 downto 0) = IUSFT_OP_SEXTH))) then
                    iufmt2dec_do_out.rs2_sel    <= (others => '0');
                    iufmt2dec_do_out.rs3_sel    <= (others => '0');
                    iufmt2dec_do_out.imm_data   <= (others => '0');
                else
                    iufmt2dec_do_out.rs2_sel    <= iufmt2dec_rs2_sel_in;
                    iufmt2dec_do_out.rs3_sel    <= (others => '0');
                    iufmt2dec_do_out.imm_data   <= (others => '0');
                end if;
            else
                if ((iufmt2dec_op3_in(4 downto 3) = IUFMT2DEC_INST_SFT)
                and ((iufmt2dec_op3_in(2 downto 0) = IUSFT_OP_SEXTB)
                  or (iufmt2dec_op3_in(2 downto 0) = IUSFT_OP_SEXTH))) then
                    iufmt2dec_do_out.rs2_sel    <= (others => '0');
                    iufmt2dec_do_out.rs3_sel    <= (others => '0');
                    iufmt2dec_do_out.imm_data   <= (others => '0');
                else
                    iufmt2dec_do_out.rs2_sel    <= (others => '0');
                    iufmt2dec_do_out.rs3_sel    <= (others => '0');
                    iufmt2dec_do_out.imm_data   <= iufmt2dec_imm_data_in;
                end if;
            end if;

            iufmt2dec_do_out.opecode    <= iufmt2dec_op3_in(2 downto 0);

            iufmt2dec_do_out.cond_cs    <= '0';
            iufmt2dec_do_out.cond       <= (others => '0');

            if    (iufmt2dec_op3_in(4 downto 3) = IUFMT2DEC_INST_ALU) then
                iufmt2dec_do_out.alu_cs     <= '1';
            else
                iufmt2dec_do_out.alu_cs     <= '0';
            end if;

            if    (iufmt2dec_op3_in(4 downto 3) = IUFMT2DEC_INST_MUL) then
                iufmt2dec_do_out.mul_cs     <= '1';
            else
                iufmt2dec_do_out.mul_cs     <= '0';
            end if;

            if    (iufmt2dec_op3_in(4 downto 3) = IUFMT2DEC_INST_SFT) then
                iufmt2dec_do_out.sft_cs     <= '1';
            else
                iufmt2dec_do_out.sft_cs     <= '0';
            end if;

            if    (iufmt2dec_op3_in(4 downto 3) = IUFMT2DEC_INST_CMP) then
                iufmt2dec_do_out.cmp_cs     <= '1';
            else
                iufmt2dec_do_out.cmp_cs     <= '0';
            end if;

            if (iufmt2dec_rd_sel_in = IURF_R_ZERO
             or iufmt2dec_rd_sel_in = IURF_R_PC  ) then
                iufmt2dec_do_out.rd_we      <= '0';
            else
                iufmt2dec_do_out.rd_we      <= '1';
            end if;

            iufmt2dec_do_out.rd_sel     <= iufmt2dec_rd_sel_in;

            iufmt2dec_do_out.sethi      <= (others => '0');

            iufmt2dec_do_out.branch     <= '0';
            iufmt2dec_do_out.rett       <= '0';
            iufmt2dec_do_out.disp19     <= (others => '0');

            iufmt2dec_do_out.psr_read   <= '0';
            iufmt2dec_do_out.s_we       <= '0';
            iufmt2dec_do_out.et_we      <= '0';
            iufmt2dec_do_out.pil_we     <= '0';

            iufmt2dec_do_out.mem_read   <= '0';
            iufmt2dec_do_out.mem_write  <= '0';
            iufmt2dec_do_out.mem_sign   <= '0';
            iufmt2dec_do_out.mem_type   <= (others => '0');
            iufmt2dec_do_out.inst_a     <= '0';

            iufmt2dec_do_out.unimp      <= '0';

            if    ((iufmt2dec_op3_in(4 downto 3) = IUFMT2DEC_INST_MUL)
              and ((iufmt2dec_op3_in(2 downto 0) = "010")
                or (iufmt2dec_op3_in(2 downto 0) = "011")
                or (iufmt2dec_op3_in(2 downto 0) = "100")
                or (iufmt2dec_op3_in(2 downto 0) = "101")
                or (iufmt2dec_op3_in(2 downto 0) = "110")
                or (iufmt2dec_op3_in(2 downto 0) = "111"))) then
                iufmt2dec_do_out <= st_iuctrl_if_ERR;
            end if;
            if ((iufmt2dec_op3_in(4 downto 3) = IUFMT2DEC_INST_SFT)
              and ((iufmt2dec_op3_in(2 downto 0) = IUSFT_OP_UNIMP1)
                or (iufmt2dec_op3_in(2 downto 0) = IUSFT_OP_UNIMP2)
                or (iufmt2dec_op3_in(2 downto 0) = IUSFT_OP_UNIMP3))) then
                iufmt2dec_do_out <= st_iuctrl_if_ERR;
            end if;
            if ((iufmt2dec_op3_in(4 downto 3) = IUFMT2DEC_INST_CMP)
              and ((iufmt2dec_op3_in(2 downto 0) = IUCMP_OP_UNIMP1)
                or (iufmt2dec_op3_in(2 downto 0) = IUCMP_OP_UNIMP2))) then
                iufmt2dec_do_out <= st_iuctrl_if_ERR;
            end if;
            if (iufmt2dec_op3_in(5) = '1') then
                iufmt2dec_do_out <= st_iuctrl_if_ERR;
            end if;
        end if;
    end process IU_Format2_Decoder;

end rtl;
