--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Data Memory
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package iudmem_pac is

    component iudmem
        port (
            iudmem_cs_in   : in    std_logic;
            iudmem_clk_in  : in    std_logic;
            iudmem_we_in   : in    std_logic;
            iudmem_dqm_in  : in    std_logic_vector ( 3 downto 0);
            iudmem_addr_in : in    std_logic_vector ( 7 downto 0);
            iudmem_di_in   : in    std_logic_vector (31 downto 0);
            iudmem_do_out  :   out std_logic_vector (31 downto 0)
        );
    end component;

end iudmem_pac;

-- package body iudmem_pac is
-- end iudmem_pac;
