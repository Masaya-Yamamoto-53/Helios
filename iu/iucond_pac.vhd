--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Condition
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package iucond_pac is

    constant IUCOND_BRLBC : std_logic_vector(2 downto 0) := "000";
    constant IUCOND_BRZ   : std_logic_vector(2 downto 0) := "001";
    constant IUCOND_BRLZ  : std_logic_vector(2 downto 0) := "010";
    constant IUCOND_BRLEZ : std_logic_vector(2 downto 0) := "011";
    constant IUCOND_BRLBS : std_logic_vector(2 downto 0) := "100";
    constant IUCOND_BRNZ  : std_logic_vector(2 downto 0) := "101";
    constant IUCOND_BRGZ  : std_logic_vector(2 downto 0) := "110";
    constant IUCOND_BRGEZ : std_logic_vector(2 downto 0) := "111";

    component iucond
        port (
            iucond_cs_in   : in    std_logic;
            iucond_cond_in : in    std_logic_vector( 2 downto 0);
            iucond_di_in   : in    std_logic_vector(31 downto 0);
            iucond_do_out  :   out std_logic
        );
    end component;

end iucond_pac;

-- package body iucond_pac is
-- end iucond_pac;
