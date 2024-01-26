library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iuld_test is
end iuld_test;

architecture behavior of iuld_test is 

    component iuld
        port(
            iuld_read_in : in    std_logic;
            iuld_sign_in : in    std_logic;
            iuld_type_in : in    std_logic_vector ( 1 downto 0);
            iuld_addr_in : in    std_logic_vector ( 1 downto 0);
            iuld_di_in   : in    std_logic_vector (31 downto 0);
            iuld_do_out  :   out std_logic_vector (31 downto 0)
        );
    end component;

    --inputs
    signal iuld_read_in : std_logic := '0';
    signal iuld_sign_in : std_logic := '0';
    signal iuld_type_in : std_logic_vector ( 1 downto 0) := (others => '0');
    signal iuld_addr_in : std_logic_vector ( 1 downto 0) := (others => '0');
    signal iuld_di_in   : std_logic_vector (31 downto 0) := (others => '0');

    --outputs
    signal iuld_do_out : std_logic_vector(31 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iuld port map (
        iuld_read_in => iuld_read_in,
        iuld_sign_in => iuld_sign_in,
        iuld_type_in => iuld_type_in,
        iuld_addr_in => iuld_addr_in,
        iuld_di_in   => iuld_di_in,
        iuld_do_out  => iuld_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../../dat/iuld_test.dat";
        file fout : text open write_mode is "../../../../../log/iuld_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable read_sig : std_logic;
        variable sign_sig : std_logic;
        variable type_sig : std_logic_vector ( 1 downto 0);
        variable addr_sig : std_logic_vector ( 1 downto 0);
        variable di_sig   : std_logic_vector (31 downto 0);

        -- output signal
        variable do_sig   : std_logic_vector (31 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, read_sig);
            read (li, sign_sig);
            read (li, type_sig);
            read (li, addr_sig);
            read (li, di_sig  );

            -- result
            read (li, do_sig  );

            iuld_read_in <= read_sig;
            iuld_sign_in <= sign_sig;
            iuld_type_in <= type_sig;
            iuld_addr_in <= addr_sig;
            iuld_di_in   <= di_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iuld_do_out /= do_sig ) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iuld_do_out);
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
