library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iuexma_pac.all;

entity iuexma_test is
end iuexma_test;

architecture behavior of iuexma_test is 

    component iuexma
        port(
            iuexma_clk_in   : in    std_logic;
            iuexma_rst_in   : in    std_logic;
            iuexma_wen_in   : in    std_logic;
            iuexma_flash_in : in    std_logic;
            iuexma_di_in    : in    st_iuexma_if;
            iuexma_do_out   :   out st_iuexma_if
        );
    end component;

    --inputs
    signal iuexma_clk_in    : std_logic;
    signal iuexma_rst_in    : std_logic;
    signal iuexma_wen_in    : std_logic;
    signal iuexma_flash_in  : std_logic;
    signal iuexma_di_in     : st_iuexma_if;

    --outputs
    signal iuexma_do_out    : st_iuexma_if;

begin

    -- instantiate the unit under test (uut)
    uut: iuexma port map (
        iuexma_clk_in   => iuexma_clk_in,
        iuexma_rst_in   => iuexma_rst_in,
        iuexma_wen_in   => iuexma_wen_in,
        iuexma_flash_in => iuexma_flash_in,
        iuexma_di_in    => iuexma_di_in,
        iuexma_do_out   => iuexma_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iuexma_test.dat";
        file fout : text open write_mode is "../../../../log/iuexma_test.log";
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
        variable di_sig    : st_iuexma_if;

        -- output signal
        variable do_sig    : st_iuexma_if;

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, clk_sig     );
            read (li, rst_sig     );
            read (li, wen_sig     );
            read (li, flash_sig   );

            read (li, di_sig.mul_cs   );
            read (li, di_sig.rd_we    );
            read (li, di_sig.psr_read );
            read (li, di_sig.s_we     );
            read (li, di_sig.et_we    );
            read (li, di_sig.pil_we   );
            read (li, di_sig.intr_req );
            read (li, di_sig.branch   );
            read (li, di_sig.rett     );
            read (li, di_sig.mem_read );
            read (li, di_sig.mem_write);
            read (li, di_sig.inst_a   );

            read (li, di_sig.rd_sel   );
            read (li, di_sig.rd_data  );
            read (li, di_sig.pc       );
            read (li, di_sig.mem_sign );
            read (li, di_sig.mem_type );
            read (li, di_sig.mem_data );

            -- result
            read (li, do_sig.mul_cs   );
            read (li, do_sig.rd_we    );
            read (li, do_sig.psr_read );
            read (li, do_sig.s_we     );
            read (li, do_sig.et_we    );
            read (li, do_sig.pil_we   );
            read (li, do_sig.intr_req );
            read (li, do_sig.branch   );
            read (li, do_sig.rett     );
            read (li, do_sig.mem_read );
            read (li, do_sig.mem_write);
            read (li, do_sig.inst_a   );

            read (li, do_sig.rd_sel   );
            read (li, do_sig.rd_data  );
            read (li, do_sig.pc       );
            read (li, do_sig.mem_sign );
            read (li, do_sig.mem_type );
            read (li, do_sig.mem_data );

            iuexma_clk_in   <= clk_sig;
            iuexma_rst_in   <= rst_sig;
            iuexma_wen_in   <= wen_sig;
            iuexma_flash_in <= flash_sig;
            iuexma_di_in    <= di_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iuexma_do_out /= do_sig) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iuexma_do_out.mul_cs   );
                write (lo, str_separate);
                write (lo, iuexma_do_out.rd_we    );
                write (lo, str_separate);
                write (lo, iuexma_do_out.psr_read );
                write (lo, str_separate);
                write (lo, iuexma_do_out.s_we     );
                write (lo, str_separate);
                write (lo, iuexma_do_out.et_we    );
                write (lo, str_separate);
                write (lo, iuexma_do_out.pil_we   );
                write (lo, str_separate);
                write (lo, iuexma_do_out.intr_req );
                write (lo, str_separate);
                write (lo, iuexma_do_out.branch   );
                write (lo, str_separate);
                write (lo, iuexma_do_out.rett     );
                write (lo, str_separate);
                write (lo, iuexma_do_out.mem_read );
                write (lo, str_separate);
                write (lo, iuexma_do_out.mem_write);
                write (lo, str_separate);
                write (lo, iuexma_do_out.inst_a   );

                write (lo, str_separate);
                write (lo, iuexma_do_out.rd_sel   );
                write (lo, str_separate);
                write (lo, iuexma_do_out.rd_data  );
                write (lo, str_separate);
                write (lo, iuexma_do_out.pc       );
                write (lo, str_separate);
                write (lo, iuexma_do_out.mem_sign );
                write (lo, str_separate);
                write (lo, iuexma_do_out.mem_type );
                write (lo, str_separate);
                write (lo, iuexma_do_out.mem_data );
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
