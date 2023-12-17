--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU ALU(Arithmetic and Logic Unit)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package iualu_pac is

    constant OP_ADDSUB : std_logic_vector(1 downto 0) := "00";
    constant OP_AND    : std_logic_vector(1 downto 0) := "01";
    constant OP_OR     : std_logic_vector(1 downto 0) := "10";
    constant OP_XOR    : std_logic_vector(1 downto 0) := "11";

    constant IUALU_OP_ADD  : std_logic_vector(2 downto 0) := "0" & OP_ADDSUB;
    constant IUALU_OP_AND  : std_logic_vector(2 downto 0) := "0" & OP_AND;
    constant IUALU_OP_OR   : std_logic_vector(2 downto 0) := "0" & OP_OR;
    constant IUALU_OP_XOR  : std_logic_vector(2 downto 0) := "0" & OP_XOR;
    constant IUALU_OP_SUB  : std_logic_vector(2 downto 0) := "1" & OP_ADDSUB;
    constant IUALU_OP_ANDN : std_logic_vector(2 downto 0) := "1" & OP_AND;
    constant IUALU_OP_ORN  : std_logic_vector(2 downto 0) := "1" & OP_OR;
    constant IUALU_OP_XNOR : std_logic_vector(2 downto 0) := "1" & OP_XOR;

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
