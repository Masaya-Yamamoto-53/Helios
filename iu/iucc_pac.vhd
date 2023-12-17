--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Condition Code
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package iucc_pac is

    component iucc
        port (
            iucc_di1_msb_in : in    std_logic;
            iucc_di2_msb_in : in    std_logic;
            iucc_rlt_in     : in    std_logic_vector(31 downto 0);
            iucc_n_out      :   out std_logic;
            iucc_z_out      :   out std_logic;
            iucc_v_out      :   out std_logic;
            iucc_c_out      :   out std_logic
        );
    end component;

end iucc_pac;

-- package body iucc_pac is
-- end iucc_pac;
