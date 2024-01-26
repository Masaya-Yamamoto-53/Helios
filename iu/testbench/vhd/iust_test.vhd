library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iust_test is
end iust_test;

architecture behavior of iust_test is 

    component iust
        port(
            iust_write_in : in    std_logic;
            iust_type_in  : in    std_logic_vector ( 1 downto 0);
            iust_addr_in  : in    std_logic_vector ( 1 downto 0);
            iust_di_in    : in    std_logic_vector (31 downto 0);
            iust_dqm_out  :   out std_logic_vector ( 3 downto 0);
            iust_do_out   :   out std_logic_vector (31 downto 0)
        );
    end component;

    --inputs
    signal iust_write_in : std_logic := '0';
    signal iust_type_in  : std_logic_vector ( 1 downto 0) := (others => '0');
    signal iust_addr_in  : std_logic_vector ( 1 downto 0) := (others => '0');
    signal iust_di_in    : std_logic_vector (31 downto 0) := (others => '0');

    --outputs
    signal iust_dqm_out : std_logic_vector ( 3 downto 0);
    signal iust_do_out  : std_logic_vector (31 downto 0);

begin

    -- instantiate the unit under test (uut) uut: iust port map (
    uut: iust port map (
        iust_write_in => iust_write_in,
        iust_type_in  => iust_type_in,
        iust_addr_in  => iust_addr_in,
        iust_di_in    => iust_di_in,
        iust_dqm_out  => iust_dqm_out,
        iust_do_out   => iust_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../../dat/iust_test.dat";
        file fout : text open write_mode is "../../../../../log/iust_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable write_sig : std_logic;
        variable addr_sig  : std_logic_vector ( 1 downto 0);
        variable di_sig    : std_logic_vector (31 downto 0);
        variable type_sig  : std_logic_vector ( 1 downto 0);

        -- output signal
        variable dqm_sig   : std_logic_vector ( 3 downto 0);
        variable do_sig    : std_logic_vector (31 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, write_sig);
            read (li, type_sig );
            read (li, addr_sig );
            read (li, di_sig   );

            -- result
            read (li, dqm_sig  );
            read (li, do_sig   );

            iust_write_in <= write_sig;
            iust_type_in  <= type_sig;
            iust_addr_in  <= addr_sig;
            iust_di_in    <= di_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if ((iust_dqm_out /= dqm_sig)
             or (iust_do_out  /= do_sig )) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iust_dqm_out);
                write (lo, str_separate);
                write (lo, iust_do_out);
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
