library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.iufwu_pac.all;

entity iufwpastu_test is
end iufwpastu_test;

architecture behavior of iufwpastu_test is 

    component iufwpastu
        port(
            iufwpastu_rs1_fw_in  : in    std_logic_vector( 1 downto 0);
            iufwpastu_rs1_di_in  : in    std_logic_vector(31 downto 0);

            iufwpastu_rs2_fw_in  : in    std_logic_vector( 1 downto 0);
            iufwpastu_rs2_di_in  : in    std_logic_vector(31 downto 0);

            iufwpastu_rs3_fw_in  : in    std_logic_vector( 1 downto 0);
            iufwpastu_rs3_di_in  : in    std_logic_vector(31 downto 0);

            iufwpastu_ma_rd_in   : in    st_iufwpast_if;
            iufwpastu_wb_rd_in   : in    st_iufwpast_if;

            iufwpastu_rs1_do_out :   out std_logic_vector(31 downto 0);
            iufwpastu_rs2_do_out :   out std_logic_vector(31 downto 0);
            iufwpastu_rs3_do_out :   out std_logic_vector(31 downto 0)
        );
    end component;

    --inputs
    signal iufwpastu_rs1_fw_in  : std_logic_vector( 1 downto 0) := (others => '0');
    signal iufwpastu_rs1_di_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal iufwpastu_rs2_fw_in  : std_logic_vector( 1 downto 0) := (others => '0');
    signal iufwpastu_rs2_di_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal iufwpastu_rs3_fw_in  : std_logic_vector( 1 downto 0) := (others => '0');
    signal iufwpastu_rs3_di_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal iufwpastu_ma_rd_in   : st_iufwpast_if := st_iufwpast_if_INIT;
    signal iufwpastu_wb_rd_in   : st_iufwpast_if := st_iufwpast_if_INIT;

    --outputs
    signal iufwpastu_rs1_do_out : std_logic_vector(31 downto 0) := (others => '0');
    signal iufwpastu_rs2_do_out : std_logic_vector(31 downto 0) := (others => '0');
    signal iufwpastu_rs3_do_out : std_logic_vector(31 downto 0) := (others => '0');

begin

    -- instantiate the unit under test (uut)
    uut: iufwpastu port map (
        iufwpastu_rs1_fw_in  => iufwpastu_rs1_fw_in,
        iufwpastu_rs1_di_in  => iufwpastu_rs1_di_in,

        iufwpastu_rs2_fw_in  => iufwpastu_rs2_fw_in,
        iufwpastu_rs2_di_in  => iufwpastu_rs2_di_in,

        iufwpastu_rs3_fw_in  => iufwpastu_rs3_fw_in,
        iufwpastu_rs3_di_in  => iufwpastu_rs3_di_in,

        iufwpastu_ma_rd_in   => iufwpastu_ma_rd_in,
        iufwpastu_wb_rd_in   => iufwpastu_wb_rd_in,

        iufwpastu_rs1_do_out => iufwpastu_rs1_do_out,
        iufwpastu_rs2_do_out => iufwpastu_rs2_do_out,
        iufwpastu_rs3_do_out => iufwpastu_rs3_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../../dat/iufwpastu_test.dat";
        file fout : text open write_mode is "../../../../../log/iufwpastu_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable rs1_fw_sig  : std_logic_vector( 1 downto 0) := (others => '0');
        variable rs1_di_sig  : std_logic_vector(31 downto 0) := (others => '0');
        variable rs2_fw_sig  : std_logic_vector( 1 downto 0) := (others => '0');
        variable rs2_di_sig  : std_logic_vector(31 downto 0) := (others => '0');
        variable rs3_fw_sig  : std_logic_vector( 1 downto 0) := (others => '0');
        variable rs3_di_sig  : std_logic_vector(31 downto 0) := (others => '0');
        variable ma_rd_sig   : st_iufwpast_if := st_iufwpast_if_INIT;
        variable wb_rd_sig   : st_iufwpast_if := st_iufwpast_if_INIT;

        -- output signal
        variable rs1_do_sig : std_logic_vector(31 downto 0);
        variable rs2_do_sig : std_logic_vector(31 downto 0);
        variable rs3_do_sig : std_logic_vector(31 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read(li, rs1_fw_sig);
            read(li, rs1_di_sig);
            read(li, rs2_fw_sig);
            read(li, rs2_di_sig);
            read(li, rs3_fw_sig);
            read(li, rs3_di_sig);
            read(li, ma_rd_sig.we  );
            read(li, ma_rd_sig.data);
            read(li, wb_rd_sig.we  );
            read(li, wb_rd_sig.data);

            -- result
            read(li, rs1_do_sig   );
            read(li, rs2_do_sig   );
            read(li, rs3_do_sig   );

            iufwpastu_rs1_fw_in <= rs1_fw_sig;
            iufwpastu_rs1_di_in <= rs1_di_sig;
            iufwpastu_rs2_fw_in <= rs2_fw_sig;
            iufwpastu_rs2_di_in <= rs2_di_sig;
            iufwpastu_rs3_fw_in <= rs3_fw_sig;
            iufwpastu_rs3_di_in <= rs3_di_sig;
            iufwpastu_ma_rd_in  <= ma_rd_sig;
            iufwpastu_wb_rd_in  <= wb_rd_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if ((iufwpastu_rs1_do_out /= rs1_do_sig)
            and (iufwpastu_rs2_do_out /= rs2_do_sig)
            and (iufwpastu_rs3_do_out /= rs3_do_sig)) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iufwpastu_rs1_do_out);
                write (lo, str_separate);
                write (lo, iufwpastu_rs2_do_out);
                write (lo, str_separate);
                write (lo, iufwpastu_rs3_do_out);
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
