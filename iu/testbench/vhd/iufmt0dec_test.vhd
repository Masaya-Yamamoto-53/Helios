library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iuctrl_pac.all;

entity iufmt0dec_test is
end iufmt0dec_test;

architecture behavior of iufmt0dec_test is 

    component iufmt0dec
        port(
            iufmt0dec_cs_in      : in    std_logic;
            iufmt0dec_op2_in     : in    std_logic_vector ( 1 downto 0);
            iufmt0dec_rs3_sel_in : in    std_logic_vector ( 4 downto 0);
            iufmt0dec_cond_in    : in    std_logic_vector ( 2 downto 0);
            iufmt0dec_token_in   : in    std_logic;
            iufmt0dec_sethi_in   : in    std_logic_vector (22 downto 0);
            iufmt0dec_disp19_in  : in    std_logic_vector (18 downto 0);
            iufmt0dec_do_out     :   out st_iuctrl_if
        );
    end component;

    --inputs
    signal iufmt0dec_cs_in      : std_logic;
    signal iufmt0dec_op2_in     : std_logic_vector ( 1 downto 0);
    signal iufmt0dec_rs3_sel_in : std_logic_vector ( 4 downto 0);
    signal iufmt0dec_cond_in    : std_logic_vector ( 2 downto 0);
    signal iufmt0dec_token_in   : std_logic;
    signal iufmt0dec_sethi_in   : std_logic_vector (22 downto 0);
    signal iufmt0dec_disp19_in  : std_logic_vector (18 downto 0);

    --outputs
    signal iufmt0dec_do_out     : st_iuctrl_if;

begin

    -- instantiate the unit under test (uut)
    uut: iufmt0dec port map (
        iufmt0dec_cs_in      => iufmt0dec_cs_in,
        iufmt0dec_op2_in     => iufmt0dec_op2_in,
        iufmt0dec_rs3_sel_in => iufmt0dec_rs3_sel_in,
        iufmt0dec_cond_in    => iufmt0dec_cond_in,
        iufmt0dec_token_in   => iufmt0dec_token_in,
        iufmt0dec_sethi_in   => iufmt0dec_sethi_in,
        iufmt0dec_disp19_in  => iufmt0dec_disp19_in,
        iufmt0dec_do_out     => iufmt0dec_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iufmt0dec_test.dat";
        file fout : text open write_mode is "../../../../log/iufmt0dec_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable cs_sig      : std_logic;
        variable op2_sig     : std_logic_vector ( 1 downto 0);
        variable rs3_sel_sig : std_logic_vector ( 4 downto 0);
        variable cond_sig    : std_logic_vector ( 2 downto 0);
        variable token_sig   : std_logic;
        variable sethi_sig   : std_logic_vector (22 downto 0);
        variable disp19_sig  : std_logic_vector (18 downto 0);

        -- output signal
        variable do_sig      : st_iuctrl_if;

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, cs_sig     );
            read (li, op2_sig    );
            read (li, rs3_sel_sig);
            read (li, cond_sig   );
            read (li, token_sig  );
            read (li, sethi_sig  );
            read (li, disp19_sig );

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

            read (li, do_sig.unimp );

            iufmt0dec_cs_in      <= cs_sig;
            iufmt0dec_op2_in     <= op2_sig;
            iufmt0dec_rs3_sel_in <= rs3_sel_sig;
            iufmt0dec_cond_in    <= cond_sig;
            iufmt0dec_token_in   <= token_sig;
            iufmt0dec_sethi_in   <= sethi_sig;
            iufmt0dec_disp19_in  <= disp19_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);
            write (lo, str_separate);

            if ((iufmt0dec_do_out.rs1_sel   /= do_sig.rs1_sel  )
            or  (iufmt0dec_do_out.rs2_sel   /= do_sig.rs2_sel  )
            or  (iufmt0dec_do_out.rs3_sel   /= do_sig.rs3_sel  )
            or  (iufmt0dec_do_out.imm_data  /= do_sig.imm_data )
            or  (iufmt0dec_do_out.sethi     /= do_sig.sethi    )
            or  (iufmt0dec_do_out.disp19    /= do_sig.disp19   )
            or  (iufmt0dec_do_out.opecode   /= do_sig.opecode  )
            or  (iufmt0dec_do_out.cond_cs   /= do_sig.cond_cs  )
            or  (iufmt0dec_do_out.cond      /= do_sig.cond     )
            or  (iufmt0dec_do_out.alu_cs    /= do_sig.alu_cs   )
            or  (iufmt0dec_do_out.mul_cs    /= do_sig.mul_cs   )
            or  (iufmt0dec_do_out.sft_cs    /= do_sig.sft_cs   )
            or  (iufmt0dec_do_out.cmp_cs    /= do_sig.cmp_cs   )
            or  (iufmt0dec_do_out.rd_we     /= do_sig.rd_we    )
            or  (iufmt0dec_do_out.rd_sel    /= do_sig.rd_sel   )
            or  (iufmt0dec_do_out.branch    /= do_sig.branch   )
            or  (iufmt0dec_do_out.mem_read  /= do_sig.mem_read )
            or  (iufmt0dec_do_out.mem_write /= do_sig.mem_write)
            or  (iufmt0dec_do_out.mem_sign  /= do_sig.mem_sign )
            or  (iufmt0dec_do_out.mem_type  /= do_sig.mem_type )
            or  (iufmt0dec_do_out.unimp     /= do_sig.unimp    )) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.rs1_sel  );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.rs2_sel  );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.rs3_sel  );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.imm_data );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.sethi    );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.disp19   );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.opecode  );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.cond_cs  );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.cond     );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.alu_cs   );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.mul_cs   );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.sft_cs   );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.cmp_cs   );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.rd_we    );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.rd_sel   );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.branch   );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.mem_read );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.mem_write);
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.mem_sign );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.mem_type );
                write (lo, str_separate);
                write (lo, iufmt0dec_do_out.unimp    );
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
