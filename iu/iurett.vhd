--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Retern from Trap Detection Unit
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iuctrl_pac.all;

entity iurett is
    port (
        iurett_op_in  : in    std_logic_vector(1 downto 0);
        iurett_op3_in : in    std_logic_vector(5 downto 0);
        iurett_en_out :   out std_logic
    );
end iurett;

architecture rtl of iurett is

begin

    iurett_en_out <= '1' when ((iurett_op_in  = IUCTRL_OP_LDST  )
                           and (iurett_op3_in = IUCTRL_INST_RETT)) else
                     '0';

end rtl;
