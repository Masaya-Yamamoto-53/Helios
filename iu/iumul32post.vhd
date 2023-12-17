--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU 32-bit Multiply Post Unit
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iumul32post is
    port (
        iumul32post_hi_in   : in    std_logic;
        iumul32post_mul1_in : in    std_logic_vector(31 downto 0);
        iumul32post_mul2_in : in    std_logic_vector(31 downto 0);
        iumul32post_mul3_in : in    std_logic_vector(31 downto 0);
        iumul32post_mul4_in : in    std_logic_vector(31 downto 0);
        iumul32post_do_out  :   out std_logic_vector(31 downto 0)
    );
end iumul32post;

architecture rtl of iumul32post is

    signal mul1_sig : unsigned(31 downto 0);
    signal mul2_sig : unsigned(31 downto 0);
    signal mul3_sig : unsigned(31 downto 0);
    signal mul4_sig : unsigned(31 downto 0);

    signal add1_sig : unsigned(47 downto 0);
    signal add2_sig : unsigned(47 downto 0);

    signal mul_lo   : std_logic_vector(31 downto 0);
    signal mul_hi   : std_logic_vector(31 downto 0);

    signal result_sig : unsigned (63 downto 0);

begin

    mul1_sig <= unsigned(iumul32post_mul1_in);
    mul2_sig <= unsigned(iumul32post_mul2_in);
    mul3_sig <= unsigned(iumul32post_mul3_in);
    mul4_sig <= unsigned(iumul32post_mul4_in);

    add1_sig   <= (mul2_sig + mul1_sig(31 downto 16)) & mul1_sig(15 downto 0);
    add2_sig   <= (mul4_sig + mul3_sig(31 downto 16)) & mul3_sig(15 downto 0);
    result_sig <= (add2_sig + add1_sig(47 downto 16)) & add1_sig(15 downto 0);

    mul_lo <= std_logic_vector(result_sig(31 downto  0));
    mul_hi <= std_logic_vector(result_sig(63 downto 32));

    iumul32post_do_out <= mul_lo when iumul32post_hi_in = '0' else
                          mul_hi;

end rtl;

