--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Instruction Decode Stage
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.iufwu_pac.all;
use work.iuidex_pac.all;

package iuidstg_pac is

    component iuidstg
        port (
            iuidstg_intr_req_in  : in    std_logic;
            iuidstg_inst_in      : in    std_logic_vector(31 downto 0);
            iuidstg_token_in     : in    std_logic;
            iuidstg_rs1_sel_out  :   out std_logic_vector( 4 downto 0);
            iuidstg_rs2_sel_out  :   out std_logic_vector( 4 downto 0);
            iuidstg_rs3_sel_out  :   out std_logic_vector( 4 downto 0);
            iuidstg_rs1_di_in    : in    std_logic_vector(31 downto 0);
            iuidstg_rs2_di_in    : in    std_logic_vector(31 downto 0);
            iuidstg_rs3_di_in    : in    std_logic_vector(31 downto 0);
            iuidstg_pc_in        : in    std_logic_vector(29 downto 0);
            iuidstg_ex_rd_in     : in    st_iufwpre_if;
            iuidstg_ma_rd_in     : in    st_iufwpre_if;
            iuidstg_ex_read_in   : in    std_logic;
            iuidstg_data_hzd_out :   out std_logic;
            iuidstg_do_out       :   out st_iuidex_if
        );
    end component;

    function iuidstg_sign_extend_simm13 (
        signal data : std_logic_vector(12 downto 0)
    ) return std_logic_vector;

end iuidstg_pac;

package body iuidstg_pac is

    function iuidstg_sign_extend_simm13 (
        signal data : std_logic_vector(12 downto 0)
    ) return std_logic_vector is
    begin
        return data(12) & data(12) & data(12) & data(12) &
               data(12) & data(12) & data(12) & data(12) &
               data(12) & data(12) & data(12) & data(12) &
               data(12) & data(12) & data(12) & data(12) &
               data(12) & data(12) & data(12) & data;
    end iuidstg_sign_extend_simm13;

end iuidstg_pac;
