library ieee;
use ieee.std_logic_1164.all;

package iuldst_pac is

    constant IULDST_MEM_TYPE_BYTE  : std_logic_vector(1 downto 0) := "00";
    constant IULDST_MEM_TYPE_HALF  : std_logic_vector(1 downto 0) := "01";
    constant IULDST_MEM_TYPE_WORD  : std_logic_vector(1 downto 0) := "10";
    constant IULDST_MEM_TYPE_DWORD : std_logic_vector(1 downto 0) := "11";

    component iuld
        port (
            iuld_read_in : in    std_logic;
            iuld_sign_in : in    std_logic;
            iuld_type_in : in    std_logic_vector( 1 downto 0);
            iuld_addr_in : in    std_logic_vector( 1 downto 0);
            iuld_di_in   : in    std_logic_vector(31 downto 0);
            iuld_do_out  :   out std_logic_vector(31 downto 0)
        );
    end component;

    component iust
        port (
            iust_write_in : in    std_logic;
            iust_addr_in  : in    std_logic_vector( 1 downto 0);
            iust_di_in    : in    std_logic_vector(31 downto 0);
            iust_type_in  : in    std_logic_vector( 1 downto 0);
            iust_dqm_out  :   out std_logic_vector( 3 downto 0);
            iust_do_out   :   out std_logic_vector(31 downto 0)
        );
    end component;

    -- Sign extension for byte
    function iuldst_sign_extend_byte (
        signal sign  : std_logic;
        signal data : std_logic_vector( 7 downto 0)
    ) return std_logic_vector;

    -- Sign extension for half word
    function iuldst_sign_extend_half (
        signal sign  : std_logic;
        signal data : std_logic_vector(15 downto 0)
    ) return std_logic_vector;

end iuldst_pac;

package body iuldst_pac is

    function iuldst_sign_extend_byte (
        signal sign  : std_logic;
        signal data : std_logic_vector( 7 downto 0)
    ) return std_logic_vector is
    begin
        return sign & sign & sign & sign &
               sign & sign & sign & sign &
               sign & sign & sign & sign &
               sign & sign & sign & sign &
               sign & sign & sign & sign &
               sign & sign & sign & sign & data;
    end iuldst_sign_extend_byte;

    function iuldst_sign_extend_half (
        signal sign  : std_logic;
        signal data : std_logic_vector(15 downto 0)
    ) return std_logic_vector is
    begin
        return sign & sign & sign & sign &
               sign & sign & sign & sign &
               sign & sign & sign & sign &
               sign & sign & sign & sign & data;
    end iuldst_sign_extend_half;

end iuldst_pac;
