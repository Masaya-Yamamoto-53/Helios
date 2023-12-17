--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU IF/ID Pipeline Register
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.iuifid_pac.all;

entity iuifid is
    port (
        iuifid_clk_in   : in    std_logic;
        iuifid_rst_in   : in    std_logic;
        iuifid_wen_in   : in    std_logic;
        iuifid_flash_in : in    std_logic;
        iuifid_di_in    : in    st_iuifid_if;
        iuifid_do_out   :   out st_iuifid_if
    );
end iuifid;

architecture rtl of iuifid is

    signal iuifid_reg : st_iuifid_if := st_iuifid_if_INIT;

begin

    -----------------------------------------------------------
    -- IU IF/ID Pipeline Register with Reset                 --
    -----------------------------------------------------------
    IFID_Pipeline_Register_with_Reset : process (
        iuifid_clk_in,
        iuifid_rst_in,
        iuifid_wen_in,
        iuifid_flash_in,
        iuifid_di_in
    )
    begin
        if (iuifid_clk_in'event and iuifid_clk_in = '1') then
            if ((iuifid_rst_in = '1') or (iuifid_flash_in = '1')) then
                iuifid_reg.intr_req <= st_iuifid_if_INIT.intr_req;
                iuifid_reg.inst     <= st_iuifid_if_INIT.inst;
                iuifid_reg.token    <= st_iuifid_if_INIT.token;
            else
                if (iuifid_wen_in = '0') then
                    iuifid_reg.intr_req <= iuifid_di_in.intr_req;
                    iuifid_reg.inst     <= iuifid_di_in.inst;
                    iuifid_reg.token    <= iuifid_di_in.token;
                end if;
            end if;
        end if;
    end process IFID_Pipeline_Register_with_Reset;

    -----------------------------------------------------------
    -- IU IF/ID Pipeline Register without Reset              --
    -----------------------------------------------------------
    IFID_Pipeline_Register_without_Reset : process (
        iuifid_clk_in,
        iuifid_rst_in,
        iuifid_wen_in,
        iuifid_flash_in,
        iuifid_di_in
    )
    begin
        if (iuifid_clk_in'event and iuifid_clk_in = '1') then
            if (iuifid_wen_in = '0') then
                iuifid_reg.pc <= iuifid_di_in.pc;
            end if;
        end if;
    end process IFID_Pipeline_Register_without_Reset;

    iuifid_do_out <= iuifid_reg;

end rtl;
