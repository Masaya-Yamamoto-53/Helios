library ieee;
use ieee.std_logic_1164.all;

package iucmp_pac is

    constant IUCMP_OP_CMPEQ  : std_logic_vector(2 downto 0) := "000";
    constant IUCMP_OP_UNIMP1 : std_logic_vector(2 downto 0) := "001";
    constant IUCMP_OP_CMPLT  : std_logic_vector(2 downto 0) := "010";
    constant IUCMP_OP_CMPLE  : std_logic_vector(2 downto 0) := "011";
    constant IUCMP_OP_CMPNEQ : std_logic_vector(2 downto 0) := "100";
    constant IUCMP_OP_UNIMP2 : std_logic_vector(2 downto 0) := "101";
    constant IUCMP_OP_CMPLTU : std_logic_vector(2 downto 0) := "110";
    constant IUCMP_OP_CMPLEU : std_logic_vector(2 downto 0) := "111";

    component iucmp
        port (
            iucmp_cs_in  : in    std_logic;
            iucmp_op_in  : in    std_logic_vector( 2 downto 0);
            iucmp_di1_in : in    std_logic_vector(31 downto 0);
            iucmp_di2_in : in    std_logic_vector(31 downto 0);
            iucmp_do_out :   out std_logic
        );
    end component;

end iucmp_pac;

-- package body iucmp_pac is
-- end iucmp_pac;
