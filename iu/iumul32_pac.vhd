--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU 32-bit Multiply Unit
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package iumul32_pac is

    type st_iumul32_if is
    record
        hi        : std_logic;
        mul1_data : std_logic_vector(31 downto 0);
        mul2_data : std_logic_vector(31 downto 0);
        mul3_data : std_logic_vector(31 downto 0);
        mul4_data : std_logic_vector(31 downto 0);
    end record;
    constant st_iumul32_if_INIT : st_iumul32_if := (
        '0',             -- hi
        (others => '0'), -- mul1_data
        (others => '0'), -- mul2_data
        (others => '0'), -- mul3_data
        (others => '0')  -- mul4_data
    );

    component iumul32pre
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
    end component;

    component iumul32post
        port (
            iumul32post_hi_in   : in    std_logic;
            iumul32post_mul1_in : in    std_logic_vector(31 downto 0);
            iumul32post_mul2_in : in    std_logic_vector(31 downto 0);
            iumul32post_mul3_in : in    std_logic_vector(31 downto 0);
            iumul32post_mul4_in : in    std_logic_vector(31 downto 0);
            iumul32post_do_out  :   out std_logic_vector(31 downto 0)
        );
    end component;

    component iumul32reg
        port (
            iumul32reg_clk_in : in    std_logic;
            iumul32reg_wen_in : in    std_logic;
            iumul32reg_di_in  : in    st_iumul32_if;
            iumul32reg_do_out :   out st_iumul32_if
        );
    end component;

end iumul32_pac;

-- package body iumul32_pac is
-- end iumul32_pac;
