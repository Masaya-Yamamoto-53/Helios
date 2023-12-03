library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iuctrl_pac.all;

entity iufmt1dec_test is
end iufmt1dec_test;

architecture behavior of iufmt1dec_test is 

    component iufmt1dec
        port(
            iufmt1dec_cs_in  : in    std_logic;
            iufmt1dec_do_out :   out st_iuctrl_if
        );
    end component;

    --inputs
    signal iufmt1dec_cs_in  : std_logic;

    --outputs
    signal iufmt1dec_do_out : st_iuctrl_if;

begin

    -- instantiate the unit under test (uut)
    uut: iufmt1dec port map (
        iufmt1dec_cs_in  => iufmt1dec_cs_in,
        iufmt1dec_do_out => iufmt1dec_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iufmt1dec_test.dat";
        file fout : text open write_mode is "../../../../log/iufmt1dec_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable cs_sig : std_logic;

        -- output signal
        variable do_sig : st_iuctrl_if;

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, cs_sig);

            -- result
            read (li, do_sig.rs1_sel  );
            read (li, do_sig.rs2_sel  );
            read (li, do_sig.rs3_sel  );

            read (li, do_sig.imm_data );
            read (li, do_sig.sethi    );
            read (li, do_sig.disp19   );

            read (li, do_sig.opecode  );

            read (li, do_sig.cond_cs  );
            read (li, do_sig.cond     );

            read (li, do_sig.alu_cs   );
            read (li, do_sig.mul_cs   );
            read (li, do_sig.sft_cs   );
            read (li, do_sig.cmp_cs   );

            read (li, do_sig.rd_we    );
            read (li, do_sig.rd_sel   );

            read (li, do_sig.branch   );

            read (li, do_sig.mem_read );
            read (li, do_sig.mem_write);
            read (li, do_sig.mem_sign );
            read (li, do_sig.mem_type );

            read (li, do_sig.unimp    );

            iufmt1dec_cs_in <= cs_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);
            write (lo, str_separate);

            if ((iufmt1dec_do_out.rs1_sel   /= do_sig.rs1_sel  )
            or  (iufmt1dec_do_out.rs2_sel   /= do_sig.rs2_sel  )
            or  (iufmt1dec_do_out.rs3_sel   /= do_sig.rs3_sel  )
            or  (iufmt1dec_do_out.imm_data  /= do_sig.imm_data )
            or  (iufmt1dec_do_out.sethi     /= do_sig.sethi    )
            or  (iufmt1dec_do_out.disp19    /= do_sig.disp19   )
            or  (iufmt1dec_do_out.opecode   /= do_sig.opecode  )
            or  (iufmt1dec_do_out.cond_cs   /= do_sig.cond_cs  )
            or  (iufmt1dec_do_out.cond      /= do_sig.cond     )
            or  (iufmt1dec_do_out.alu_cs    /= do_sig.alu_cs   )
            or  (iufmt1dec_do_out.mul_cs    /= do_sig.mul_cs   )
            or  (iufmt1dec_do_out.sft_cs    /= do_sig.sft_cs   )
            or  (iufmt1dec_do_out.cmp_cs    /= do_sig.cmp_cs   )
            or  (iufmt1dec_do_out.rd_we     /= do_sig.rd_we    )
            or  (iufmt1dec_do_out.rd_sel    /= do_sig.rd_sel   )
            or  (iufmt1dec_do_out.branch    /= do_sig.branch   )
            or  (iufmt1dec_do_out.mem_read  /= do_sig.mem_read )
            or  (iufmt1dec_do_out.mem_write /= do_sig.mem_write)
            or  (iufmt1dec_do_out.mem_sign  /= do_sig.mem_sign )
            or  (iufmt1dec_do_out.mem_type  /= do_sig.mem_type )
            or  (iufmt1dec_do_out.unimp     /= do_sig.unimp    )) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.rs1_sel  );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.rs2_sel  );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.rs3_sel  );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.imm_data );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.sethi    );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.disp19   );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.opecode  );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.cond_cs  );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.cond     );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.alu_cs   );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.mul_cs   );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.sft_cs   );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.cmp_cs   );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.rd_we    );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.rd_sel   );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.branch   );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.mem_read );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.mem_write);
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.mem_sign );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.mem_type );
                write (lo, str_separate);
                write (lo, iufmt1dec_do_out.unimp );
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
