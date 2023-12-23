library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iupil_pac.all;

entity iupil_test is
end iupil_test;

architecture behavior of iupil_test is 

    component iupil
        port(
            iupil_clk_in   : in    std_logic;
            iupil_rst_in   : in    std_logic;
            iupil_we_in    : in    std_logic;
            iupil_di_in    : in    std_logic_vector(3 downto 0);
            iupil_do_out   :   out std_logic_vector(3 downto 0)
        );
    end component;

    --inputs
    signal iupil_clk_in    : std_logic;
    signal iupil_rst_in    : std_logic;
    signal iupil_we_in     : std_logic;
    signal iupil_di_in     : std_logic_vector(3 downto 0);

    --outputs
    signal iupil_do_out    : std_logic_vector(3 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iupil port map (
        iupil_clk_in   => iupil_clk_in,
        iupil_rst_in   => iupil_rst_in,
        iupil_we_in    => iupil_we_in,
        iupil_di_in    => iupil_di_in,
        iupil_do_out   => iupil_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iupil_test.dat";
        file fout : text open write_mode is "../../../../log/iupil_test.log";
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
        variable di_sig    : std_logic_vector(3 downto 0);

        -- output signal
        variable do_sig    : std_logic_vector(3 downto 0);

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

            iupil_clk_in   <= clk_sig;
            iupil_rst_in   <= rst_sig;
            iupil_we_in    <= we_sig;
            iupil_di_in    <= di_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iupil_do_out /= do_sig) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iupil_do_out);
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
