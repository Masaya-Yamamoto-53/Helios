library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

use work.iuldst_pac.all;

entity iuld is
    port (
        iuld_read_in : in    std_logic;
        iuld_sign_in : in    std_logic;
        iuld_type_in : in    std_logic_vector( 1 downto 0);
        iuld_addr_in : in    std_logic_vector( 1 downto 0);
        iuld_di_in   : in    std_logic_vector(31 downto 0);
        iuld_do_out  :   out std_logic_vector(31 downto 0)
    );
end iuld;

architecture rtl of iuld is

    signal addr_sig      : std_logic_vector( 1 downto 0);
    signal di_sig        : std_logic_vector(31 downto 0);
    signal type_sig      : std_logic_vector( 1 downto 0);
    signal sign_sig      : std_logic;

    signal byte_sign_sig : std_logic;
    signal half_sign_sig : std_logic;

    signal byte_di_sig   : std_logic_vector(31 downto 0);
    signal half_di_sig   : std_logic_vector(31 downto 0);
    signal word_di_sig   : std_logic_vector(31 downto 0);

    signal byte_0_di_sig : std_logic_vector( 7 downto 0);
    signal half_0_di_sig : std_logic_vector(15 downto 0);

    signal byte_do_sig   : std_logic_vector(31 downto 0);
    signal half_do_sig   : std_logic_vector(31 downto 0);
    signal word_do_sig   : std_logic_vector(31 downto 0);

begin

    addr_sig <= iuld_addr_in and ( 1 downto 0 => iuld_read_in);
    di_sig   <= iuld_di_in   and (31 downto 0 => iuld_read_in);
    type_sig <= iuld_type_in and ( 1 downto 0 => iuld_read_in);
    sign_sig <= iuld_sign_in and iuld_read_in;

    byte_di_sig <= di_sig when   type_sig = IULDST_MEM_TYPE_BYTE   else (others => '0');
    half_di_sig <= di_sig when   type_sig = IULDST_MEM_TYPE_HALF   else (others => '0');
    word_di_sig <= di_sig when ((type_sig = IULDST_MEM_TYPE_WORD)
                            and (sign_sig = '0'                 )
                            and (addr_sig = "00"                )) else (others => '0');

    with sign_sig & addr_sig select
    byte_sign_sig <= byte_di_sig(31) when '1' & "00",
                     byte_di_sig(23) when '1' & "01",
                     byte_di_sig(15) when '1' & "10",
                     byte_di_sig( 7) when '1' & "11",
                     '0'             when others;

    with sign_sig & addr_sig select
    half_sign_sig <= half_di_sig(31) when '1' & "00",
                     half_di_sig(15) when '1' & "10",
                     '0'             when others;

    with addr_sig select
    byte_0_di_sig <= byte_di_sig(31 downto 24) when "00",
                     byte_di_sig(23 downto 16) when "01",
                     byte_di_sig(15 downto  8) when "10",
                     byte_di_sig( 7 downto  0) when others;

    with addr_sig select
    half_0_di_sig <= half_di_sig(31 downto 16) when "00",
                     half_di_sig(15 downto  0) when "10",
                     (others => '0')           when others;

    byte_do_sig <= iuldst_sign_extend_byte(byte_sign_sig, byte_0_di_sig);
    half_do_sig <= iuldst_sign_extend_half(half_sign_sig, half_0_di_sig);
    word_do_sig <= word_di_sig;

    iuld_do_out <= byte_do_sig
                or half_do_sig
                or word_do_sig;

end rtl;
