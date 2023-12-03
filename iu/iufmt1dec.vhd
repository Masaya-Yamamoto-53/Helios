library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iuctrl_pac.all;
use work.iurf_pac.all;
use work.iualu_pac.all;

entity iufmt1dec is
    port (
        iufmt1dec_cs_in  : in    std_logic;
        iufmt1dec_do_out :   out st_iuctrl_if
    );
end iufmt1dec;

architecture rtl of iufmt1dec is

begin

    IU_Format1_Decoder : process (
        iufmt1dec_cs_in
    )
    begin
        if (iufmt1dec_cs_in = '1') then
            iufmt1dec_do_out.rs1_sel   <= IURF_R_PC;
        else
            iufmt1dec_do_out.rs1_sel   <= (others => '0');
        end if;

        iufmt1dec_do_out.rs2_sel   <= (others => '0');
        iufmt1dec_do_out.rs3_sel   <= (others => '0');
        iufmt1dec_do_out.imm_data  <= (others => '0');

        iufmt1dec_do_out.opecode   <= (others => '0');

        iufmt1dec_do_out.cond_cs   <= '0';
        iufmt1dec_do_out.cond      <= (others => '0');

        if (iufmt1dec_cs_in = '1') then
            iufmt1dec_do_out.alu_cs    <= '1';
        else
            iufmt1dec_do_out.alu_cs    <= '0';
        end if;

        iufmt1dec_do_out.mul_cs    <= '0';
        iufmt1dec_do_out.sft_cs    <= '0';
        iufmt1dec_do_out.cmp_cs    <= '0';

        if (iufmt1dec_cs_in = '1') then
            iufmt1dec_do_out.rd_we     <= '1';
            iufmt1dec_do_out.rd_sel    <= IURF_R_RET;
        else
            iufmt1dec_do_out.rd_we     <= '0';
            iufmt1dec_do_out.rd_sel    <= (others => '0');
        end if;

        iufmt1dec_do_out.sethi     <= (others => '0');

        iufmt1dec_do_out.branch    <= '0';
        iufmt1dec_do_out.rett      <= '0';
        iufmt1dec_do_out.disp19    <= (others => '0');

        iufmt1dec_do_out.psr_read  <= '0';
        iufmt1dec_do_out.s_we      <= '0';
        iufmt1dec_do_out.et_we     <= '0';
        iufmt1dec_do_out.pil_we    <= '0';

        iufmt1dec_do_out.mem_read  <= '0';
        iufmt1dec_do_out.mem_write <= '0';
        iufmt1dec_do_out.mem_sign  <= '0';
        iufmt1dec_do_out.mem_type  <= (others => '0');
        iufmt1dec_do_out.inst_a    <= '0';

        iufmt1dec_do_out.unimp     <= '0';
    end process IU_Format1_Decoder;

end rtl;
