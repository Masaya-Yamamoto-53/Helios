library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iuet_pac.all;

entity iuet_test is
end iuet_test;

architecture behavior of iuet_test is 

    component iuet
        port(
            iuet_clk_in   : in    std_logic;
            iuet_rst_in   : in    std_logic;
            iuet_we_in    : in    std_logic;
            iuet_di_in    : in    std_logic;
            iuet_do_out   :   out std_logic
        );
    end component;

    --inputs
    signal iuet_clk_in    : std_logic;
    signal iuet_rst_in    : std_logic;
    signal iuet_we_in     : std_logic;
    signal iuet_di_in     : std_logic;

    --outputs
    signal iuet_do_out    : std_logic;

begin

    -- instantiate the unit under test (uut)
    uut: iuet port map (
        iuet_clk_in   => iuet_clk_in,
        iuet_rst_in   => iuet_rst_in,
        iuet_we_in    => iuet_we_in,
        iuet_di_in    => iuet_di_in,
        iuet_do_out   => iuet_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../../dat/iuet_test.dat";
        file fout : text open write_mode is "../../../../../log/iuet_test.log";
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
        variable we_sig    : std_logic;
        variable di_sig    : std_logic;

        -- output signal
        variable do_sig    : std_logic;

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, clk_sig);
            read (li, rst_sig);
            read (li, we_sig );
            read (li, di_sig );

            -- result
            read (li, do_sig);

            iuet_clk_in   <= clk_sig;
            iuet_rst_in   <= rst_sig;
            iuet_we_in    <= we_sig;
            iuet_di_in    <= di_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iuet_do_out /= do_sig) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iuet_do_out);
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
