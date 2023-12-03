library ieee;
use ieee.std_logic_1164.all;

package iusft_pac is

    constant IUSFT_OP_UNIMP1 : std_logic_vector(2 downto 0) := "000";
    constant IUSFT_OP_SLL    : std_logic_vector(2 downto 0) := "001";
    constant IUSFT_OP_SRL    : std_logic_vector(2 downto 0) := "010";
    constant IUSFT_OP_SRA    : std_logic_vector(2 downto 0) := "011";
    constant IUSFT_OP_SEXTB  : std_logic_vector(2 downto 0) := "100";
    constant IUSFT_OP_SEXTH  : std_logic_vector(2 downto 0) := "101";
    constant IUSFT_OP_UNIMP2 : std_logic_vector(2 downto 0) := "110";
    constant IUSFT_OP_UNIMP3 : std_logic_vector(2 downto 0) := "111";

    component iusft
        port (
            iusft_cs_in    : in    std_logic;
            iusft_op_in    : in    std_logic_vector( 2 downto 0);
            iusft_di_in    : in    std_logic_vector(31 downto 0);
            iusft_shcnt_in : in    std_logic_vector( 4 downto 0);
            iusft_do_out   :   out std_logic_vector(31 downto 0)
        );
    end component;

    function iusft_revers_signals (
        signal data : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

end iusft_pac;

package body iusft_pac is

    function iusft_revers_signals (
        signal data : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin
        return data( 0) & data( 1) & data( 2) & data( 3)
             & data( 4) & data( 5) & data( 6) & data( 7)
             & data( 8) & data( 9) & data(10) & data(11)
             & data(12) & data(13) & data(14) & data(15)
             & data(16) & data(17) & data(18) & data(19)
             & data(20) & data(21) & data(22) & data(23)
             & data(24) & data(25) & data(26) & data(27)
             & data(28) & data(29) & data(30) & data(31);
    end iusft_revers_signals;

end iusft_pac;
