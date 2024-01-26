library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity iuintr_test is
end iuintr_test;

architecture behavior of iuintr_test is 

    component iuintr
        port(
            iuintr_clk_in        : in    std_logic;
            iuintr_rst_in        : in    std_logic;

            iuintr_dis_in        : in    std_logic;

            iuintr_excep_req_in  : in    std_logic_vector(15 downto 0);

            iuintr_rett_req_in   : in    std_logic;
            iuintr_rett_we_in    : in    std_logic;
            iuintr_rett_addr_in  : in    std_logic_vector(29 downto 0);

            iuintr_intr_in       : in    std_logic;
            iuintr_irl_in        : in    std_logic_vector( 3 downto 0);
            iuintr_pil_in        : in    std_logic_vector( 3 downto 0);

            iuintr_vec_we_out    :   out std_logic;
            iuintr_vec_addr_out  :   out std_logic_vector(29 downto 0);

            iuintr_intr_req_out  :   out std_logic;
            iuintr_intr_inst_out :   out std_logic_vector(31 downto 0);
            iuintr_intr_ack_out  :   out std_logic
        );
    end component;

    --inputs
    signal iuintr_clk_in        : std_logic := '0';
    signal iuintr_rst_in        : std_logic := '0';
    signal iuintr_dis_in        : std_logic := '0';
    signal iuintr_excep_req_in  : std_logic_vector(15 downto 0) := (others => '0');
    signal iuintr_rett_req_in   : std_logic := '0';
    signal iuintr_rett_we_in    : std_logic := '0';
    signal iuintr_rett_addr_in  : std_logic_vector(29 downto 0) := (others => '0');
    signal iuintr_intr_in       : std_logic := '0';
    signal iuintr_irl_in        : std_logic_vector( 3 downto 0) := (others => '0');
    signal iuintr_pil_in        : std_logic_vector( 3 downto 0) := (others => '0');

    --outputs
    signal iuintr_vec_we_out    : std_logic;
    signal iuintr_vec_addr_out  : std_logic_vector(29 downto 0);
    signal iuintr_intr_req_out  : std_logic;
    signal iuintr_intr_inst_out : std_logic_vector(31 downto 0);
    signal iuintr_intr_ack_out  : std_logic;

begin

    -- instantiate the unit under test (uut)
    uut: iuintr port map (
        iuintr_clk_in        => iuintr_clk_in,
        iuintr_rst_in        => iuintr_rst_in,
        iuintr_dis_in        => iuintr_dis_in,
        iuintr_excep_req_in  => iuintr_excep_req_in,
        iuintr_rett_req_in   => iuintr_rett_req_in,
        iuintr_rett_we_in    => iuintr_rett_we_in,
        iuintr_rett_addr_in  => iuintr_rett_addr_in,
        iuintr_intr_in       => iuintr_intr_in,
        iuintr_irl_in        => iuintr_irl_in,
        iuintr_pil_in        => iuintr_pil_in,
        iuintr_vec_we_out    => iuintr_vec_we_out,
        iuintr_vec_addr_out  => iuintr_vec_addr_out,
        iuintr_intr_req_out  => iuintr_intr_req_out,
        iuintr_intr_inst_out => iuintr_intr_inst_out,
        iuintr_intr_ack_out  => iuintr_intr_ack_out
    );

    -- stimulus process
    stim_proc: process
        file fin  : text open read_mode is  "../../../../../dat/iuintr_test.dat";
        file fout : text open write_mode is "../../../../../log/iuintr_test.log";
        variable str_no       : string (1 to 3) := "No.";
        variable str_separate : string (1 to 1) := ",";
        variable str_failure  : string (1 to 7) := "failure";
        variable str_pass     : string (1 to 4) := "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable clk_sig       : std_logic;
        variable rst_sig       : std_logic;
        variable dis_sig       : std_logic;
        variable excep_req_sig : std_logic_vector(15 downto 0);
        variable rett_req_sig  : std_logic;
        variable rett_we_sig   : std_logic;
        variable rett_addr_sig : std_logic_vector(29 downto 0);
        variable intr_sig      : std_logic;
        variable irl_sig       : std_logic_vector( 3 downto 0);
        variable pil_sig       : std_logic_vector( 3 downto 0);

        -- output signal
        variable vec_we_sig    : std_logic;
        variable vec_addr_sig  : std_logic_vector(29 downto 0);
        variable intr_req_sig  : std_logic;
        variable intr_inst_sig : std_logic_vector(31 downto 0);
        variable intr_ack_sig  : std_logic;

    begin
        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, clk_sig      );
            read (li, rst_sig      );
            read (li, dis_sig      );
            read (li, excep_req_sig);
            read (li, rett_req_sig );
            read (li, rett_we_sig  );
            read (li, rett_addr_sig);
            read (li, intr_sig     );
            read (li, irl_sig      );
            read (li, pil_sig      );

            -- result
            read (li, vec_we_sig   );
            read (li, vec_addr_sig );
            read (li, intr_req_sig );
            read (li, intr_inst_sig);
            read (li, intr_ack_sig );

            iuintr_clk_in        <= clk_sig;
            iuintr_rst_in        <= rst_sig;
            iuintr_dis_in        <= dis_sig;
            iuintr_excep_req_in  <= excep_req_sig;
            iuintr_rett_req_in   <= rett_req_sig;
            iuintr_rett_we_in    <= rett_we_sig;
            iuintr_rett_addr_in  <= rett_addr_sig;
            iuintr_intr_in       <= intr_sig;
            iuintr_irl_in        <= irl_sig;
            iuintr_pil_in        <= pil_sig;

            wait for 10 ns;

            no_sig := no_sig + 1;
            write (lo, str_no);
            write (lo, no_sig);

            write (lo, str_separate);

            if ((iuintr_vec_we_out    /=  vec_we_sig   )
            and (iuintr_vec_addr_out  /=  vec_addr_sig )
            and (iuintr_intr_req_out  /=  intr_req_sig )
            and (iuintr_intr_inst_out /=  intr_inst_sig)
            and (iuintr_intr_ack_out  /=  intr_ack_sig )) then
                write (lo, str_failure);
                write (lo, str_separate);
                write (lo, iuintr_vec_we_out   );
                write (lo, str_separate);
                write (lo, iuintr_vec_addr_out );
                write (lo, str_separate);
                write (lo, iuintr_intr_req_out );
                write (lo, str_separate);
                write (lo, iuintr_intr_inst_out);
                write (lo, str_separate);
                write (lo, iuintr_intr_ack_out );
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
