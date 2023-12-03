library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iualgnchk_test is
end iualgnchk_test;

architecture behavior of iualgnchk_test is 

    component iualgnchk
        port(
             iualgnchk_cs_in   : in    std_logic;
             iualgnchk_type_in : in    std_logic_vector (1 downto 0);
             iualgnchk_addr_in : in    std_logic_vector (1 downto 0);
             iualgnchk_do_out  :   out std_logic
        );
    end component;

    --inputs
    signal iualgnchk_cs_in   : std_logic := '0';
    signal iualgnchk_type_in : std_logic_vector (1 downto 0) := (others => '0');
    signal iualgnchk_addr_in : std_logic_vector (1 downto 0) := (others => '0');

    --outputs
    signal iualgnchk_do_out : std_logic;

begin

    -- instantiate the unit under test (uut)
    uut: iualgnchk port map (
        iualgnchk_cs_in   => iualgnchk_cs_in,
        iualgnchk_type_in => iualgnchk_type_in,
        iualgnchk_addr_in => iualgnchk_addr_in,
        iualgnchk_do_out  => iualgnchk_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iualgnchk_test.dat";
        file fout : text open write_mode is "../../../../log/iualgnchk_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable cs_sig   : std_logic;
        variable type_sig : std_logic_vector (1 downto 0);
        variable addr_sig : std_logic_vector (1 downto 0);

        -- output signal
        variable do_sig  : std_logic;

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, cs_sig   );
            read (li, type_sig );
            read (li, addr_sig );

            -- result
            read (li, do_sig   );

            iualgnchk_cs_in   <= cs_sig;
            iualgnchk_type_in <= type_sig;
            iualgnchk_addr_in <= addr_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iualgnchk_do_out /= do_sig) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iualgnchk_do_out);
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
