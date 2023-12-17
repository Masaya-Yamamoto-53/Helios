--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU 32-bit Multiply Pre Unit
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iumul32pre is
    port (
        iumul32pre_cs_in    : in    std_logic;
        iumul32pre_hi_in    : in    std_logic;
        iumul32pre_di1_in   : in    std_logic_vector(31 downto 0);
        iumul32pre_di2_in   : in    std_logic_vector(31 downto 0);
        iumul32pre_hi_out   :   out std_logic;
        iumul32pre_mul1_out :   out std_logic_vector(31 downto 0);
        iumul32pre_mul2_out :   out std_logic_vector(31 downto 0);
        iumul32pre_mul3_out :   out std_logic_vector(31 downto 0);
        iumul32pre_mul4_out :   out std_logic_vector(31 downto 0)
    );
end iumul32pre;

architecture rtl of iumul32pre is

    signal di1_sig : unsigned(31 downto 0);
    signal di2_sig : unsigned(31 downto 0);

begin

    di1_sig <= unsigned (iumul32pre_di1_in) and (31 downto 0 => iumul32pre_cs_in);
    di2_sig <= unsigned (iumul32pre_di2_in) and (31 downto 0 => iumul32pre_cs_in);

    iumul32pre_hi_out <= iumul32pre_hi_in and iumul32pre_cs_in;

    iumul32pre_mul1_out <= std_logic_vector(di1_sig(15 downto  0) * di2_sig(15 downto  0));
    iumul32pre_mul2_out <= std_logic_vector(di1_sig(31 downto 16) * di2_sig(15 downto  0));
    iumul32pre_mul3_out <= std_logic_vector(di1_sig(15 downto  0) * di2_sig(31 downto 16));
    iumul32pre_mul4_out <= std_logic_vector(di1_sig(31 downto 16) * di2_sig(31 downto 16));

end rtl;
