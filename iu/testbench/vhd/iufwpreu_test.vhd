library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iufwu_pac.all;

entity iufwpreu_test is
end iufwpreu_test;

architecture behavior of iufwpreu_test is 

    component iufwpreu
        port(
            iufwpreu_rs1_sel_in : in    std_logic_vector( 4 downto 0);
            iufwpreu_rs2_sel_in : in    std_logic_vector( 4 downto 0);
            iufwpreu_rs3_sel_in : in    std_logic_vector( 4 downto 0);

            iufwpreu_ex_rd_in   : in    st_iufwpre_if;
            iufwpreu_ma_rd_in   : in    st_iufwpre_if;

            iufwpreu_rs1_fw_out :   out std_logic_vector( 3 downto 0);
            iufwpreu_rs2_fw_out :   out std_logic_vector( 3 downto 0);
            iufwpreu_rs3_fw_out :   out std_logic_vector( 3 downto 0)
        );
    end component;

    --inputs
    signal iufwpreu_rs1_sel_in : std_logic_vector( 4 downto 0);
    signal iufwpreu_rs2_sel_in : std_logic_vector( 4 downto 0);
    signal iufwpreu_rs3_sel_in : std_logic_vector( 4 downto 0);
    signal iufwpreu_ex_rd_in   : st_iufwpre_if;
    signal iufwpreu_ma_rd_in   : st_iufwpre_if;

    --outputs
    signal iufwpreu_rs1_fw_out : std_logic_vector( 3 downto 0);
    signal iufwpreu_rs2_fw_out : std_logic_vector( 3 downto 0);
    signal iufwpreu_rs3_fw_out : std_logic_vector( 3 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iufwpreu port map (
        iufwpreu_rs1_sel_in => iufwpreu_rs1_sel_in,
        iufwpreu_rs2_sel_in => iufwpreu_rs2_sel_in,
        iufwpreu_rs3_sel_in => iufwpreu_rs3_sel_in,
        iufwpreu_ex_rd_in   => iufwpreu_ex_rd_in,
        iufwpreu_ma_rd_in   => iufwpreu_ma_rd_in,
        iufwpreu_rs1_fw_out => iufwpreu_rs1_fw_out,
        iufwpreu_rs2_fw_out => iufwpreu_rs2_fw_out,
        iufwpreu_rs3_fw_out => iufwpreu_rs3_fw_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iufwpreu_test.dat";
        file fout : text open write_mode is "../../../../log/iufwpreu_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable rs1_sel_sig : std_logic_vector( 4 downto 0);
        variable rs2_sel_sig : std_logic_vector( 4 downto 0);
        variable rs3_sel_sig : std_logic_vector( 4 downto 0);
        variable ex_rd_sig   : st_iufwpre_if;
        variable ma_rd_sig   : st_iufwpre_if;

        -- output signal
        variable rs1_fw_sig : std_logic_vector( 3 downto 0);
        variable rs2_fw_sig : std_logic_vector( 3 downto 0);
        variable rs3_fw_sig : std_logic_vector( 3 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read(li, rs1_sel_sig);
            read(li, rs2_sel_sig);
            read(li, rs3_sel_sig);
            read(li, ex_rd_sig.we );
            read(li, ex_rd_sig.sel);
            read(li, ma_rd_sig.we );
            read(li, ma_rd_sig.sel);

            -- result
            read (li, rs1_fw_sig);
            read (li, rs2_fw_sig);
            read (li, rs3_fw_sig);

            iufwpreu_rs1_sel_in <= rs1_sel_sig;
            iufwpreu_rs2_sel_in <= rs2_sel_sig;
            iufwpreu_rs3_sel_in <= rs3_sel_sig;
            iufwpreu_ex_rd_in   <= ex_rd_sig;
            iufwpreu_ma_rd_in   <= ma_rd_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if ((iufwpreu_rs1_fw_out /= rs1_fw_sig)
            and (iufwpreu_rs2_fw_out /= rs2_fw_sig)
            and (iufwpreu_rs3_fw_out /= rs3_fw_sig)) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iufwpreu_rs1_fw_out);
                write (lo, str_separate);
                write (lo, iufwpreu_rs2_fw_out);
                write (lo, str_separate);
                write (lo, iufwpreu_rs3_fw_out);
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
