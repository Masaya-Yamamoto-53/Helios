library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iufwu_pac.all;

entity iufwupre_test is
end iufwupre_test;

architecture behavior of iufwupre_test is 

    component iufwupre
        port(
            iufwupre_sel_in   : in    std_logic_vector ( 4 downto 0);
            iufwupre_ex_rd_in : in    st_iufwupre_if;
            iufwupre_ma_rd_in : in    st_iufwupre_if;
            iufwupre_fw_out   :   out std_logic_vector ( 1 downto 0)
        );
    end component;

    --inputs
    signal iufwupre_sel_in   : std_logic_vector ( 4 downto 0);
    signal iufwupre_ex_rd_in : st_iufwupre_if;
    signal iufwupre_ma_rd_in : st_iufwupre_if;

    --outputs
    signal iufwupre_fw_out   : std_logic_vector ( 1 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iufwupre port map (
        iufwupre_sel_in   => iufwupre_sel_in,
        iufwupre_ex_rd_in => iufwupre_ex_rd_in,
        iufwupre_ma_rd_in => iufwupre_ma_rd_in,
        iufwupre_fw_out   => iufwupre_fw_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "./test/dat/iufwupre_test.dat";
        file fout : text open write_mode is "./test/log/iufwupre_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable sel_sig   : std_logic_vector ( 4 downto 0);
        variable ex_rd_sig : st_iufwupre_if;
        variable ma_rd_sig : st_iufwupre_if;

        -- output signal
        variable fw_sig    : std_logic_vector ( 1 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, sel_sig );
            read (li, ex_rd_sig.we);
            read (li, ex_rd_sig.sel);
            read (li, ma_rd_sig.we);
            read (li, ma_rd_sig.sel);

            -- result
            read (li, fw_sig (IUFWU_PRE_1));
            read (li, fw_sig (IUFWU_PRE_2));

            iufwupre_sel_in   <= sel_sig;
            iufwupre_ex_rd_in <= ex_rd_sig;
            iufwupre_ma_rd_in <= ma_rd_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);
            write (lo, str_separate);

            if ((iufwupre_fw_out (IUFWU_PRE_1) /= fw_sig (IUFWU_PRE_1))
             or (iufwupre_fw_out (IUFWU_PRE_2) /= fw_sig (IUFWU_PRE_2))) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iufwupre_fw_out (IUFWU_PRE_1));
                write (lo, str_separate);
                write (lo, iufwupre_fw_out (IUFWU_PRE_2));
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
