--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU MA/WB Pipeline Register
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;


package iumawb_pac is

    type st_iumawb_if is
    record
        rd_we    : std_logic;
        rd_sel   : std_logic_vector ( 4 downto 0);
        rd_data  : std_logic_vector (31 downto 0);
    end record;
    constant st_iumawb_if_INIT : st_iumawb_if := (
        '0',             -- rd_we
        (others => '0'), -- rd_sel
        (others => '0')  -- rd_data
    );

    component iumawb
        port (
            iumawb_clk_in   : in    std_logic;
            iumawb_rst_in   : in    std_logic;
            iumawb_wen_in   : in    std_logic;
            iumawb_flash_in : in    std_Logic;
            iumawb_di_in    : in    st_iumawb_if;
            iumawb_do_out   :   out st_iumawb_if
        );
    end component;

end iumawb_pac;

-- package body iumawb_pac is
-- end iumawb_pac;
