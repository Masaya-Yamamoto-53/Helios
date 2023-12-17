--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU ALU(Arithmetic and Logic Unit)
-- Description:
--   Processing is determined by the value of `iualu_op_in`:
--     * op_in = "000"`: Addition operation
--     * op_in = "001"`: AND operation
--     * op_in = "010"`: Inclusive OR operation
--     * op_in = "011"`: Exclusive OR operation
--     * op_in = "100"`: Subtract operation
--     * op_in = "101"`: AND Not operation
--     * op_in = "110"`: Inclusive OR Not operation
--     * op_in = "111"`: Exclusive OR Not operation
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iualu_pac.all;

entity iualu is
    port (
        iualu_cs_in  : in    std_logic;
        iualu_op_in  : in    std_logic_vector( 2 downto 0);
        iualu_di1_in : in    std_logic_vector(31 downto 0);
        iualu_di2_in : in    std_logic_vector(31 downto 0);
        iualu_do_out :   out std_logic_vector(31 downto 0)
    );
end iualu;

architecture rtl of iualu is

    signal op_sig    : std_logic_vector(2 downto 0);
    signal di1_sig   : unsigned(31 downto 0);
    signal di2_sig   : unsigned(31 downto 0);
    signal di2_n_sig : unsigned(31 downto 0);
    signal add_sig   : unsigned(31 downto 0);

begin

    -- When the chip is selected, enable the input signal.
    -- If not, set all input signals to zero.
    op_sig  <= iualu_op_in            and ( 2 downto 0 => iualu_cs_in);
    di1_sig <= unsigned(iualu_di1_in) and (31 downto 0 => iualu_cs_in);
    di2_sig <= unsigned(iualu_di2_in) and (31 downto 0 => iualu_cs_in);

    di2_n_sig <=     di2_sig       when op_sig(2) = '0' else
                 not di2_sig;

    add_sig   <= di1_sig + di2_sig when op_sig(2) = '0' else
                 di1_sig - di2_sig;

    with op_sig(1 downto 0) select
    iualu_do_out <= std_logic_vector(add_sig)               when OP_ADDSUB,
                    std_logic_vector(di1_sig and di2_n_sig) when OP_AND,
                    std_logic_vector(di1_sig or  di2_n_sig) when OP_OR,
                    std_logic_vector(di1_sig xor di2_n_sig) when others;

end rtl;
