--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Supervisor Register
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package ius_pac is

    -- Supervisor Register Initial Value
    -- 0: Not Supervisor
    -- 1:     Supervisor
    constant IUS_S_INIT : std_logic := '1';

    component ius
        port (
            ius_clk_in : in    std_logic;
            ius_rst_in : in    std_logic;
            ius_we_in  : in    std_logic;
            ius_di_in  : in    std_logic;
            ius_do_out :   out std_logic
        );
    end component;

end ius_pac;

-- package body ius_pac is
-- end ius_pac;
