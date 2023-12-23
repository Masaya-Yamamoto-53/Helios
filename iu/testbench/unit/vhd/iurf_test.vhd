library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iumawb_pac.all;

use work.iurf_pac.all;
use work.iumawb_pac.all;

entity iurf_test is
end iurf_test;

architecture behavior of iurf_test is 

    component iurf
        port(
            iurf_clk_in     : in    std_logic;
            iurf_rs1_sel_in : in    std_logic_vector ( 4 downto 0);
            iurf_rs2_sel_in : in    std_logic_vector ( 4 downto 0);
            iurf_rs3_sel_in : in    std_logic_vector ( 4 downto 0);
            iurf_w_in       : in    st_iumawb_if;
            iurf_pc_in      : in    std_logic_vector (29 downto 0);
            iurf_rs1_do_out :   out std_logic_vector (31 downto 0);
            iurf_rs2_do_out :   out std_logic_vector (31 downto 0);
            iurf_rs3_do_out :   out std_logic_vector (31 downto 0)
        );
    end component;

    --inputs
    signal iurf_clk_in     : std_logic;
    signal iurf_rs1_sel_in : std_logic_vector ( 4 downto 0);
    signal iurf_rs2_sel_in : std_logic_vector ( 4 downto 0);
    signal iurf_rs3_sel_in : std_logic_vector ( 4 downto 0);
    signal iurf_w_in       : st_iumawb_if;
    signal iurf_pc_in      : std_logic_vector (29 downto 0);

    --outputs
    signal iurf_rs1_do_out : std_logic_vector (31 downto 0);
    signal iurf_rs2_do_out : std_logic_vector (31 downto 0);
    signal iurf_rs3_do_out : std_logic_vector (31 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iurf port map (
        iurf_clk_in     => iurf_clk_in,
        iurf_rs1_sel_in => iurf_rs1_sel_in,
        iurf_rs2_sel_in => iurf_rs2_sel_in,
        iurf_rs3_sel_in => iurf_rs3_sel_in,
        iurf_w_in       => iurf_w_in,
        iurf_pc_in      => iurf_pc_in,
        iurf_rs1_do_out => iurf_rs1_do_out,
        iurf_rs2_do_out => iurf_rs2_do_out,
        iurf_rs3_do_out => iurf_rs3_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iurf_test.dat";
        file fout : text open write_mode is "../../../../log/iurf_test.log";
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
        variable pc_sig      : std_logic_vector (29 downto 0);

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
            read (li, pc_sig       );

            -- result
            read (li, rs1_do_sig   );
            read (li, rs2_do_sig   );
            read (li, rs3_do_sig   );

            iurf_clk_in     <= clk_sig;
            iurf_rs1_sel_in <= rs1_sel_sig;
            iurf_rs2_sel_in <= rs2_sel_sig;
            iurf_rs3_sel_in <= rs3_sel_sig;
            iurf_w_in       <= w_sig;
            iurf_pc_in      <= pc_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if ((iurf_rs1_do_out /= rs1_do_sig)
             or (iurf_rs2_do_out /= rs2_do_sig)
             or (iurf_rs3_do_out /= rs3_do_sig)) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iurf_rs1_do_out);
                write (lo, str_separate);
                write (lo, iurf_rs2_do_out);
                write (lo, str_separate);
                write (lo, iurf_rs3_do_out);
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
