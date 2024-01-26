library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iufwu_pac.all;

entity iufwpast_test is
end iufwpast_test;

architecture behavior of iufwpast_test is 

    component iufwpast
        port(
            iufwpast_fw_in      : in    std_logic_vector( 1 downto 0);
            iufwpast_ex_data_in : in    std_logic_vector(31 downto 0);
            iufwpast_ma_rd_in   : in    st_iufwpast_if;
            iufwpast_wb_rd_in   : in    st_iufwpast_if;
            iufwpast_data_out   :   out std_logic_vector(31 downto 0)
        );
    end component;

    --inputs
    signal iufwpast_fw_in      : std_logic_vector( 1 downto 0) := (others => '0');
    signal iufwpast_ex_data_in : std_logic_vector(31 downto 0) := (others => '0');
    signal iufwpast_ma_rd_in   : st_iufwpast_if := st_iufwpast_if_INIT;
    signal iufwpast_wb_rd_in   : st_iufwpast_if := st_iufwpast_if_INIT;

    --outputs
    signal iufwpast_data_out : std_logic_vector(31 downto 0) := (others => '0');

begin

    -- instantiate the unit under test (uut)
    uut: iufwpast port map (
        iufwpast_fw_in      => iufwpast_fw_in,
        iufwpast_ex_data_in => iufwpast_ex_data_in,
        iufwpast_ma_rd_in   => iufwpast_ma_rd_in,
        iufwpast_wb_rd_in   => iufwpast_wb_rd_in,
        iufwpast_data_out   => iufwpast_data_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../../dat/iufwpast_test.dat";
        file fout : text open write_mode is "../../../../../log/iufwpast_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable fw_sig      : std_logic_vector( 1 downto 0) := (others => '0');
        variable ex_data_sig : std_logic_vector(31 downto 0) := (others => '0');
        variable ma_rd_sig   : st_iufwpast_if := st_iufwpast_if_INIT;
        variable wb_rd_sig   : st_iufwpast_if := st_iufwpast_if_INIT;

        -- output signal
        variable data_sig   : std_logic_vector(31 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read(li, fw_sig     );
            read(li, ex_data_sig);
            read(li, ma_rd_sig.we  );
            read(li, ma_rd_sig.data);
            read(li, wb_rd_sig.we  );
            read(li, wb_rd_sig.data);

            -- result
            read (li, data_sig);

            iufwpast_fw_in      <= fw_sig;
            iufwpast_ex_data_in <= ex_data_sig;
            iufwpast_ma_rd_in   <= ma_rd_sig;
            iufwpast_wb_rd_in   <= wb_rd_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iufwpast_data_out /= data_sig) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iufwpast_data_out);
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
