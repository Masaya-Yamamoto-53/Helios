--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Fowarding Pre Unit
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iufwu_pac.all;

entity iufwpreu is
    port (
        iufwpreu_rs1_sel_in : in    std_logic_vector( 4 downto 0);
        iufwpreu_rs2_sel_in : in    std_logic_vector( 4 downto 0);
        iufwpreu_rs3_sel_in : in    std_logic_vector( 4 downto 0);

        iufwpreu_ex_rd_in   : in    st_iufwpre_if;
        iufwpreu_ma_rd_in   : in    st_iufwpre_if;

        iufwpreu_rs1_fw_out :   out std_logic_vector( 1 downto 0);
        iufwpreu_rs2_fw_out :   out std_logic_vector( 1 downto 0);
        iufwpreu_rs3_fw_out :   out std_logic_vector( 1 downto 0)
    );
end iufwpreu;

architecture rtl of iufwpreu is

begin

    -----------------------------------------------------------
    -- IU Forwarding Previous RS1                            --
    -----------------------------------------------------------
    IU_Forwarding_Previous_rs1 : iufwpre
    port map (
        iufwpre_sel_in   => iufwpreu_rs1_sel_in,
        iufwpre_ex_rd_in => iufwpreu_ex_rd_in,
        iufwpre_ma_rd_in => iufwpreu_ma_rd_in,
        iufwpre_fw_out   => iufwpreu_rs1_fw_out
    );

    -----------------------------------------------------------
    -- IU Forwarding Previous RS2                            --
    -----------------------------------------------------------
    IU_Forwarding_Previous_rs2 : iufwpre
    port map (
        iufwpre_sel_in   => iufwpreu_rs2_sel_in,
        iufwpre_ex_rd_in => iufwpreu_ex_rd_in,
        iufwpre_ma_rd_in => iufwpreu_ma_rd_in,
        iufwpre_fw_out   => iufwpreu_rs2_fw_out
    );

    -----------------------------------------------------------
    -- IU Forwarding Previous RS3                            --
    -----------------------------------------------------------
    IU_Forwarding_Previous_rs3 : iufwpre
    port map (
        iufwpre_sel_in   => iufwpreu_rs3_sel_in,
        iufwpre_ex_rd_in => iufwpreu_ex_rd_in,
        iufwpre_ma_rd_in => iufwpreu_ma_rd_in,
        iufwpre_fw_out   => iufwpreu_rs3_fw_out
    );

end rtl;
