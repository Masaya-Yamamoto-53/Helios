library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iurett_test is
end iurett_test;

architecture behavior of iurett_test is 

    component iurett
        port(
            iurett_op_in  : in    std_logic_vector (1 downto 0);
            iurett_op3_in : in    std_logic_vector (5 downto 0);
            iurett_en_out :   out std_logic
        );
    end component;

    --inputs
    signal iurett_op_in  : std_logic_vector (1 downto 0) := (others => '0');
    signal iurett_op3_in : std_logic_vector (5 downto 0) := (others => '0');

    --outputs
    signal iurett_en_out : std_logic;

begin

    -- instantiate the unit under test (uut)
    uut: iurett port map (
        iurett_op_in  => iurett_op_in,
        iurett_op3_in => iurett_op3_in,
        iurett_en_out => iurett_en_out
    );

    stim_proc: process
        file fin  : text open read_mode is  "../../../../../dat/iurett_test.dat";
        file fout : text open write_mode is "../../../../../log/iurett_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable op_sig  : std_logic_vector (1 downto 0);
        variable op3_sig : std_logic_vector (5 downto 0);

        -- output signal
        variable en_sig  :  std_logic;

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, op_sig );
            read (li, op3_sig);

            -- result
            read (li, en_sig  );

            iurett_op_in  <= op_sig;
            iurett_op3_in <= op3_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iurett_en_out /= en_sig ) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iurett_en_out);
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
