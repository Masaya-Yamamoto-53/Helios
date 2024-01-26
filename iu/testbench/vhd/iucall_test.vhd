library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iucall_test is
end iucall_test;

architecture behavior of iucall_test is 

    component iucall
        port(
            iucall_op_in     : in    std_logic_vector ( 1 downto 0);
            iucall_addr_in   : in    std_logic_vector (29 downto 0);
            iucall_token_out :   out std_logic;
            iucall_addr_out  :   out std_logic_vector (29 downto 0)
        );
    end component;

    --inputs
    signal iucall_op_in   : std_logic_vector ( 1 downto 0);
    signal iucall_addr_in : std_logic_vector (29 downto 0);

    --outputs
    signal iucall_token_out : std_logic;
    signal iucall_addr_out  : std_logic_vector (29 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iucall port map (
        iucall_op_in     => iucall_op_in,
        iucall_addr_in   => iucall_addr_in,
        iucall_token_out => iucall_token_out,
        iucall_addr_out  => iucall_addr_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../../dat/iucall_test.dat";
        file fout : text open write_mode is "../../../../../log/iucall_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable op_sig      : std_logic_vector ( 1 downto 0);
        variable addr_in_sig : std_logic_vector (29 downto 0);

        -- output signal
        variable token_sig    : std_logic;
        variable addr_out_sig : std_logic_vector (29 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, op_sig );
            read (li, addr_in_sig);

            -- result
            read (li, token_sig);
            read (li, addr_out_sig );

            iucall_op_in   <= op_sig;
            iucall_addr_in <= addr_in_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if ((iucall_token_out /= token_sig   )
             or (iucall_addr_out  /= addr_out_sig)) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iucall_token_out);
                write (lo, str_separate);
                write (lo, iucall_addr_out);
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
