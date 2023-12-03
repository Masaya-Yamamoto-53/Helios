--------------------------------------------------------------------------------
-- Design Name: IU ALU(Arithmetic and Logic Unit)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package iualu_pac is

    constant IUALU_OP_ADD  : std_logic_vector(2 downto 0) := "000";
    constant IUALU_OP_AND  : std_logic_vector(2 downto 0) := "001";
    constant IUALU_OP_OR   : std_logic_vector(2 downto 0) := "010";
    constant IUALU_OP_XOR  : std_logic_vector(2 downto 0) := "011";
    constant IUALU_OP_SUB  : std_logic_vector(2 downto 0) := "100";
    constant IUALU_OP_ANDN : std_logic_vector(2 downto 0) := "101";
    constant IUALU_OP_ORN  : std_logic_vector(2 downto 0) := "110";
    constant IUALU_OP_XNOR : std_logic_vector(2 downto 0) := "111";

    component iualu
        port (
            iualu_cs_in  : in    std_logic;
            iualu_op_in  : in    std_logic_vector( 2 downto 0);
            iualu_di1_in : in    std_logic_vector(31 downto 0);
            iualu_di2_in : in    std_logic_vector(31 downto 0);
            iualu_do_out :   out std_logic_vector(31 downto 0)
        );
    end component;

end iualu_pac;

-- package body iualu_pac is
-- end iualu_pac;
