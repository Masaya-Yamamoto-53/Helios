library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iuifid_pac.all;

entity iuifid_test is
end iuifid_test;

architecture behavior of iuifid_test is 

    component iuifid
        port(
            iuifid_clk_in   : in    std_logic;
            iuifid_rst_in   : in    std_logic;
            iuifid_wen_in   : in    std_logic;
            iuifid_flash_in : in    std_logic;
            iuifid_di_in    : in    st_iuifid_if;
            iuifid_do_out   :   out st_iuifid_if
        );
    end component;

    --inputs
    signal iuifid_clk_in    : std_logic;
    signal iuifid_rst_in    : std_logic;
    signal iuifid_wen_in    : std_logic;
    signal iuifid_flash_in  : std_logic;
    signal iuifid_di_in     : st_iuifid_if;

    --outputs
    signal iuifid_do_out    : st_iuifid_if;

begin

    -- instantiate the unit under test (uut)
    uut: iuifid port map (
        iuifid_clk_in   => iuifid_clk_in,
        iuifid_rst_in   => iuifid_rst_in,
        iuifid_wen_in   => iuifid_wen_in,
        iuifid_flash_in => iuifid_flash_in,
        iuifid_di_in    => iuifid_di_in,
        iuifid_do_out   => iuifid_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iuifid_test.dat";
        file fout : text open write_mode is "../../../../log/iuifid_test.log";
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
        variable di_sig    : st_iuifid_if;

        -- output signal
        variable do_sig    : st_iuifid_if;

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, clk_sig        );
            read (li, rst_sig        );
            read (li, wen_sig        );
            read (li, flash_sig      );
            read (li, di_sig.intr_req);
            read (li, di_sig.pc      );
            read (li, di_sig.inst    );
            read (li, di_sig.token   );

            -- result
            read (li, do_sig.intr_req);
            read (li, do_sig.pc      );
            read (li, do_sig.inst    );
            read (li, do_sig.token   );

            iuifid_clk_in   <= clk_sig;
            iuifid_rst_in   <= rst_sig;
            iuifid_wen_in   <= wen_sig;
            iuifid_flash_in <= flash_sig;
            iuifid_di_in    <= di_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iuifid_do_out /= do_sig) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iuifid_do_out.intr_req);
                write (lo, str_separate);
                write (lo, iuifid_do_out.pc);
                write (lo, str_separate);
                write (lo, iuifid_do_out.inst);
                write (lo, str_separate);
                write (lo, iuifid_do_out.token);
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
