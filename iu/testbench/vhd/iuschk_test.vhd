library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iuschk_test is
end iuschk_test;

architecture behavior of iuschk_test is 

    component iuschk
        port(
             iuschk_intr_req_in : in    std_logic;
             iuschk_rett_in     : in    std_logic;
             iuschk_psr_in      : in    std_logic;
             iuschk_read_in     : in    std_logic;
             iuschk_write_in    : in    std_logic;
             iuschk_a_in        : in    std_logic;
             iuschk_s_in        : in    std_logic;
             iuschk_rett_en_out :   out std_logic;
             iuschk_psr_en_out  :   out std_logic;
             iuschk_lda_en_out  :   out std_logic;
             iuschk_sta_en_out  :   out std_logic
        );
    end component;

    --inputs
    signal iuschk_intr_req_in : std_logic := '0';
    signal iuschk_rett_in     : std_logic := '0';
    signal iuschk_psr_in      : std_logic := '0';
    signal iuschk_read_in     : std_logic := '0';
    signal iuschk_write_in    : std_logic := '0';
    signal iuschk_a_in        : std_logic := '0';
    signal iuschk_s_in        : std_logic := '0';

    --outputs
    signal iuschk_rett_en_out : std_logic;
    signal iuschk_psr_en_out  : std_logic;
    signal iuschk_lda_en_out  : std_logic;
    signal iuschk_sta_en_out  : std_logic;

begin

    -- instantiate the unit under test (uut)
    uut: iuschk port map (
        iuschk_intr_req_in => iuschk_intr_req_in,
        iuschk_rett_in     => iuschk_rett_in,
        iuschk_psr_in      => iuschk_psr_in,
        iuschk_read_in     => iuschk_read_in,
        iuschk_write_in    => iuschk_write_in,
        iuschk_a_in        => iuschk_a_in,
        iuschk_s_in        => iuschk_s_in,
        iuschk_rett_en_out => iuschk_rett_en_out,
        iuschk_psr_en_out  => iuschk_psr_en_out,
        iuschk_lda_en_out  => iuschk_lda_en_out,
        iuschk_sta_en_out  => iuschk_sta_en_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iuschk_test.dat";
        file fout : text open write_mode is "../../../../log/iuschk_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable intr_req_sig : std_logic;
        variable rett_sig     : std_logic;
        variable psr_sig      : std_logic;
        variable read_sig     : std_logic;
        variable write_sig    : std_logic;
        variable a_sig        : std_logic;
        variable s_sig        : std_logic;

        -- output signal
        variable rett_en_sig : std_logic;
        variable psr_en_sig  : std_logic;
        variable lda_en_sig  : std_logic;
        variable sta_en_sig  : std_logic;

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, intr_req_sig);
            read (li, rett_sig    );
            read (li, psr_sig     );
            read (li, read_sig    );
            read (li, write_sig   );
            read (li, a_sig       );
            read (li, s_sig       );

            -- result
            read (li, rett_en_sig);
            read (li, psr_en_sig );
            read (li, lda_en_sig );
            read (li, sta_en_sig );

            iuschk_intr_req_in <= intr_req_sig;
            iuschk_rett_in     <= rett_sig;
            iuschk_psr_in      <= psr_sig;
            iuschk_read_in     <= read_sig;
            iuschk_write_in    <= write_sig;
            iuschk_a_in        <= a_sig;
            iuschk_s_in        <= s_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if ((iuschk_rett_en_out /= rett_en_sig)
            and (iuschk_psr_en_out  /= psr_en_sig )
            and (iuschk_lda_en_out  /= lda_en_sig )
            and (iuschk_sta_en_out  /= sta_en_sig )) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iuschk_rett_en_out);
                write (lo, str_separate);
                write (lo, iuschk_psr_en_out );
                write (lo, str_separate);
                write (lo, iuschk_lda_en_out );
                write (lo, str_separate);
                write (lo, iuschk_sta_en_out );
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
