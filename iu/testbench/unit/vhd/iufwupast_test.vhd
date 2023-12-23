library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iufwu_pac.all;

entity iufwupast_test is
end iufwupast_test;

architecture behavior of iufwupast_test is 

    component iufwupast
        port(
            iufwupast_fw_in      : in    std_logic_vector ( 1 downto 0);
            iufwupast_ex_data_in : in    std_logic_vector (31 downto 0);
            iufwupast_ma_rd_in   : in    st_iufwupast_if;
            iufwupast_wb_rd_in   : in    st_iufwupast_if;
            iufwupast_data_out   :   out std_logic_vector (31 downto 0)
        );
    end component;

    --inputs
    signal iufwupast_fw_in      : std_logic_vector ( 1 downto 0);
    signal iufwupast_ex_data_in : std_logic_vector (31 downto 0);
    signal iufwupast_ma_rd_in   : st_iufwupast_if;
    signal iufwupast_wb_rd_in   : st_iufwupast_if;

    --outputs
    signal iufwupast_data_out   : std_logic_vector (31 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iufwupast port map (
        iufwupast_fw_in      => iufwupast_fw_in,
        iufwupast_ex_data_in => iufwupast_ex_data_in,
        iufwupast_ma_rd_in   => iufwupast_ma_rd_in,
        iufwupast_wb_rd_in   => iufwupast_wb_rd_in,
        iufwupast_data_out   => iufwupast_data_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "./test/dat/iufwupast_test.dat";
        file fout : text open write_mode is "./test/log/iufwupast_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable fw_sig      : std_logic_vector ( 1 downto 0);
        variable ex_data_sig : std_logic_vector (31 downto 0);
        variable ma_rd_sig   : st_iufwupast_if;
        variable wb_rd_sig   : st_iufwupast_if;

        -- output signal
        variable data_sig    : std_logic_vector (31 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, fw_sig        );
            read (li, ex_data_sig   );
            read (li, ma_rd_sig.we  );
            read (li, ma_rd_sig.data);
            read (li, wb_rd_sig.we  );
            read (li, wb_rd_sig.data);

            -- result
            read (li, data_sig);

            iufwupast_fw_in      <= fw_sig;
            iufwupast_ex_data_in <= ex_data_sig;
            iufwupast_ma_rd_in   <= ma_rd_sig;
            iufwupast_wb_rd_in   <= wb_rd_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);
            write (lo, str_separate);

            if (iufwupast_data_out /= data_sig) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iufwupast_data_out);
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
