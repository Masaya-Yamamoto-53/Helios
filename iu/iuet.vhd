--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Enable Trap Reigster
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iuet_pac.all;

entity iuet is
    port (
        iuet_clk_in  : in    std_logic;
        iuet_rst_in  : in    std_logic;
        iuet_we_in   : in    std_logic;
        iuet_di_in   : in    std_logic;
        iuet_do_out  :   out std_logic
    );
end iuet;

architecture rtl of iuet is

    signal et_reg : std_logic := '0';

begin

    IU_Enable_Trap_Register : process (
        iuet_clk_in,
        iuet_rst_in,
        iuet_we_in,
        iuet_di_in,
        et_reg
    )
    begin
        if (iuet_clk_in'event and iuet_clk_in = '1') then
            if (iuet_rst_in = '1') then
                et_reg <= '0';
            elsif (iuet_we_in = '1') then
                et_reg <= iuet_di_in;
            end if;
        end if;
    end process IU_Enable_Trap_Register;

    iuet_do_out <= iuet_di_in when ((iuet_rst_in = '0')
                                and (iuet_we_in  = '1')) else
                   et_reg;

end rtl;
