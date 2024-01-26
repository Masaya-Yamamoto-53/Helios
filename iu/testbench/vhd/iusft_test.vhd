library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iusft_test is
end iusft_test;

architecture behavior of iusft_test is 

    component iusft
        port(
            iusft_cs_in    : in    std_logic;
            iusft_op_in    : in    std_logic_vector( 2 downto 0);
            iusft_di_in    : in    std_logic_vector(31 downto 0);
            iusft_shcnt_in : in    std_logic_vector( 4 downto 0);
            iusft_do_out   :   out std_logic_vector(31 downto 0)
        );
    end component;

    --inputs
    signal iusft_cs_in    : std_logic := '0';
    signal iusft_op_in    : std_logic_vector( 2 downto 0) := (others => '0');
    signal iusft_di_in    : std_logic_vector(31 downto 0) := (others => '0');
    signal iusft_shcnt_in : std_logic_vector( 4 downto 0) := (others => '0');

    --outputs
    signal iusft_do_out : std_logic_vector(31 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iusft port map (
        iusft_cs_in    => iusft_cs_in,
        iusft_op_in    => iusft_op_in,
        iusft_di_in    => iusft_di_in,
        iusft_shcnt_in => iusft_shcnt_in,
        iusft_do_out   => iusft_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../../dat/iusft_test.dat";
        file fout : text open write_mode is "../../../../../log/iusft_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable cs_sig    : std_logic;
        variable op_sig    : std_logic_vector( 2 downto 0);
        variable shcnt_sig : std_logic_vector( 4 downto 0);
        variable di_sig    : std_logic_vector(31 downto 0);

        -- output signal
        variable do_sig    : std_logic_vector(31 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, cs_sig   );
            read (li, op_sig   );
            read (li, di_sig   );
            read (li, shcnt_sig);

            -- result
            read (li, do_sig  );

            iusft_cs_in    <= cs_sig;
            iusft_op_in    <= op_sig;
            iusft_di_in    <= di_sig;
            iusft_shcnt_in <= shcnt_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iusft_do_out /= do_sig ) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iusft_do_out);
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
