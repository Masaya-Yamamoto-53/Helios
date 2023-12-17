--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Condition
-- Description:
--   * cond_in = "000": BRLBC : Branch if Register Low Bit is Clear
--   * cond_in = "001": BRZ   : Branch of Register Zero
--   * cond_in = "010": BRLZ  : Branch on Register Less Than Zero
--   * cond_in = "011": BRLEZ : Branch on Register Less Than or Equal to Zero
--   * cond_in = "100": BRLBS : Branch if Register Low Bit is Set
--   * cond_in = "101": BRNZ  : Branch on Register Not Zero
--   * cond_in = "110": BRGZ  : Branch on Register Greater Than Zero
--   * cond_in = "111": BRGEZ : Branch on Register Greater Than or Equal to Zero
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

use work.iucond_pac.all;

entity iucond is
    port (
        iucond_cs_in   : in    std_logic;
        iucond_cond_in : in    std_logic_vector( 2 downto 0);
        iucond_di_in   : in    std_logic_vector(31 downto 0);
        iucond_do_out  :   out std_logic
    );
end iucond;

architecture rtl of iucond is

    signal cond_sig  : std_logic_vector( 2 downto 0);
    signal di_sig    : std_logic_vector(31 downto 0);

    signal n_sig     : std_logic;
    signal z_sig     : std_logic;

    signal brz_sig   : std_logic;
    signal brlz_sig  : std_logic;
    signal brlez_sig : std_logic;
    signal brlbc_sig : std_logic;
    signal brnz_sig  : std_logic;
    signal brgz_sig  : std_logic;
    signal brgez_sig : std_logic;
    signal brlbs_sig : std_logic;

begin

    cond_sig  <= iucond_cond_in when iucond_cs_in = '1' else IUCOND_BRLBS;
    di_sig    <= iucond_di_in   and (31 downto 0 => iucond_cs_in);

    n_sig     <= di_sig(31);
    z_sig     <= '1' when di_sig = X"00000000" else '0';

    brz_sig   <= '1' when (cond_sig = IUCOND_BRZ  ) and  (z_sig = '1')           else '0';
    brnz_sig  <= '1' when (cond_sig = IUCOND_BRNZ ) and  (z_sig = '0')           else '0';
    brlz_sig  <= '1' when (cond_sig = IUCOND_BRLZ ) and  (n_sig = '1')           else '0';
    brgez_sig <= '1' when (cond_sig = IUCOND_BRGEZ) and  (n_sig = '0')           else '0';
    brlez_sig <= '1' when (cond_sig = IUCOND_BRLEZ) and ((z_sig or n_sig) = '1') else '0';
    brgz_sig  <= '1' when (cond_sig = IUCOND_BRGZ ) and ((z_sig or n_sig) = '0') else '0';
    brlbs_sig <= '1' when (cond_sig = IUCOND_BRLBS) and  (di_sig(0) = '1')       else '0';
    brlbc_sig <= '1' when (cond_sig = IUCOND_BRLBC) and  (di_sig(0) = '0')       else '0';

    iucond_do_out <= brz_sig
                  or brnz_sig
                  or brlz_sig
                  or brgez_sig
                  or brlez_sig
                  or brgz_sig
                  or brlbs_sig
                  or brlbc_sig;

end rtl;
