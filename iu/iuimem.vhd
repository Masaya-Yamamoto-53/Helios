--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Instruction Memory
-- Description:
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iuimem_pac.all;

entity iuimem is
    port (
        iuimem_addr_in  : in    std_logic_vector( 8 downto 0);
        iuimem_do_out   :   out std_logic_vector(31 downto 0)
    );
end iuimem;

architecture rtl of iuimem is

begin

    iuimem_do_out <= inst_rom(to_integer(unsigned(iuimem_addr_in)));

end rtl;
