library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iualu_test is
end iualu_test;

architecture behavior of iualu_test is 

    component iualu
        port(
             iualu_cs_in  : in    std_logic;
             iualu_op_in  : in    std_logic_vector ( 2 downto 0);
             iualu_di1_in : in    std_logic_vector (31 downto 0);
             iualu_di2_in : in    std_logic_vector (31 downto 0);
             iualu_do_out :   out std_logic_vector (31 downto 0)
        );
    end component;

    --inputs
    signal iualu_di1_in : std_logic_vector (31 downto 0) := (others => '0');
    signal iualu_di2_in : std_logic_vector (31 downto 0) := (others => '0');
    signal iualu_op_in  : std_logic_vector ( 2 downto 0) := (others => '0');
    signal iualu_cs_in  : std_logic := '0';

    --outputs
    signal iualu_do_out : std_logic_vector (31 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iualu port map (
        iualu_cs_in  => iualu_cs_in,
        iualu_op_in  => iualu_op_in,
        iualu_di1_in => iualu_di1_in,
        iualu_di2_in => iualu_di2_in,
        iualu_do_out => iualu_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iualu_test.dat";
        file fout : text open write_mode is "../../../../log/iualu_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable cs_sig  : std_logic;
        variable op_sig  : std_logic_vector ( 2 downto 0);
        variable di1_sig : std_logic_vector (31 downto 0);
        variable di2_sig : std_logic_vector (31 downto 0);

        -- output signal
        variable do_sig  : std_logic_vector (31 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, cs_sig );
            read (li, op_sig );
            read (li, di1_sig);
            read (li, di2_sig);

            -- result
            read (li, do_sig   );

            iualu_cs_in  <= cs_sig;
            iualu_op_in  <= op_sig;
            iualu_di1_in <= di1_sig;
            iualu_di2_in <= di2_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iualu_do_out /= do_sig) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iualu_do_out);
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
