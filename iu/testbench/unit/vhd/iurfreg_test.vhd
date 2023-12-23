library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iu_pac.all;
use work.iumawb_pac.all;
use work.iurfreg_pac.all;

entity iurfreg_test is
end iurfreg_test;

architecture behavior of iurfreg_test is 

    component iurfreg
        port(
            iurfreg_clk_in     : in    std_logic;
            iurfreg_rs1_sel_in : in    std_logic_vector ( 4 downto 0);
            iurfreg_rs2_sel_in : in    std_logic_vector ( 4 downto 0);
            iurfreg_rs3_sel_in : in    std_logic_vector ( 4 downto 0);
            iurfreg_w_in       : in    st_iumawb_if;
            iurfreg_rs1_do_out :   out std_logic_vector (31 downto 0);
            iurfreg_rs2_do_out :   out std_logic_vector (31 downto 0);
            iurfreg_rs3_do_out :   out std_logic_vector (31 downto 0)
        );
    end component;

    --inputs
    signal iurfreg_clk_in     : std_logic;
    signal iurfreg_rs1_sel_in : std_logic_vector ( 4 downto 0);
    signal iurfreg_rs2_sel_in : std_logic_vector ( 4 downto 0);
    signal iurfreg_rs3_sel_in : std_logic_vector ( 4 downto 0);
    signal iurfreg_w_in       : st_iumawb_if;

    --outputs
    signal iurfreg_rs1_do_out : std_logic_vector (31 downto 0);
    signal iurfreg_rs2_do_out : std_logic_vector (31 downto 0);
    signal iurfreg_rs3_do_out : std_logic_vector (31 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iurfreg port map (
        iurfreg_clk_in     => iurfreg_clk_in,
        iurfreg_rs1_sel_in => iurfreg_rs1_sel_in,
        iurfreg_rs2_sel_in => iurfreg_rs2_sel_in,
        iurfreg_rs3_sel_in => iurfreg_rs3_sel_in,
        iurfreg_w_in       => iurfreg_w_in,
        iurfreg_rs1_do_out => iurfreg_rs1_do_out,
        iurfreg_rs2_do_out => iurfreg_rs2_do_out,
        iurfreg_rs3_do_out => iurfreg_rs3_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iurfreg_test.dat";
        file fout : text open write_mode is "../../../../log/iurfreg_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable clk_sig     : std_logic;
        variable rs1_sel_sig : std_logic_vector ( 4 downto 0);
        variable rs2_sel_sig : std_logic_vector ( 4 downto 0);
        variable rs3_sel_sig : std_logic_vector ( 4 downto 0);
        variable w_sig       : st_iumawb_if;

        -- output signal
        variable rs1_do_sig : std_logic_vector (31 downto 0);
        variable rs2_do_sig : std_logic_vector (31 downto 0);
        variable rs3_do_sig : std_logic_vector (31 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, clk_sig      );
            read (li, rs1_sel_sig  );
            read (li, rs2_sel_sig  );
            read (li, rs3_sel_sig  );
            read (li, w_sig.rd_we  );
            read (li, w_sig.rd_sel );
            read (li, w_sig.rd_data);

            -- result
            read (li, rs1_do_sig   );
            read (li, rs2_do_sig   );
            read (li, rs3_do_sig   );

            iurfreg_clk_in     <= clk_sig;
            iurfreg_rs1_sel_in <= rs1_sel_sig;
            iurfreg_rs2_sel_in <= rs2_sel_sig;
            iurfreg_rs3_sel_in <= rs3_sel_sig;
            iurfreg_w_in       <= w_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if ((iurfreg_rs1_do_out /= rs1_do_sig)
             or (iurfreg_rs2_do_out /= rs2_do_sig)
             or (iurfreg_rs3_do_out /= rs3_do_sig)) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iurfreg_rs1_do_out);
                write (lo, str_separate);
                write (lo, iurfreg_rs2_do_out);
                write (lo, str_separate);
                write (lo, iurfreg_rs3_do_out);
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
