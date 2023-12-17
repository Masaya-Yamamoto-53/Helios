--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Format 0 Decoder
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iuctrl_pac.all;
use work.iurf_pac.all;
use work.iualu_pac.all;

entity iufmt0dec is
    port (
        iufmt0dec_cs_in      : in    std_logic;
        iufmt0dec_op2_in     : in    std_logic_vector( 1 downto 0);
        iufmt0dec_rs3_sel_in : in    std_logic_vector( 4 downto 0);
        iufmt0dec_cond_in    : in    std_logic_vector( 2 downto 0);
        iufmt0dec_token_in   : in    std_logic;
        iufmt0dec_sethi_in   : in    std_logic_vector(22 downto 0);
        iufmt0dec_disp19_in  : in    std_logic_vector(18 downto 0);
        iufmt0dec_do_out     :   out st_iuctrl_if
    );
end iufmt0dec;

architecture rtl of iufmt0dec is

begin

    IU_Format0_Decoder : process (
        iufmt0dec_cs_in,
        iufmt0dec_op2_in,
        iufmt0dec_rs3_sel_in,
        iufmt0dec_cond_in,
        iufmt0dec_token_in,
        iufmt0dec_sethi_in,
        iufmt0dec_disp19_in
    )
    begin
        if (iufmt0dec_cs_in = '0') then
            iufmt0dec_do_out <= st_iuctrl_if_INIT;
        else
            case iufmt0dec_op2_in is
                when IUCTRL_OP2_SET =>
                    iufmt0dec_do_out.rs1_sel    <= (others => '0');
                    iufmt0dec_do_out.rs2_sel    <= (others => '0');
                    iufmt0dec_do_out.rs3_sel    <= (others => '0');
                    iufmt0dec_do_out.imm_data   <= (others => '0');
                    iufmt0dec_do_out.opecode    <= IUALU_OP_ADD;
                    iufmt0dec_do_out.cond_cs    <= '0';
                    iufmt0dec_do_out.cond       <= (others => '0');

                    iufmt0dec_do_out.alu_cs     <= '1';
                    iufmt0dec_do_out.mul_cs     <= '0';
                    iufmt0dec_do_out.sft_cs     <= '0';
                    iufmt0dec_do_out.cmp_cs     <= '0';

                    if (iufmt0dec_rs3_sel_in = IURF_R_ZERO
                     or iufmt0dec_rs3_sel_in = IURF_R_PC  ) then
                        iufmt0dec_do_out.rd_we      <= '0';
                    else
                        iufmt0dec_do_out.rd_we      <= '1';
                    end if;
                    iufmt0dec_do_out.rd_sel     <= iufmt0dec_rs3_sel_in;

                    iufmt0dec_do_out.sethi      <= iufmt0dec_sethi_in;

                    iufmt0dec_do_out.branch     <= '0';
                    iufmt0dec_do_out.rett       <= '0';
                    iufmt0dec_do_out.disp19     <= (others => '0');

                    iufmt0dec_do_out.psr_read   <= '0';
                    iufmt0dec_do_out.s_we       <= '0';
                    iufmt0dec_do_out.et_we      <= '0';
                    iufmt0dec_do_out.pil_we     <= '0';

                    iufmt0dec_do_out.mem_read   <= '0';
                    iufmt0dec_do_out.mem_write  <= '0';
                    iufmt0dec_do_out.mem_sign   <= '0';
                    iufmt0dec_do_out.mem_type   <= (others => '0');

                    iufmt0dec_do_out.inst_a     <= '0';

                    iufmt0dec_do_out.unimp      <= '0';
                when IUCTRL_OP2_IBR =>
                    iufmt0dec_do_out.rs1_sel    <= IURF_R_PC;
                    iufmt0dec_do_out.rs2_sel    <= (others => '0');
                    iufmt0dec_do_out.rs3_sel    <= iufmt0dec_rs3_sel_in;
                    iufmt0dec_do_out.imm_data   <= (others => '0');
                    iufmt0dec_do_out.opecode    <= IUALU_OP_ADD;
                    iufmt0dec_do_out.cond_cs    <= '1';
                    iufmt0dec_do_out.cond       <= iufmt0dec_cond_in;

                    iufmt0dec_do_out.alu_cs     <= '1';
                    iufmt0dec_do_out.mul_cs     <= '0';
                    iufmt0dec_do_out.sft_cs     <= '0';
                    iufmt0dec_do_out.cmp_cs     <= '0';

                    iufmt0dec_do_out.rd_we      <= '0';
                    iufmt0dec_do_out.rd_sel     <= (others => '0');

                    iufmt0dec_do_out.sethi      <= (others => '0');

                    iufmt0dec_do_out.branch     <= '1';
                    iufmt0dec_do_out.rett       <= '0';
                    if (iufmt0dec_token_in = '0') then
                        iufmt0dec_do_out.disp19     <= iufmt0dec_disp19_in;
                    else
                        iufmt0dec_do_out.disp19     <= X"0000" & "001";
                    end if;

                    iufmt0dec_do_out.psr_read   <= '0';
                    iufmt0dec_do_out.s_we       <= '0';
                    iufmt0dec_do_out.et_we      <= '0';
                    iufmt0dec_do_out.pil_we     <= '0';

                    iufmt0dec_do_out.mem_read   <= '0';
                    iufmt0dec_do_out.mem_write  <= '0';
                    iufmt0dec_do_out.mem_sign   <= '0';
                    iufmt0dec_do_out.mem_type   <= (others => '0');

                    iufmt0dec_do_out.inst_a     <= '0';

                    iufmt0dec_do_out.unimp      <= '0';
                when others =>
                    iufmt0dec_do_out <= st_iuctrl_if_ERR;
            end case;
        end if;
    end process IU_Format0_Decoder;

end rtl;
