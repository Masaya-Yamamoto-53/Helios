--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Program Counter
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package iupc_pac is

    component iupc
        port (
            iupc_clk_in  : in    std_logic;
            iupc_rst_in  : in    std_logic;
            iupc_wen_in  : in    std_logic;
            iupc_di_in   : in    std_logic_vector(29 downto 0);
            iupc_do_out  :   out std_logic_vector(29 downto 0)
        );
    end component;

end iupc_pac;

-- package body iupc_pac is
-- end iupc_pac;
