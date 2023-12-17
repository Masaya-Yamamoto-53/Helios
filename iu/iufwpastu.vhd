--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Fowarding Past Unit
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iufwu_pac.all;

entity iufwpastu is
    port (
        iufwpastu_rs1_fw_in  : in    std_logic_vector( 3 downto 0);
        iufwpastu_rs1_di_in  : in    std_logic_vector(31 downto 0);

        iufwpastu_rs2_fw_in  : in    std_logic_vector( 3 downto 0);
        iufwpastu_rs2_di_in  : in    std_logic_vector(31 downto 0);

        iufwpastu_rs3_fw_in  : in    std_logic_vector( 3 downto 0);
        iufwpastu_rs3_di_in  : in    std_logic_vector(31 downto 0);

        iufwpastu_ma_rd_in   : in    st_iufwpast_if;
        iufwpastu_wb_rd_in   : in    st_iufwpast_if;

        iufwpastu_rs1_do_out :   out std_logic_vector(31 downto 0);
        iufwpastu_rs2_do_out :   out std_logic_vector(31 downto 0);
        iufwpastu_rs3_do_out :   out std_logic_vector(31 downto 0)
    );
end iufwpastu;

architecture rtl of iufwpastu is

begin

    -----------------------------------------------------------
    -- IU Forwarding Past RS1                                --
    -----------------------------------------------------------
    IU_Forwarding_Past_rs1 : iufwpast
    port map (
        iufwpast_fw_in      => iufwpastu_rs1_fw_in,
        iufwpast_ex_data_in => iufwpastu_rs1_di_in,
        iufwpast_ma_rd_in   => iufwpastu_ma_rd_in,
        iufwpast_wb_rd_in   => iufwpastu_wb_rd_in,
        iufwpast_data_out   => iufwpastu_rs1_do_out
    );

    -----------------------------------------------------------
    -- IU Forwarding Past RS2                                --
    -----------------------------------------------------------
    IU_Forwarding_Past_rs2 : iufwpast
    port map (
        iufwpast_fw_in      => iufwpastu_rs2_fw_in,
        iufwpast_ex_data_in => iufwpastu_rs2_di_in,
        iufwpast_ma_rd_in   => iufwpastu_ma_rd_in,
        iufwpast_wb_rd_in   => iufwpastu_wb_rd_in,
        iufwpast_data_out   => iufwpastu_rs2_do_out
    );

    -----------------------------------------------------------
    -- IU Forwarding Past RS3                                --
    -----------------------------------------------------------
    IU_Forwarding_Past_rs3 : iufwpast
    port map (
        iufwpast_fw_in      => iufwpastu_rs3_fw_in,
        iufwpast_ex_data_in => iufwpastu_rs3_di_in,
        iufwpast_ma_rd_in   => iufwpastu_ma_rd_in,
        iufwpast_wb_rd_in   => iufwpastu_wb_rd_in,
        iufwpast_data_out   => iufwpastu_rs3_do_out
    );

end rtl;
