library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iuidex_pac.all;

entity iuidex_test is
end iuidex_test;

architecture behavior of iuidex_test is 

    component iuidex
        port(
            iuidex_clk_in   : in    std_logic;
            iuidex_rst_in   : in    std_logic;
            iuidex_wen_in   : in    std_logic;
            iuidex_flash_in : in    std_logic;
            iuidex_di_in    : in    st_iuidex_if;
            iuidex_do_out   :   out st_iuidex_if
        );
    end component;

    --inputs
    signal iuidex_clk_in    : std_logic;
    signal iuidex_rst_in    : std_logic;
    signal iuidex_wen_in    : std_logic;
    signal iuidex_flash_in  : std_logic;
    signal iuidex_di_in     : st_iuidex_if;

    --outputs
    signal iuidex_do_out    : st_iuidex_if;

begin

    -- instantiate the unit under test (uut)
    uut: iuidex port map (
        iuidex_clk_in   => iuidex_clk_in,
        iuidex_rst_in   => iuidex_rst_in,
        iuidex_wen_in   => iuidex_wen_in,
        iuidex_flash_in => iuidex_flash_in,
        iuidex_di_in    => iuidex_di_in,
        iuidex_do_out   => iuidex_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../../dat/iuidex_test.dat";
        file fout : text open write_mode is "../../../../../log/iuidex_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable clk_sig   : std_logic;
        variable rst_sig   : std_logic;
        variable wen_sig   : std_logic;
        variable flash_sig : std_logic;
        variable di_sig    : st_iuidex_if;

        -- output signal
        variable do_sig    : st_iuidex_if;

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, clk_sig     );
            read (li, rst_sig     );
            read (li, wen_sig     );
            read (li, flash_sig   );
            read (li, di_sig.cond_cs  );
            read (li, di_sig.alu_cs   );
            read (li, di_sig.mul_cs   );
            read (li, di_sig.sft_cs   );
            read (li, di_sig.cmp_cs   );
            read (li, di_sig.rd_we    );
            read (li, di_sig.intr_req );
            read (li, di_sig.token    );
            read (li, di_sig.branch   );
            read (li, di_sig.rett     );
            read (li, di_sig.psr_read );
            read (li, di_sig.s_we     );
            read (li, di_sig.et_we    );
            read (li, di_sig.pil_we   );
            read (li, di_sig.mem_read );
            read (li, di_sig.mem_write);
            read (li, di_sig.inst_a   );
            read (li, di_sig.unimp    );

            read (li, di_sig.rs1_data );
            read (li, di_sig.rs1_fw   );
            read (li, di_sig.rs2_data );
            read (li, di_sig.rs2_fw   );
            read (li, di_sig.rs3_data );
            read (li, di_sig.rs3_fw   );
            read (li, di_sig.opecode  );
            read (li, di_sig.cond     );
            read (li, di_sig.rd_sel   );
            read (li, di_sig.pc       );
            read (li, di_sig.mem_sign );
            read (li, di_sig.mem_type );

            -- result
            read (li, do_sig.cond_cs  );
            read (li, do_sig.alu_cs   );
            read (li, do_sig.mul_cs   );
            read (li, do_sig.sft_cs   );
            read (li, do_sig.cmp_cs   );
            read (li, do_sig.rd_we    );
            read (li, do_sig.intr_req );
            read (li, do_sig.token    );
            read (li, do_sig.branch   );
            read (li, do_sig.rett     );
            read (li, do_sig.psr_read );
            read (li, do_sig.s_we     );
            read (li, do_sig.et_we    );
            read (li, do_sig.pil_we   );
            read (li, do_sig.mem_read );
            read (li, do_sig.mem_write);
            read (li, do_sig.inst_a   );
            read (li, do_sig.unimp    );

            read (li, do_sig.rs1_data );
            read (li, do_sig.rs1_fw   );
            read (li, do_sig.rs2_data );
            read (li, do_sig.rs2_fw   );
            read (li, do_sig.rs3_data );
            read (li, do_sig.rs3_fw   );
            read (li, do_sig.opecode  );
            read (li, do_sig.cond     );
            read (li, do_sig.rd_sel   );
            read (li, do_sig.pc       );
            read (li, do_sig.mem_sign );
            read (li, do_sig.mem_type );

            iuidex_clk_in   <= clk_sig;
            iuidex_rst_in   <= rst_sig;
            iuidex_wen_in   <= wen_sig;
            iuidex_flash_in <= flash_sig;
            iuidex_di_in    <= di_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iuidex_do_out /= do_sig) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iuidex_do_out.cond_cs  );
                write (lo, str_separate);
                write (lo, iuidex_do_out.alu_cs   );
                write (lo, str_separate);
                write (lo, iuidex_do_out.mul_cs   );
                write (lo, str_separate);
                write (lo, iuidex_do_out.sft_cs   );
                write (lo, str_separate);
                write (lo, iuidex_do_out.cmp_cs   );
                write (lo, str_separate);
                write (lo, iuidex_do_out.rd_we    );
                write (lo, str_separate);
                write (lo, iuidex_do_out.intr_req );
                write (lo, str_separate);
                write (lo, iuidex_do_out.token    );
                write (lo, str_separate);
                write (lo, iuidex_do_out.branch   );
                write (lo, str_separate);
                write (lo, iuidex_do_out.rett     );
                write (lo, str_separate);
                write (lo, iuidex_do_out.psr_read );
                write (lo, str_separate);
                write (lo, iuidex_do_out.s_we     );
                write (lo, str_separate);
                write (lo, iuidex_do_out.et_we    );
                write (lo, str_separate);
                write (lo, iuidex_do_out.pil_we   );
                write (lo, str_separate);
                write (lo, iuidex_do_out.mem_read );
                write (lo, str_separate);
                write (lo, iuidex_do_out.mem_write);
                write (lo, str_separate);
                write (lo, iuidex_do_out.inst_a   );
                write (lo, str_separate);
                write (lo, iuidex_do_out.unimp    );

                write (lo, str_separate);
                write (lo, iuidex_do_out.rs1_data );
                write (lo, str_separate);
                write (lo, iuidex_do_out.rs1_fw   );
                write (lo, str_separate);
                write (lo, iuidex_do_out.rs2_data );
                write (lo, str_separate);
                write (lo, iuidex_do_out.rs2_fw   );
                write (lo, str_separate);
                write (lo, iuidex_do_out.rs3_data );
                write (lo, str_separate);
                write (lo, iuidex_do_out.rs3_fw   );
                write (lo, str_separate);
                write (lo, iuidex_do_out.opecode  );
                write (lo, str_separate);
                write (lo, iuidex_do_out.cond     );
                write (lo, str_separate);
                write (lo, iuidex_do_out.rd_sel   );
                write (lo, str_separate);
                write (lo, iuidex_do_out.pc       );
                write (lo, str_separate);
                write (lo, iuidex_do_out.mem_sign );
                write (lo, str_separate);
                write (lo, iuidex_do_out.mem_type );
            else
                write (lo, str_pass);
            end if;

            writeline (fout, lo);

        end loop;

        file_close (fin);
        file_close (fout);
        wait;
   end process;

end;
