library ieee;
use ieee.std_logic_1164.all;

use work.iu_pac.all;

package iuhdu_pac is

    constant IUHDU_IF_WE    : integer := 0;
    constant IUHDU_ID_WE    : integer := 1;
    constant IUHDU_ID_FLASH : integer := 2;
    constant IUHDU_EX_WE    : integer := 3;
    constant IUHDU_EX_FLASH : integer := 4;
    constant IUHDU_MA_WE    : integer := 5;
    constant IUHDU_MA_FLASH : integer := 6;
    constant IUHDU_WB_WE    : integer := 7;
    constant IUHDU_WB_FLASH : integer := 8;

    component iuhdu
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
    end component;

end iuhdu_pac;

-- package body iuhdu_pac is
-- end iuhdu_pac;
