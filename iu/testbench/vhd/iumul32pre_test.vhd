library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iumul32pre_test is
end iumul32pre_test;

architecture behavior of iumul32pre_test is 

    component iumul32pre
        port(
            iumul32pre_cs_in    : in    std_logic;
            iumul32pre_hi_in    : in    std_logic;
            iumul32pre_di1_in   : in    std_logic_vector (31 downto 0);
            iumul32pre_di2_in   : in    std_logic_vector (31 downto 0);
            iumul32pre_hi_out   :   out std_logic;
            iumul32pre_mul1_out :   out std_logic_vector (31 downto 0);
            iumul32pre_mul2_out :   out std_logic_vector (31 downto 0);
            iumul32pre_mul3_out :   out std_logic_vector (31 downto 0);
            iumul32pre_mul4_out :   out std_logic_vector (31 downto 0)
        );
    end component;

    --inputs
    signal iumul32pre_cs_in   : std_logic := '0';
    signal iumul32pre_hi_in   : std_logic := '0';
    signal iumul32pre_di1_in  : std_logic_vector (31 downto 0) := (others => '0');
    signal iumul32pre_di2_in  : std_logic_vector (31 downto 0) := (others => '0');

    --outputs
    signal iumul32pre_hi_out   : std_logic;
    signal iumul32pre_mul1_out : std_logic_vector (31 downto 0);
    signal iumul32pre_mul2_out : std_logic_vector (31 downto 0);
    signal iumul32pre_mul3_out : std_logic_vector (31 downto 0);
    signal iumul32pre_mul4_out : std_logic_vector (31 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iumul32pre port map (
        iumul32pre_cs_in    => iumul32pre_cs_in,
        iumul32pre_hi_in    => iumul32pre_hi_in,
        iumul32pre_di1_in   => iumul32pre_di1_in,
        iumul32pre_di2_in   => iumul32pre_di2_in,
        iumul32pre_hi_out   => iumul32pre_hi_out,
        iumul32pre_mul1_out => iumul32pre_mul1_out,
        iumul32pre_mul2_out => iumul32pre_mul2_out,
        iumul32pre_mul3_out => iumul32pre_mul3_out,
        iumul32pre_mul4_out => iumul32pre_mul4_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../../dat/iumul32pre_test.dat";
        file fout : text open write_mode is "../../../../../log/iumul32pre_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable cs_si    : std_logic;
        variable hi_sig   : std_logic;
        variable di1_sig  : std_logic_vector (31 downto 0);
        variable di2_sig  : std_logic_vector (31 downto 0);

        -- output signal
        variable hi_do_sig : std_logic;
        variable mul1_sig  : std_logic_vector (31 downto 0);
        variable mul2_sig  : std_logic_vector (31 downto 0);
        variable mul3_sig  : std_logic_vector (31 downto 0);
        variable mul4_sig  : std_logic_vector (31 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, cs_si   );
            read (li, hi_sig  );
            read (li, di1_sig );
            read (li, di2_sig );

            -- result
            read (li, hi_do_sig);
            read (li, mul1_sig );
            read (li, mul2_sig );
            read (li, mul3_sig );
            read (li, mul4_sig );

            iumul32pre_cs_in   <= cs_si;
            iumul32pre_hi_in   <= hi_sig;
            iumul32pre_di1_in  <= di1_sig;
            iumul32pre_di2_in  <= di2_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if ((iumul32pre_hi_out   /= hi_do_sig)
             or (iumul32pre_mul1_out /= mul1_sig )
             or (iumul32pre_mul2_out /= mul2_sig )
             or (iumul32pre_mul3_out /= mul3_sig )
             or (iumul32pre_mul4_out /= mul4_sig )) then
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
