--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU 32-bit Multiply Register
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iumul32_pac.all;

entity iumul32reg is
    port (
        iumul32reg_clk_in : in    std_logic;
        iumul32reg_wen_in : in    std_logic;
        iumul32reg_di_in  : in    st_iumul32_if;
        iumul32reg_do_out :   out st_iumul32_if
    );
end iumul32reg;

architecture rtl of iumul32reg is

    signal iumul32reg_reg : st_iumul32_if := st_iumul32_if_INIT;

begin

    process (
        iumul32reg_clk_in,
        iumul32reg_wen_in,
        iumul32reg_di_in
    )
    begin
        if (iumul32reg_clk_in'event and iumul32reg_clk_in = '1') then
            if (iumul32reg_wen_in = '0') then
                iumul32reg_reg <= iumul32reg_di_in;
            end if;
        end if;
    end process;

    iumul32reg_do_out <= iumul32reg_reg;

end rtl;
