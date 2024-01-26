library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iupc_test is
end iupc_test;

architecture behavior of iupc_test is 

    component iupc
        port(
            iupc_clk_in  : in    std_logic;
            iupc_rst_in  : in    std_logic;
            iupc_wen_in  : in    std_logic;
            iupc_di_in   : in    std_logic_vector (29 downto 0);
            iupc_do_out  :   out std_logic_vector (29 downto 0)
        );
    end component;

    --inputs
    signal iupc_clk_in  : std_logic;
    signal iupc_rst_in  : std_logic;
    signal iupc_wen_in  : std_logic;
    signal iupc_di_in   : std_logic_vector (29 downto 0);

    --outputs
    signal iupc_do_out  : std_logic_vector (29 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iupc port map (
        iupc_clk_in  => iupc_clk_in,
        iupc_rst_in  => iupc_rst_in,
        iupc_wen_in  => iupc_wen_in,
        iupc_di_in   => iupc_di_in,
        iupc_do_out  => iupc_do_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../../dat/iupc_test.dat";
        file fout : text open write_mode is "../../../../../log/iupc_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable clk_sig  : std_logic;
        variable rst_sig  : std_logic;
        variable wen_sig  : std_logic;
        variable di_sig   : std_logic_vector (29 downto 0);

        -- output signal
        variable do_sig   : std_logic_vector (29 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, clk_sig );
            read (li, rst_sig );
            read (li, wen_sig );
            read (li, di_sig  );

            -- result
            read (li, do_sig   );

            iupc_clk_in  <= clk_sig;
            iupc_rst_in  <= rst_sig;
            iupc_wen_in  <= wen_sig;
            iupc_di_in   <= di_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if (iupc_do_out /= do_sig) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iupc_do_out);
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
