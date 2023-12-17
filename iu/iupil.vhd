--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Processor Interrupt Level Register
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iupil_pac.all;

entity iupil is
    port (
        iupil_clk_in : in    std_logic;
        iupil_rst_in : in    std_logic;
        iupil_we_in  : in    std_logic;
        iupil_di_in  : in    std_logic_vector(3 downto 0);
        iupil_do_out :   out std_logic_vector(3 downto 0)
    );
end iupil;

architecture rtl of iupil is

    signal pil_reg : std_logic_vector(3 downto 0) := (others => '1');

begin

    IU_Priority_Interrupt_Level_Register : process (
        iupil_clk_in,
        iupil_rst_in,
        iupil_we_in,
        iupil_di_in
    )
    begin
        if (iupil_clk_in'event and iupil_clk_in = '1') then
            if (iupil_rst_in = '1') then
                pil_reg <= (others => '1');
            elsif (iupil_we_in = '1') then
                pil_reg <= iupil_di_in;
            end if;
        end if;
    end process IU_Priority_Interrupt_Level_Register;

    iupil_do_out <= iupil_di_in when    ((iupil_rst_in = '0')
                                     and (iupil_we_in  = '1')) else
                    pil_reg;

end rtl;
