library ieee;
use ieee.std_logic_1164.all;

package iumastg_pac is

    component iumastg
        port (
            iumastg_read_in         : in    std_logic;
            iumastg_write_in        : in    std_logic;
            iumastg_a_in            : in    std_logic;
            iumastg_sign_in         : in    std_logic;
            iumastg_type_in         : in    std_logic_vector( 1 downto 0);
            iumastg_addr_in         : in    std_logic_vector(31 downto 0);
            iumastg_di_in           : in    std_logic_vector(31 downto 0);

            iumastg_mem_re_out      :   out std_logic;
            iumastg_mem_we_out      :   out std_logic;
            iumastg_mem_dqm_out     :   out std_logic_vector( 3 downto 0);
            iumastg_mem_addr_out    :   out std_logic_vector(31 downto 0);
            iumastg_mem_a_out       :   out std_logic;
            iumastg_mem_di_out      :   out std_logic_vector(31 downto 0);
            iumastg_mem_do_in       : in    std_logic_vector(31 downto 0);

            iumastg_mem_algnchk_out :   out std_logic;
            iumastg_do_out          :   out std_logic_vector(31 downto 0)
        );
    end component;

end iumastg_pac;

-- package body iumastg_pac is
-- end iumastg_pac;
