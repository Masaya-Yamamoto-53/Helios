--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Format 1 Decoder
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.iuctrl_pac.all;

package iufmt1dec_pac is

    component iufmt1dec
        port (
            iufmt1dec_cs_in  : in    std_logic;
            iufmt1dec_do_out :   out st_iuctrl_if
        );
    end component;

end iufmt1dec_pac;

-- package body iufmt1dec_pac is
-- end iufmt1dec_pac;
