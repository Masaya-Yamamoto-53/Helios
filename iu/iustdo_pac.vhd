--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Store Data Output
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package iustdo_pac is

    component iustdo
        port (
            iustdo_write_in : in    std_logic;
            iustdo_type_in  : in    std_logic_vector( 1 downto 0);
            iustdo_addr_in  : in    std_logic_vector( 1 downto 0);
            iustdo_di_in    : in    std_logic_vector(31 downto 0);
            iustdo_do_out   :   out std_logic_vector(31 downto 0)
        );
    end component;

end iustdo_pac;

-- package body iustdo_pac is
-- end iustdo_pac;
