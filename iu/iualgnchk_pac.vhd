--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Alignment Check
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package iualgnchk_pac is

    component iualgnchk
        port (
            iualgnchk_cs_in   : in    std_logic;
            iualgnchk_type_in : in    std_logic_vector(1 downto 0);
            iualgnchk_addr_in : in    std_logic_vector(1 downto 0);
            iualgnchk_do_out  :   out std_logic
        );
    end component;

end iualgnchk_pac;

-- package body iualgnchk_pac is
-- end iualgnchk_pac;
