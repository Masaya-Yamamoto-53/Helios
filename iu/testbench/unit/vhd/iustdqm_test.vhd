library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iustdqm_test is
end iustdqm_test;

architecture behavior of iustdqm_test is 

    component iustdqm
        port(
            iustdqm_write_in : in    std_logic;
            iustdqm_type_in  : in    std_logic_vector ( 1 downto 0);
            iustdqm_addr_in  : in    std_logic_vector ( 1 downto 0);
            iustdqm_dqm_out  :   out std_logic_vector ( 3 downto 0)
        );
    end component;

    --inputs
    signal iustdqm_write_in : std_logic := '0';
    signal iustdqm_type_in  : std_logic_vector ( 1 downto 0) := (others => '0');
    signal iustdqm_addr_in  : std_logic_vector ( 1 downto 0) := (others => '0');

    --outputs
    signal iustdqm_dqm_out : std_logic_vector ( 3 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iustdqm port map (
        iustdqm_write_in => iustdqm_write_in,
        iustdqm_type_in  => iustdqm_type_in,
        iustdqm_addr_in  => iustdqm_addr_in,
        iustdqm_dqm_out  => iustdqm_dqm_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iustdqm_test.dat";
        file fout : text open write_mode is "../../../../log/iustdqm_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable write_sig : std_logic;
        variable addr_sig  : std_logic_vector( 1 downto 0);
        variable type_sig  : std_logic_vector( 1 downto 0);

        -- output signal
        variable dqm_sig   : std_logic_vector( 3 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, write_sig);
            read (li, type_sig );
            read (li, addr_sig );

            -- result
            read (li, dqm_sig  );

            iustdqm_write_in <= write_sig;
            iustdqm_type_in  <= type_sig;
            iustdqm_addr_in  <= addr_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if ((iustdqm_dqm_out /= dqm_sig)) then
                write (lo, str_failure);
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
