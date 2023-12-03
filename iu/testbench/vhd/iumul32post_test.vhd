library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iumul32post_test is
end iumul32post_test;

architecture behavior of iumul32post_test is 

    component iumul32post
        port(
            iumul32post_hi_in   : in    std_logic;
            iumul32post_mul1_in : in    std_logic_vector (31 downto 0);
            iumul32post_mul2_in : in    std_logic_vector (31 downto 0);
            iumul32post_mul3_in : in    std_logic_vector (31 downto 0);
            iumul32post_mul4_in : in    std_logic_vector (31 downto 0);
            iumul32post_do_out  :   out std_logic_vector (31 downto 0)
        );
    end component;

    --inputs
    signal iumul32post_hi_in   : std_logic := '0';
    signal iumul32post_mul1_in : std_logic_vector (31 downto 0) := (others => '0');
    signal iumul32post_mul2_in : std_logic_vector (31 downto 0) := (others => '0');
    signal iumul32post_mul3_in : std_logic_vector (31 downto 0) := (others => '0');
    signal iumul32post_mul4_in : std_logic_vector (31 downto 0) := (others => '0');

    --outputs
    signal iumul32post_do_out  : std_logic_vector (31 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iumul32post port map (
        iumul32post_hi_in   => iumul32post_hi_in,
        iumul32post_mul1_in => iumul32post_mul1_in,
        iumul32post_mul2_in => iumul32post_mul2_in,
        iumul32post_mul3_in => iumul32post_mul3_in,
        iumul32post_mul4_in => iumul32post_mul4_in,
        iumul32post_do_out  => iumul32post_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iumul32post_test.dat";
        file fout : text open write_mode is "../../../../log/iumul32post_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable hi_sig   : std_logic;
        variable mul1_sig : std_logic_vector (31 downto 0);
        variable mul2_sig : std_logic_vector (31 downto 0);
        variable mul3_sig : std_logic_vector (31 downto 0);
        variable mul4_sig : std_logic_vector (31 downto 0);

        -- output signal
        variable do_sig   : std_logic_vector(31 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, hi_sig  );
            read (li, mul1_sig);
            read (li, mul2_sig);
            read (li, mul3_sig);
            read (li, mul4_sig);

            -- result
            read (li, do_sig);

            iumul32post_hi_in   <= hi_sig;
            iumul32post_mul1_in <= mul1_sig;
            iumul32post_mul2_in <= mul2_sig;
            iumul32post_mul3_in <= mul3_sig;
            iumul32post_mul4_in <= mul4_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iumul32post_do_out   /= do_sig) then
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
