library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iualgnchk_pac.all;
use work.iuldst_pac.all;

use work.iumastg_pac.all;

entity iumastg is
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
end iumastg;

architecture rtl of iumastg is

    -- IU MA Stage Unit I/F
    signal read_sig         : std_logic;
    signal write_sig        : std_logic;
    signal addr_sig         : std_logic_vector(31 downto 0);

    -- IU Memory Address Not Aligned Check Unit I/F
    signal iualgnchk_cs_sig : std_logic;
    signal iualgnchk_do_sig : std_logic;

    -- IU Store Unit I/F
    signal iust_dqm_sig     : std_logic_vector( 3 downto 0);
    signal iust_do_sig      : std_logic_vector(31 downto 0);

    -- IU Load Unit I/F
    signal iuld_do_sig      : std_logic_vector(31 downto 0);

begin

    -----------------------------------------------------------
    -- IU Memory Address Not Aligned Check Unit              --
    -----------------------------------------------------------
    iualgnchk_cs_sig <= iumastg_read_in
                     or iumastg_write_in;

    IU_Memory_Address_Not_Aligned_Check_Unit : iualgnchk
    port map (
        iualgnchk_cs_in   => iualgnchk_cs_sig,
        iualgnchk_type_in => iumastg_type_in,
        iualgnchk_addr_in => iumastg_addr_in(1 downto 0),
        iualgnchk_do_out  => iualgnchk_do_sig
    );

    read_sig  <= iumastg_read_in  and (not iualgnchk_do_sig);
    write_sig <= iumastg_write_in and (not iualgnchk_do_sig);
    addr_sig  <= iumastg_addr_in  and (31 downto 0 => ((    iualgnchk_cs_sig)
                                                   and (not iualgnchk_do_sig)));

    -----------------------------------------------------------
    -- IU Store Unit                                         --
    -----------------------------------------------------------
    IU_Store_Unit : iust
    port map (
        iust_write_in => write_sig,
        iust_addr_in  => iumastg_addr_in(1 downto 0),
        iust_di_in    => iumastg_di_in,
        iust_type_in  => iumastg_type_in,
        iust_dqm_out  => iust_dqm_sig,
        iust_do_out   => iust_do_sig
    );

    -----------------------------------------------------------
    -- IU Load Unit                                          --
    -----------------------------------------------------------
    IU_Load_Unit : iuld
    port map (
        iuld_read_in => read_sig,
        iuld_sign_in => iumastg_sign_in,
        iuld_type_in => iumastg_type_in,
        iuld_addr_in => iumastg_addr_in(1 downto 0),
        iuld_di_in   => iumastg_mem_do_in,
        iuld_do_out  => iuld_do_sig
    );

    iumastg_mem_re_out      <= read_sig;
    iumastg_mem_we_out      <= write_sig;
    iumastg_mem_dqm_out     <= iust_dqm_sig;
    iumastg_mem_addr_out    <= addr_sig;
    iumastg_mem_a_out       <= iumastg_a_in and (read_sig or write_sig);
    iumastg_mem_di_out      <= iust_do_sig;
    iumastg_mem_algnchk_out <= iualgnchk_do_sig;
    iumastg_do_out          <= iuld_do_sig;

end rtl;
