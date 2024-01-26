library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iufwu_pac.all;

entity iufwpre_test is
end iufwpre_test;

architecture behavior of iufwpre_test is 

    component iufwpre
        port(
            iufwpre_sel_in   : in    std_logic_vector( 4 downto 0);
            iufwpre_ex_rd_in : in    st_iufwpre_if;
            iufwpre_ma_rd_in : in    st_iufwpre_if;
            iufwpre_fw_out   :   out std_logic_vector( 1 downto 0)
        );
    end component;

    --inputs
    signal iufwpre_sel_in   : std_logic_vector( 4 downto 0);
    signal iufwpre_ex_rd_in : st_iufwpre_if;
    signal iufwpre_ma_rd_in : st_iufwpre_if;

    --outputs
    signal iufwpre_fw_out   : std_logic_vector( 1 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iufwpre port map (
        iufwpre_sel_in   => iufwpre_sel_in,
        iufwpre_ex_rd_in => iufwpre_ex_rd_in,
        iufwpre_ma_rd_in => iufwpre_ma_rd_in,
        iufwpre_fw_out   => iufwpre_fw_out
    );
    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../../dat/iufwpre_test.dat";
        file fout : text open write_mode is "../../../../../log/iufwpre_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable sel_sig   : std_logic_vector( 4 downto 0);
        variable ex_rd_sig : st_iufwpre_if;
        variable ma_rd_sig : st_iufwpre_if;

        -- output signal
        variable fw_sig : std_logic_vector( 1 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read(li, sel_sig  );
            read(li, ex_rd_sig.we);
            read(li, ex_rd_sig.sel);
            read(li, ma_rd_sig.we);
            read(li, ma_rd_sig.sel);

            -- result
            read (li, fw_sig);

            iufwpre_sel_in   <= sel_sig;
            iufwpre_ex_rd_in <= ex_rd_sig;
            iufwpre_ma_rd_in <= ma_rd_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iufwpre_fw_out /= fw_sig) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iufwpre_fw_out);
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
