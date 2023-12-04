library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iucond_test is
end iucond_test;

architecture behavior of iucond_test is 

    component iucond
        port(
            iucond_cs_in   : in    std_logic;
            iucond_cond_in : in    std_logic_vector ( 2 downto 0);
            iucond_di_in   : in    std_logic_vector (31 downto 0);
            iucond_do_out  :   out std_logic
        );
    end component;

    --inputs
    signal iucond_cs_in   : std_logic := '0';
    signal iucond_cond_in : std_logic_vector ( 2 downto 0) := (others => '0');
    signal iucond_di_in   : std_logic_vector (31 downto 0) := (others => '0');

    --outputs
    signal iucond_do_out : std_logic;

begin

    -- instantiate the unit under test (uut)
    uut: iucond port map (
        iucond_cs_in   => iucond_cs_in,
        iucond_cond_in => iucond_cond_in,
        iucond_di_in   => iucond_di_in,
        iucond_do_out  => iucond_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iucond_test.dat";
        file fout : text open write_mode is "../../../../log/iucond_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable cs_sig   : std_logic;
        variable cond_sig : std_logic_vector ( 2 downto 0);
        variable di_sig   : std_logic_vector (31 downto 0);

        -- output signal
        variable do_sig   : std_logic;

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, cs_sig);
            read (li, cond_sig  );
            read (li, di_sig    );

            -- result
            read (li, do_sig  );

            iucond_cs_in   <= cs_sig;
            iucond_di_in   <= di_sig;
            iucond_cond_in <= cond_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iucond_do_out /= do_sig ) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iucond_do_out);
            else
                write (lo, str_pass);
            end if;

            writeline (fout, lo);

        end loop;

        file_close (fin);
        file_close (fout);
        wait;
      wait;
   end process;

end;
