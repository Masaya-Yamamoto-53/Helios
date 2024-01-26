library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iumul32_pac.all;

entity iumul32reg_test is
end iumul32reg_test;

architecture behavior of iumul32reg_test is 

    component iumul32reg
        port(
            iumul32reg_clk_in   : in    std_logic;
            iumul32reg_wen_in   : in    std_logic;
            iumul32reg_di_in    : in    st_iumul32_if;
            iumul32reg_do_out   :   out st_iumul32_if
        );
    end component;

    --inputs
    signal iumul32reg_clk_in   : std_logic;
    signal iumul32reg_wen_in   : std_logic;
    signal iumul32reg_di_in    : st_iumul32_if;

    --outputs
    signal iumul32reg_do_out   : st_iumul32_if;

begin

    -- instantiate the unit under test (uut)
    uut: iumul32reg port map (
        iumul32reg_clk_in   => iumul32reg_clk_in,
        iumul32reg_wen_in   => iumul32reg_wen_in,
        iumul32reg_di_in    => iumul32reg_di_in,
        iumul32reg_do_out   => iumul32reg_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../../dat/iumul32reg_test.dat";
        file fout : text open write_mode is "../../../../../log/iumul32reg_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable clk_sig   : std_logic;
        variable wen_sig   : std_logic;
        variable di_sig    : st_iumul32_if;

        -- output signal
        variable do_sig   : st_iumul32_if;

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, clk_sig         );
            read (li, wen_sig         );
            read (li, di_sig.hi       );
            read (li, di_sig.mul1_data);
            read (li, di_sig.mul2_data);
            read (li, di_sig.mul3_data);
            read (li, di_sig.mul4_data);

            -- result
            read (li, do_sig.hi       );
            read (li, do_sig.mul1_data);
            read (li, do_sig.mul2_data);
            read (li, do_sig.mul3_data);
            read (li, do_sig.mul4_data);

            iumul32reg_clk_in   <= clk_sig;
            iumul32reg_wen_in   <= wen_sig;
            iumul32reg_di_in    <= di_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iumul32reg_do_out /= do_sig) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iumul32reg_do_out.hi);
                write (lo, str_separate);
                write (lo, iumul32reg_do_out.mul1_data);
                write (lo, str_separate);
                write (lo, iumul32reg_do_out.mul2_data);
                write (lo, str_separate);
                write (lo, iumul32reg_do_out.mul3_data);
                write (lo, str_separate);
                write (lo, iumul32reg_do_out.mul4_data);
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
