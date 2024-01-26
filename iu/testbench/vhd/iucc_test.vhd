library ieee, std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_textio.all;
use std.textio.all;

entity iucc_test is
end iucc_test;

architecture behavior of iucc_test is 

    component iucc
        port(
            iucc_di1_msb_in : in    std_logic;
            iucc_di2_msb_in : in    std_logic;
            iucc_rlt_in     : in    std_logic_vector (31 downto 0);
            iucc_n_out      :   out std_logic;
            iucc_z_out      :   out std_logic;
            iucc_v_out      :   out std_logic;
            iucc_c_out      :   out std_logic
        );
    end component;

    --inputs
    signal iucc_di1_msb_in : std_logic := '0';
    signal iucc_di2_msb_in : std_logic := '0';
    signal iucc_rlt_in     : std_logic_vector (31 downto 0) := (others => '0');

    --outputs
    signal iucc_n_out      : std_logic := '0';
    signal iucc_z_out      : std_logic := '0';
    signal iucc_v_out      : std_logic := '0';
    signal iucc_c_out      : std_logic := '0';

begin

    -- instantiate the unit under test (uut)
    uut: iucc port map (
        iucc_di1_msb_in => iucc_di1_msb_in,
        iucc_di2_msb_in => iucc_di2_msb_in,
        iucc_rlt_in     => iucc_rlt_in,
        iucc_n_out      => iucc_n_out,
        iucc_z_out      => iucc_z_out,
        iucc_v_out      => iucc_v_out,
        iucc_c_out      => iucc_c_out
    );

    stim_proc: process
        file fin  : text open read_mode is  "../../../../../dat/iucc_test.dat";
        file fout : text open write_mode is "../../../../../log/iucc_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable di1_sig : std_logic_vector (31 downto 0);
        variable di2_sig : std_logic_vector (31 downto 0);
        variable rlt_sig : std_logic_vector (31 downto 0);

        -- output signal
        variable n_sig : std_logic;
        variable z_sig : std_logic;
        variable v_sig : std_logic;
        variable c_sig : std_logic;

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, di1_sig);
            read (li, di2_sig);

            -- result
            read (li, n_sig);
            read (li, z_sig);
            read (li, v_sig);
            read (li, c_sig);

            rlt_sig := std_logic_vector (unsigned (di1_sig) - unsigned (di2_sig));

            iucc_di1_msb_in <= di1_sig (31);
            iucc_di2_msb_in <= di2_sig (31);
            iucc_rlt_in     <= rlt_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if ((iucc_n_out /= n_sig)
             or (iucc_z_out /= z_sig)
             or (iucc_v_out /= v_sig)
             or (iucc_c_out /= c_sig)) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iucc_n_out);
                write (lo, iucc_z_out);
                write (lo, iucc_v_out);
                write (lo, iucc_c_out);
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
