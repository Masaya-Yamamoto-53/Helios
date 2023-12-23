library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use std.textio.all;
use ieee.std_logic_textio.all;

entity iu_test is
end iu_test;

architecture behavior of iu_test is 

    -- component declaration for the unit under test (uut)
    component iu
    port(
         iu_sys_clk_in        : in    std_logic;
         iu_sys_rstn_in       : in    std_logic;

         iu_inst_addr_out :   out std_logic_vector(29 downto 0);
         iu_inst_data_in  : in    std_logic_vector(31 downto 0);

         iu_data_re_out   :   out std_logic;
         iu_data_we_out   :   out std_logic;
         iu_data_dqm_out  :   out std_logic_vector( 3 downto 0);
         iu_data_addr_out :   out std_logic_vector(31 downto 0);
         iu_data_di_out   :   out std_logic_vector(31 downto 0);
         iu_data_do_in    : in    std_logic_vector(31 downto 0);

         iu_intr_int_in   : in    std_logic;
         iu_intr_irl_in   : in    std_logic_vector ( 3 downto 0);
         iu_intr_ack_out  :   out std_logic
        );
    end component;

    --inputs
    signal iu_sys_clk_in    : std_logic := '0';
    signal iu_sys_rstn_in   : std_logic := '0';
    signal iu_inst_data_in  : std_logic_vector (31 downto 0) := (others => '0');
    signal iu_data_do_in    : std_logic_vector (31 downto 0) := (others => '0');
    signal iu_intr_int_in   : std_logic := '0';
    signal iu_intr_irl_in   : std_logic_vector ( 3 downto 0) := (others => '0');

    --outputs
    signal iu_inst_addr_out : std_logic_vector (29 downto 0);
    signal iu_data_re_out   : std_logic;
    signal iu_data_we_out   : std_logic;
    signal iu_data_dqm_out  : std_logic_vector ( 3 downto 0);
    signal iu_data_addr_out : std_logic_vector (31 downto 0);
    signal iu_data_di_out   : std_logic_vector (31 downto 0);
    signal iu_intr_ack_out  : std_logic;

    subtype byte_t  is std_logic_vector ( 7 downto 0);
    subtype dword_t is std_logic_vector (31 downto 0);
    type inst_t is array (0 to 1023) of dword_t;
    type ram_t  is array (0 to 1023) of byte_t;

    signal inst_reg   : inst_t;
    signal result_reg : inst_t;
    signal ram0_reg   : ram_t;
    signal ram1_reg   : ram_t;
    signal ram2_reg   : ram_t;
    signal ram3_reg   : ram_t;
    signal cnt_reg    : integer := 0;
    signal dly_reg    : integer := 0;
    signal clk_reg    : std_logic_vector (31 downto 0) := (others => '0');

