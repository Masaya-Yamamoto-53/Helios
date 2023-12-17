--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Shift Unit
-- Description:
-- * Processing is determined by the value of `iusft_op_in`:
--   * op_in = "000"`: unimplemented
--   * op_in = "001"`: Shift Left Logical
--   * op_in = "010"`: Shift Right Logical
--   * op_in = "011"`: Shift Right Arithmetic
--   * op_in = "100"`: Sign-EXtend Byte
--   * op_in = "101"`: Sign-Extend Halfword
--   * op_in = "110"`: unimplemented
--   * op_in = "111"`: unimplemented
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iusft_pac.all;

entity iusft is
    port (
        iusft_cs_in    : in    std_logic;
        iusft_op_in    : in    std_logic_vector( 2 downto 0);
        iusft_di_in    : in    std_logic_vector(31 downto 0);
        iusft_shcnt_in : in    std_logic_vector( 4 downto 0);
        iusft_do_out   :   out std_logic_vector(31 downto 0)
    );
end iusft;

architecture rtl of iusft is
    type sft_t is array (0 to 31) of std_logic_vector(31 downto 0);
    signal sl_sig : sft_t;

    signal op_sig        : std_logic_vector( 2 downto 0);
    signal shcnt_sig     : integer := 31;
    signal shcnt_ext_sig : integer := 31;
    signal revers_sig    : std_logic;

    signal di_sig        : std_logic_vector(31 downto 0);
    signal di_sft_sig    : std_logic_vector(31 downto 0);

    signal sign_sig      : std_logic_vector(30 downto 0);
    signal result_sig    : std_logic_vector(31 downto 0);

begin

    -- When the chip is selected, enable the input signal.
    -- If not, set all input signals to zero.
    op_sig    <= iusft_op_in and ( 2 downto 0 => iusft_cs_in);
    di_sig    <= iusft_di_in and (31 downto 0 => iusft_cs_in);
    shcnt_sig <= to_integer(unsigned(iusft_shcnt_in and ( 4 downto 0 => iusft_cs_in)));

    -- Determine the data to input into the right shift operator.
    -- * SLL: To achieve a left shif using a right shift operator, reverse the data.
    -- * SEXTB: To perform sign extension with a right arithmetic shift,
    --          first shift the 8 bits towards the leftmost end.
    -- * SEXTH: To perform sign extension with a right arithmetic shift,
    --          first shift the 16 bits towards the leftmost end.
    with op_sig select
    di_sft_sig <= iusft_revers_signals(di_sig)     when IUSFT_OP_SLL,
                  di_sig (15 downto 0) & X"0000"   when IUSFT_OP_SEXTH,
                  di_sig ( 7 downto 0) & X"000000" when IUSFT_OP_SEXTB,
                  di_sig                           when IUSFT_OP_SRL,
                  di_sig                           when IUSFT_OP_SRA,
                  (others => '0')                  when others;

    -- Instructions SLL reverse the bits to enable shared usage of the shift operator.
    -- This bit is used to revert the inverted data.
    with op_sig select
    revers_sig <= '1' when IUSFT_OP_SLL,
                  '0' when others;

    -- Determine the amount of shift.
    with op_sig select
    shcnt_ext_sig <= 24        when IUSFT_OP_SEXTB,
                     16        when IUSFT_OP_SEXTH,
                     shcnt_sig when others;

    -- Choose the position of the sign bit for each instruction.
    -- * SRA: Position of the sign bit in a 32-bit data.
    -- * SEXTH: Position of the sign bit in a 16-bit data.
    -- * SEXTB: position of the sign bit in an 8-bit data.
    with op_sig select
    sign_sig <= (others => di_sig(31)) when IUSFT_OP_SRA,  
                (others => di_sig(15)) when IUSFT_OP_SEXTH,
                (others => di_sig( 7)) when IUSFT_OP_SEXTB,
                (others => '0')        when others;

    -- Right arithmetic shift circuit
    --   It is prepared for each shift amount,
    --   and the selection is determined by the specified shift amount.
    result_sig   <= sl_sig(shcnt_ext_sig);

    sl_sig( 0) <=                         di_sft_sig(31 downto  0);
    sl_sig( 1) <= sign_sig( 0 downto 0) & di_sft_sig(31 downto  1);
    sl_sig( 2) <= sign_sig( 1 downto 0) & di_sft_sig(31 downto  2);
    sl_sig( 3) <= sign_sig( 2 downto 0) & di_sft_sig(31 downto  3);
    sl_sig( 4) <= sign_sig( 3 downto 0) & di_sft_sig(31 downto  4);
    sl_sig( 5) <= sign_sig( 4 downto 0) & di_sft_sig(31 downto  5);
    sl_sig( 6) <= sign_sig( 5 downto 0) & di_sft_sig(31 downto  6);
    sl_sig( 7) <= sign_sig( 6 downto 0) & di_sft_sig(31 downto  7);
    sl_sig( 8) <= sign_sig( 7 downto 0) & di_sft_sig(31 downto  8);
    sl_sig( 9) <= sign_sig( 8 downto 0) & di_sft_sig(31 downto  9);
    sl_sig(10) <= sign_sig( 9 downto 0) & di_sft_sig(31 downto 10);
    sl_sig(11) <= sign_sig(10 downto 0) & di_sft_sig(31 downto 11);
    sl_sig(12) <= sign_sig(11 downto 0) & di_sft_sig(31 downto 12);
    sl_sig(13) <= sign_sig(12 downto 0) & di_sft_sig(31 downto 13);
    sl_sig(14) <= sign_sig(13 downto 0) & di_sft_sig(31 downto 14);
    sl_sig(15) <= sign_sig(14 downto 0) & di_sft_sig(31 downto 15);
    sl_sig(16) <= sign_sig(15 downto 0) & di_sft_sig(31 downto 16);
    sl_sig(17) <= sign_sig(16 downto 0) & di_sft_sig(31 downto 17);
    sl_sig(18) <= sign_sig(17 downto 0) & di_sft_sig(31 downto 18);
    sl_sig(19) <= sign_sig(18 downto 0) & di_sft_sig(31 downto 19);
    sl_sig(20) <= sign_sig(19 downto 0) & di_sft_sig(31 downto 20);
    sl_sig(21) <= sign_sig(20 downto 0) & di_sft_sig(31 downto 21);
    sl_sig(22) <= sign_sig(21 downto 0) & di_sft_sig(31 downto 22);
    sl_sig(23) <= sign_sig(22 downto 0) & di_sft_sig(31 downto 23);
    sl_sig(24) <= sign_sig(23 downto 0) & di_sft_sig(31 downto 24);
    sl_sig(25) <= sign_sig(24 downto 0) & di_sft_sig(31 downto 25);
    sl_sig(26) <= sign_sig(25 downto 0) & di_sft_sig(31 downto 26);
    sl_sig(27) <= sign_sig(26 downto 0) & di_sft_sig(31 downto 27);
    sl_sig(28) <= sign_sig(27 downto 0) & di_sft_sig(31 downto 28);
    sl_sig(29) <= sign_sig(28 downto 0) & di_sft_sig(31 downto 29);
    sl_sig(30) <= sign_sig(29 downto 0) & di_sft_sig(31 downto 30);
    sl_sig(31) <= sign_sig(30 downto 0) & di_sft_sig(31 downto 31);

    -- Restore the data to its original state by reversing the inverted data.
    iusft_do_out <= iusft_revers_signals(result_sig) when revers_sig = '1' else
                                         result_sig;

end rtl;
