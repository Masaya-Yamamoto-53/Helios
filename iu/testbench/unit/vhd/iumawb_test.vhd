library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iumawb_pac.all;

entity iumawb_test is
end iumawb_test;

architecture behavior of iumawb_test is 

    component iumawb
        port(
            iumawb_clk_in   : in    std_logic;
            iumawb_rst_in   : in    std_logic;
            iumawb_wen_in   : in    std_logic;
            iumawb_flash_in : in    std_logic;
            iumawb_di_in    : in    st_iumawb_if;
            iumawb_do_out   :   out st_iumawb_if
        );
    end component;

    --inputs
    signal iumawb_clk_in    : std_logic;
    signal iumawb_rst_in    : std_logic;
    signal iumawb_wen_in    : std_logic;
    signal iumawb_flash_in  : std_logic;
    signal iumawb_di_in     : st_iumawb_if;

    --outputs
    signal iumawb_do_out    : st_iumawb_if;

begin

    -- instantiate the unit under test (uut)
    uut: iumawb port map (
        iumawb_clk_in   => iumawb_clk_in,
        iumawb_rst_in   => iumawb_rst_in,
        iumawb_wen_in   => iumawb_wen_in,
        iumawb_flash_in => iumawb_flash_in,
        iumawb_di_in    => iumawb_di_in,
        iumawb_do_out   => iumawb_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iumawb_test.dat";
        file fout : text open write_mode is "../../../../log/iumawb_test.log";
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
        variable di_sig    : st_iumawb_if;

        -- output signal
        variable do_sig    : st_iumawb_if;

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, clk_sig     );
            read (li, rst_sig     );
            read (li, wen_sig     );
            read (li, flash_sig   );

            read (li, di_sig.rd_we  );
            read (li, di_sig.rd_sel );
            read (li, di_sig.rd_data);

            -- result
            read (li, do_sig.rd_we  );
            read (li, do_sig.rd_sel );
            read (li, do_sig.rd_data);

            iumawb_clk_in   <= clk_sig;
            iumawb_rst_in   <= rst_sig;
            iumawb_wen_in   <= wen_sig;
            iumawb_flash_in <= flash_sig;
            iumawb_di_in    <= di_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iumawb_do_out /= do_sig) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iumawb_do_out.rd_we  );
                write (lo, str_separate);
                write (lo, iumawb_do_out.rd_sel );
                write (lo, str_separate);
                write (lo, iumawb_do_out.rd_data);
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