begin

    -- instantiate the unit under test (uut)
   uut: iu port map (
           iu_sys_clk_in        => iu_sys_clk_in,
           iu_sys_rstn_in       => iu_sys_rstn_in,
           iu_inst_addr_out => iu_inst_addr_out,
           iu_inst_data_in  => iu_inst_data_in,
           iu_data_re_out   => iu_data_re_out,
           iu_data_we_out   => iu_data_we_out,
           iu_data_dqm_out  => iu_data_dqm_out,
           iu_data_addr_out => iu_data_addr_out,
           iu_data_di_out   => iu_data_di_out,
           iu_data_do_in    => iu_data_do_in,
           iu_intr_int_in   => iu_intr_int_in,
           iu_intr_irl_in   => iu_intr_irl_in,
           iu_intr_ack_out  => iu_intr_ack_out
           );

   -- stimulus process
   stim_proc: process
        file fin  : text open read_mode is "./test/dat/iu_test.dat";
        file fout : text open write_mode is "./test/log/iu_test.log";
        variable str_separate : string (1 to 1):= ",";
        variable str_failure  : string (1 to 7):= "failure";
        variable str_pass     : string (1 to 4):= "pass";
        variable li : line;
        variable lo : line;
        variable no_sig : integer := 0;

        -- input signal
        variable inst_sig   : std_logic_vector (31 downto 0);
        variable result_sig : std_logic_vector (31 downto 0);
 
        -- output signal
        variable inst_addr_sig : std_logic_vector (29 downto 0);
        variable we_sig        : std_logic;
        variable dqm_sig       : std_logic_vector ( 3 downto 0);
        variable addr_sig      : std_logic_vector (31 downto 0);
        variable di_sig        : std_logic_vector (31 downto 0);
        variable inta_sig      : std_logic;
        variable eoi_sig       : std_logic;
   begin

        while (not endfile (fin)) loop
            -- input data
            readline (fin, li);
            read (li, inst_sig );

            -- result
            read (li, result_sig);

            inst_reg   (conv_integer (cnt_reg)) <= inst_sig;
            result_reg (conv_integer (cnt_reg)) <= result_sig;

            cnt_reg <= cnt_reg + 1;
            wait for 5ns;
        end loop;

        iu_data_do_in   <= transport (others => '0');
        iu_intr_ack_out <= transport '0';

        iu_sys_rstn_in <= transport '0';
        iu_sys_clk_in  <= transport '0';
        wait for 5ns;
        iu_sys_rstn_in <= transport '0';
        iu_sys_clk_in  <= transport '1';
        wait for 5ns;

        while (iu_inst_data_in /= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU" or dly_reg <= 4) loop
            if (iu_inst_data_in = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") then
                dly_reg <= dly_reg + 1;
            end if;

            iu_inst_data_in <=
            inst_reg (conv_integer (iu_inst_addr_out (9 downto 0)));

            if (iu_data_we_out = '1') then
                if (iu_data_dqm_out (0) = '1') then
                    ram3_reg (conv_integer (iu_data_addr_out (11 downto 2))) <= iu_data_di_out ( 7 downto  0);
                end if;
                if (iu_data_dqm_out (1) = '1') then
                    ram2_reg (conv_integer (iu_data_addr_out (11 downto 2))) <= iu_data_di_out (15 downto  8);
                end if;
                if (iu_data_dqm_out (2) = '1') then
                    ram1_reg (conv_integer (iu_data_addr_out (11 downto 2))) <= iu_data_di_out (23 downto 16);
                end if;
                if (iu_data_dqm_out (3) = '1') then
                    ram0_reg (conv_integer (iu_data_addr_out (11 downto 2))) <= iu_data_di_out (31 downto 24);
                end if;

                no_sig := no_sig + 1;
                write (lo, "No.");
                write (lo, no_sig);
                write (lo, str_separate);
                if ((result_reg (conv_integer (iu_inst_addr_out (9 downto 0))-3)) /= iu_data_di_out) then
                    write (lo, str_failure);
                    write (lo, str_separate);
                    write (lo, result_reg (conv_integer (iu_inst_addr_out (9 downto 0))-3));
                    write (lo, str_separate);
                    write (lo, iu_data_di_out);
                else
                    write (lo, str_pass);
                end if;
                writeline (fout, lo);
            end if;

            iu_data_do_in ( 7 downto  0) <= ram3_reg (conv_integer (iu_data_addr_out (11 downto 2)));
            iu_data_do_in (15 downto  8) <= ram2_reg (conv_integer (iu_data_addr_out (11 downto 2)));
            iu_data_do_in (23 downto 16) <= ram1_reg (conv_integer (iu_data_addr_out (11 downto 2)));
            iu_data_do_in (31 downto 24) <= ram0_reg (conv_integer (iu_data_addr_out (11 downto 2)));

            iu_sys_clk_in  <= transport '0';
            iu_sys_rstn_in <= transport '1';
            wait for 5ns;

            iu_sys_clk_in  <= transport '1';
            iu_sys_rstn_in <= transport '1';
            wait for 5ns;

            clk_reg <= clk_reg + 1;
        end loop;

        file_close (fin);
        file_close (fout);
        wait;
   end process;

end;
