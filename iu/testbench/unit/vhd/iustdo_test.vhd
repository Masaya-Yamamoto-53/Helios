library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iustdo_test is
end iustdo_test;

architecture behavior of iustdo_test is 

    component iustdo
        port(
             iustdo_write_in : in    std_logic;
             iustdo_type_in  : in    std_logic_vector ( 1 downto 0);
             iustdo_addr_in  : in    std_logic_vector ( 1 downto 0);
             iustdo_di_in    : in    std_logic_vector (31 downto 0);
             iustdo_do_out   :   out std_logic_vector (31 downto 0)
        );
    end component;

    --inputs
    signal iustdo_write_in : std_logic := '0';
    signal iustdo_type_in  : std_logic_vector ( 1 downto 0) := (others => '0');
    signal iustdo_addr_in  : std_logic_vector ( 1 downto 0) := (others => '0');
    signal iustdo_di_in    : std_logic_vector (31 downto 0) := (others => '0');

    --outputs
    signal iustdo_do_out  : std_logic_vector(31 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iustdo port map (
        iustdo_write_in => iustdo_write_in,
        iustdo_type_in  => iustdo_type_in,
        iustdo_addr_in  => iustdo_addr_in,
        iustdo_di_in    => iustdo_di_in,
        iustdo_do_out   => iustdo_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iustdo_test.dat";
        file fout : text open write_mode is "../../../../log/iustdo_test.log";
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
            read (li, do_sig   );

            iustdo_write_in <= write_sig;
            iustdo_type_in  <= type_sig;
            iustdo_addr_in  <= addr_sig;
            iustdo_di_in    <= di_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if ((iustdo_do_out /= do_sig)) then
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
