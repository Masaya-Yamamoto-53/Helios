library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iuhdu_test is
end iuhdu_test;

architecture behavior of iuhdu_test is 

    component iuhdu
        port(
            iuhdu_ma_excep_in    : in    std_logic;
            iuhdu_ex_excep_in    : in    std_logic;
            iuhdu_ex_branch_in   : in    std_logic;
            iuhdu_id_read_in     : in    std_logic;
            iuhdu_pc_wen_out     :   out std_logic;
            iuhdu_ifid_wen_out   :   out std_logic;
            iuhdu_ifid_flash_out :   out std_logic;
            iuhdu_idex_wen_out   :   out std_logic;
            iuhdu_idex_flash_out :   out std_logic;
            iuhdu_exma_wen_out   :   out std_logic;
            iuhdu_exma_flash_out :   out std_logic;
            iuhdu_mawb_wen_out   :   out std_logic;
            iuhdu_mawb_flash_out :   out std_logic
        );
    end component;

    --inputs
    signal iuhdu_ma_excep_in    : std_logic;
    signal iuhdu_ex_excep_in    : std_logic;
    signal iuhdu_ex_branch_in   : std_logic;
    signal iuhdu_id_read_in     : std_logic;

    --outputs
    signal iuhdu_pc_wen_out     : std_logic;
    signal iuhdu_ifid_wen_out   : std_logic;
    signal iuhdu_ifid_flash_out : std_logic;
    signal iuhdu_idex_wen_out   : std_logic;
    signal iuhdu_idex_flash_out : std_logic;
    signal iuhdu_exma_wen_out   : std_logic;
    signal iuhdu_exma_flash_out : std_logic;
    signal iuhdu_mawb_wen_out   : std_logic;
    signal iuhdu_mawb_flash_out : std_logic;

begin

    -- instantiate the unit under test (uut)
    uut: iuhdu port map (
        iuhdu_ma_excep_in    => iuhdu_ma_excep_in,
        iuhdu_ex_excep_in    => iuhdu_ex_excep_in,
        iuhdu_ex_branch_in   => iuhdu_ex_branch_in,
        iuhdu_id_read_in     => iuhdu_id_read_in,
        iuhdu_pc_wen_out     => iuhdu_pc_wen_out,
        iuhdu_ifid_wen_out   => iuhdu_ifid_wen_out,
        iuhdu_ifid_flash_out => iuhdu_ifid_flash_out,
        iuhdu_idex_wen_out   => iuhdu_idex_wen_out,
        iuhdu_idex_flash_out => iuhdu_idex_flash_out,
        iuhdu_exma_wen_out   => iuhdu_exma_wen_out,
        iuhdu_exma_flash_out => iuhdu_exma_flash_out,
        iuhdu_mawb_wen_out   => iuhdu_mawb_wen_out,
        iuhdu_mawb_flash_out => iuhdu_mawb_flash_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iuhdu_test.dat";
        file fout : text open write_mode is "../../../../log/iuhdu_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable ma_excep_sig  : std_logic;
        variable ex_excep_sig  : std_logic;
        variable ex_branch_sig : std_logic;
        variable id_read_sig   : std_logic;

        -- output signal
        variable pc_wen_sig     : std_logic;
        variable ifid_wen_sig   : std_logic;
        variable ifid_flash_sig : std_logic;
        variable idex_wen_sig   : std_logic;
        variable idex_flash_sig : std_logic;
        variable exma_wen_sig   : std_logic;
        variable exma_flash_sig : std_logic;
        variable mawb_wen_sig   : std_logic;
        variable mawb_flash_sig : std_logic;

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, ma_excep_sig );
            read (li, ex_excep_sig );
            read (li, ex_branch_sig);
            read (li, id_read_sig  );

            -- result
            read (li, pc_wen_sig    );
            read (li, ifid_wen_sig  );
            read (li, ifid_flash_sig);
            read (li, idex_wen_sig  );
            read (li, idex_flash_sig);
            read (li, exma_wen_sig  );
            read (li, exma_flash_sig);
            read (li, mawb_wen_sig  );
            read (li, mawb_flash_sig);

            iuhdu_ma_excep_in  <= ma_excep_sig;
            iuhdu_ex_excep_in  <= ex_excep_sig;
            iuhdu_ex_branch_in <= ex_branch_sig;
            iuhdu_id_read_in   <= id_read_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if ((iuhdu_pc_wen_out     /= pc_wen_sig    )
             or (iuhdu_ifid_wen_out   /= ifid_wen_sig  )
             or (iuhdu_ifid_flash_out /= ifid_flash_sig)
             or (iuhdu_idex_wen_out   /= idex_wen_sig  )
             or (iuhdu_idex_flash_out /= idex_flash_sig)
             or (iuhdu_exma_wen_out   /= exma_wen_sig  )
             or (iuhdu_exma_flash_out /= exma_flash_sig)
             or (iuhdu_mawb_wen_out   /= mawb_wen_sig  )
             or (iuhdu_mawb_flash_out /= mawb_flash_sig)) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, pc_wen_sig    );
                write (lo, ifid_wen_sig  );
                write (lo, ifid_flash_sig);
                write (lo, idex_wen_sig  );
                write (lo, idex_flash_sig);
                write (lo, exma_wen_sig  );
                write (lo, exma_flash_sig);
                write (lo, mawb_wen_sig  );
                write (lo, mawb_flash_sig);
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
