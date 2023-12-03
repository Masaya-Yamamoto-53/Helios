library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iu_pac.all;
use work.iumawb_pac.all;
use work.iurf_pac.all;

use work.iurfport_pac.all;

entity iurfport_test is
end iurfport_test;

architecture behavior of iurfport_test is 

    component iurfport
        port(
           iurfport_sel_in : in    iurf_rs_sel_if;
           iurfport_di_in  : in    iurf_rs_data_if;
           iurfport_pc_in  : in    iurf_pc_if;
           iurfport_w_in   : in    st_iumawb_if;
           iurfport_do_out :   out iurf_rs_data_if
        );
    end component;

    --inputs
    signal iurfport_sel_in : iurf_rs_sel_if;
    signal iurfport_di_in  : iurf_rs_data_if;
    signal iurfport_pc_in  : iurf_pc_if;
    signal iurfport_w_in   : st_iumawb_if;

    --outputs
    signal iurfport_do_out : iurf_rs_data_if;

begin

    -- instantiate the unit under test (uut)
    uut: iurfport port map (
       iurfport_sel_in => iurfport_sel_in,
       iurfport_di_in  => iurfport_di_in,
       iurfport_pc_in  => iurfport_pc_in,
       iurfport_w_in   => iurfport_w_in,
       iurfport_do_out => iurfport_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iurfport_test.dat";
        file fout : text open write_mode is "../../../../log/iurfport_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable sel_sig : iurf_rs_sel_if;
        variable di_sig  : iurf_rs_data_if;
        variable pc_sig  : iurf_pc_if;
        variable w_sig   : st_iumawb_if;

        -- output signal
        variable do_sig : iurf_rs_data_if;

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, sel_sig);
            read (li, di_sig );
            read (li, pc_sig );
            read (li, w_sig.rd_we  );
            read (li, w_sig.rd_sel );
            read (li, w_sig.rd_data);

            -- result
            read (li, do_sig);

            iurfport_sel_in <= sel_sig;
            iurfport_di_in  <= di_sig;
            iurfport_pc_in  <= pc_sig;
            iurfport_w_in   <= w_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iurfport_do_out /= do_sig) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iurfport_do_out);
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
