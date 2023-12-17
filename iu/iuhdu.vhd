--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Hazard Unit
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iu_pac.all;
use work.iuhdu_pac.all;

entity iuhdu is
    port (
        iuhdu_ma_excep_in    : in    std_logic;
        iuhdu_ex_excep_in    : in    std_logic;
        iuhdu_ex_branch_in   : in    std_logic;
        iuhdu_id_read_in     : in    std_logic;
        iuhdu_pc_wen_out     :   out std_logic;
        iuhdu_ifid_wen_out   :   out std_logic;
        iuhdu_ifid_flash_out :   out std_logic;
        iuhdu_idex_wen_out   :   out std_logic;
        iuhdu_idex_flash_out :   out std_logic;
        iuhdu_exma_wen_out   :   out std_logic;
        iuhdu_exma_flash_out :   out std_logic;
        iuhdu_mawb_wen_out   :   out std_logic;
        iuhdu_mawb_flash_out :   out std_logic
    );
end iuhdu;

architecture rtl of iuhdu is

    signal ma_sig            : std_logic;
    signal ex_sig            : std_logic;
    signal id_sig            : std_logic;

    signal ma_sel_sig        : std_logic;
    signal ex_sel_ex_sig     : std_logic;
    signal ex_sel_br_sig     : std_logic;
    signal id_sel_sig        : std_logic;

    signal hzd_cmd_ma_sig    : std_logic_vector(8 downto 0);
    signal hzd_cmd_ex_ex_sig : std_logic_vector(8 downto 0);
    signal hzd_cmd_ex_br_sig : std_logic_vector(8 downto 0);
    signal hzd_cmd_id_sig    : std_logic_vector(8 downto 0);
    signal hzd_cmd_sig       : std_logic_vector(8 downto 0);

begin

    ma_sig <= iuhdu_ma_excep_in;

    ex_sig <= iuhdu_ex_excep_in
           or iuhdu_ex_branch_in;

    id_sig <= iuhdu_id_read_in;

    ma_sel_sig    <=      ma_sig;
    ex_sel_ex_sig <= (not ma_sig) and iuhdu_ex_excep_in;
    ex_sel_br_sig <= (not ma_sig) and iuhdu_ex_branch_in;
    id_sel_sig    <= (not ma_sig) and (not ex_sig) and id_sig;

    hzd_cmd_ma_sig    <= "101010100" and (8 downto 0 => ma_sel_sig   );
    hzd_cmd_ex_ex_sig <= "001010100" and (8 downto 0 => ex_sel_ex_sig);
    hzd_cmd_ex_br_sig <= "000010100" and (8 downto 0 => ex_sel_br_sig);
    hzd_cmd_id_sig    <= "000010011" and (8 downto 0 => id_sel_sig   );

    hzd_cmd_sig <= hzd_cmd_ma_sig
                or hzd_cmd_ex_ex_sig
                or hzd_cmd_ex_br_sig
                or hzd_cmd_id_sig;

    iuhdu_pc_wen_out     <= hzd_cmd_sig(IUHDU_IF_WE);
    iuhdu_ifid_wen_out   <= hzd_cmd_sig(IUHDU_ID_WE);
    iuhdu_ifid_flash_out <= hzd_cmd_sig(IUHDU_ID_FLASH);
    iuhdu_idex_wen_out   <= hzd_cmd_sig(IUHDU_EX_WE);
    iuhdu_idex_flash_out <= hzd_cmd_sig(IUHDU_EX_FLASH);
    iuhdu_exma_wen_out   <= hzd_cmd_sig(IUHDU_MA_WE);
    iuhdu_exma_flash_out <= hzd_cmd_sig(IUHDU_MA_FLASH);
    iuhdu_mawb_wen_out   <= hzd_cmd_sig(IUHDU_WB_WE);
    iuhdu_mawb_flash_out <= hzd_cmd_sig(IUHDU_WB_FLASH);

end rtl;
