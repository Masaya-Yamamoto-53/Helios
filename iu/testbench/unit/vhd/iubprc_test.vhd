library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iubprc_test is
end iubprc_test;

architecture behavior of iubprc_test is 

    component iubprc
        port(
            iubprc_op_in      : in    std_logic_vector ( 1 downto 0);
            iubprc_p_in       : in    std_logic;
            iubprc_op2_in     : in    std_logic_vector ( 1 downto 0);
            iubprc_disp19_in  : in    std_logic_vector (18 downto 0);
            iubprc_token_out  :   out std_logic;
            iubprc_addr_out   :   out std_logic_vector (29 downto 0)
        );
    end component;

    --inputs
    signal iubprc_op_in      : std_logic_vector ( 1 downto 0);
    signal iubprc_p_in       : std_logic;
    signal iubprc_rs3_sel_in : std_logic_vector ( 4 downto 0);
    signal iubprc_op2_in     : std_logic_vector ( 1 downto 0);
    signal iubprc_disp19_in  : std_logic_vector (18 downto 0);

    --outputs
    signal iubprc_token_out  : std_logic;
    signal iubprc_addr_out   : std_logic_vector (29 downto 0);

begin

    -- instantiate the unit under test (uut)
    uut: iubprc port map (
        iubprc_op_in      => iubprc_op_in,
        iubprc_p_in       => iubprc_p_in,
        iubprc_op2_in     => iubprc_op2_in,
        iubprc_disp19_in  => iubprc_disp19_in,
        iubprc_token_out  => iubprc_token_out,
        iubprc_addr_out   => iubprc_addr_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../dat/iubprc_test.dat";
        file fout : text open write_mode is "../../../../log/iubprc_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable op_sig      : std_logic_vector ( 1 downto 0);
        variable p_sig       : std_logic;
        variable op2_sig     : std_logic_vector ( 1 downto 0);
        variable disp19_sig  : std_logic_vector (18 downto 0);

        -- output signal
        variable token_sig : std_logic;
        variable addr_sig  : std_logic_vector (29 downto 0);

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, op_sig      );
            read (li, p_sig       );
            read (li, op2_sig     );
            read (li, disp19_sig  );

            -- result
            read (li, token_sig);
            read (li, addr_sig );

            iubprc_op_in      <= op_sig;
            iubprc_p_in       <= p_sig;
            iubprc_op2_in     <= op2_sig;
            iubprc_disp19_in  <= disp19_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if ((iubprc_token_out /= token_sig)
             or (iubprc_addr_out  /= addr_sig )) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iubprc_token_out);
                write (lo, str_separate);
                write (lo, iubprc_addr_out);
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
