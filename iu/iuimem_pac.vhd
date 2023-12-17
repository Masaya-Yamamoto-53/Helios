--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Instruction Memory
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package iuimem_pac is

    component iuimem
        port (
            iuimem_addr_in : in    std_logic_vector ( 8 downto 0);
            iuimem_do_out  :   out std_logic_vector (31 downto 0)
        );
    end component;


    subtype dword_t is std_logic_vector (31 downto 0);
    type rom_t is array (natural range <>) of dword_t;
    
    signal inst_rom : rom_t := (
    );

end iuimem_pac;

-- package body iuimem_pac is
-- end iuimem_pac;
