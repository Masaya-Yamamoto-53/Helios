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

    -- The priority of hazards.
    -- MA stage exception > EX stage exception > Branch > Data hazard
    ma_sel_sig    <=      ma_sig;
    ex_sel_ex_sig <= (not ma_sig) and iuhdu_ex_excep_in;
    -- If an exception also occurs in the EX stage,
    -- the exception control signals will be selected for subsequent processing;
    -- therefore, the presence of an exception is not determined here.
    ex_sel_br_sig <= (not ma_sig) and iuhdu_ex_branch_in;
    id_sel_sig    <= (not ma_sig) and (not ex_sig) and id_sig;

    -- Behavior when an exception occurs in the MA stage:
    --      +------+------+------+------+------+
    --      |    IF/ID  ID/EX  EX/MA  MA/WB    |
    --      +------+------+------+------+------+
    -- CYC1 |  I4  |  I3  |  I2  | (I1) |      | Detected exception(The part enclosed in parentheses).
    --      +------+------+------+------+------+
    -- CYC2 |  I5  |  XX  |  XX  |  XX  |  XX  |
    --      +------+------+------+------+------+
    -- CYC3 |  I6  |  I5  |  XX  |  XX  |  XX  |
    --      +------+------+------+------+------+
    -- I2: T1 is followed by the next executed instruction.
    -- I3: I2 is followed by the next executed instruction.
    -- I4: I3 is followed by the next executed instruction.
    -- I5: The instruction at the branch target upon an exception occurrence.
    -- XX: Disabled instructon.
    --
    --                    +--------- IF WEN   (Program Counter Write Enable)
    --                    |+-------- ID WEN   (IF/ID Pipeline Register Write Enable)
    --                    ||+------- ID FLASH (IF/ID Pipeline Register Flash)
    --                    |||+------ EX WE    (ID/EX Pipeline Register Write Enable)
    --                    ||||+----- EX FLASH (ID/EX Pipeline Register Flash)
    --                    |||||+---- MA WE    (EX/MA Pipeline Register Write Enable)
    --                    ||||||+--- MA FLASH (EX/MA Pipeline Register Flash)
    --                    |||||||+-- WB WE    (MA/WB Pipeline Register Write Enable)
    --                    ||||||||+- WB FLASH (MA/WB Pipeline Register Flash)
    --                    |||||||||
    hzd_cmd_ma_sig    <= "001010101" and (8 downto 0 => ma_sel_sig   );

    -- Behavior when an exception occurs in the EX stage:
    --      +------+------+------+------+------+
    --      |    IF/ID  ID/EX  EX/MA  MA/WB    |
    --      +------+------+------+------+------+
    -- CYC1 |  I3  |  I2  | (I1) |      |      | Detected exception(The part enclosed in parentheses).
    --      +------+------+------+------+------+
    -- CYC2 |  I5  |  XX  |  XX  |  XX  |      |
    --      +------+------+------+------+------+
    -- CYC3 |  I6  |  I5  |  XX  |  XX  |  XX  |
    --      +------+------+------+------+------+
    -- I2: T1 is followed by the next executed instruction.
    -- I3: I2 is followed by the next executed instruction.
    -- I5: The instruction at the branch target upon an exception occurrence.
    -- XX: Disabled instructon.
    --
    --                    +--------- IF WEN   (Program Counter Write Enable)
    --                    |+-------- ID WEN   (IF/ID Pipeline Register Write Enable)
    --                    ||+------- ID FLASH (IF/ID Pipeline Register Flash)
    --                    |||+------ EX WE    (ID/EX Pipeline Register Write Enable)
    --                    ||||+----- EX FLASH (ID/EX Pipeline Register Flash)
    --                    |||||+---- MA WE    (EX/MA Pipeline Register Write Enable)
    --                    ||||||+--- MA FLASH (EX/MA Pipeline Register Flash)
    --                    |||||||+-- WB WE    (MA/WB Pipeline Register Write Enable)
    --                    ||||||||+- WB FLASH (MA/WB Pipeline Register Flash)
    --                    |||||||||
    hzd_cmd_ex_ex_sig <= "001010100" and (8 downto 0 => ex_sel_ex_sig);

    -- Behavior upon branching:
    --      +------+------+------+------+------+
    --      |    IF/ID  ID/EX  EX/MA  MA/WB    |
    --      +------+------+------+------+------+
    -- CYC1 |  I3  |  I2  | (I1) |      |      | Detected prediction error(The part enclosed in parentheses).
    --      +------+------+------+------+------+
    -- CYC2 |  I5  |  XX  |  XX  |  T1  |      | Flash the stored data in the pipeline retisters.
    --      +------+------+------+------+------+
    -- CYC3 |  I6  |  I5  |  XX  |  XX  |  T1  |
    --      +------+------+------+------+------+
    -- I1: Branch instruction
    -- I2: T1 is followed by the next executed instruction.
    -- I3: I2 is followed by the next executed instruction.
    -- I5: The instruction at the branch target.
    -- I6: I5 is followed by the next executed instruction.
    -- XX: Disabled instructon.
    --
    --                    +--------- IF WEN   (Program Counter Write Enable)
    --                    |+-------- ID WEN   (IF/ID Pipeline Register Write Enable)
    --                    ||+------- ID FLASH (IF/ID Pipeline Register Flash)
    --                    |||+------ EX WE    (ID/EX Pipeline Register Write Enable)
    --                    ||||+----- EX FLASH (ID/EX Pipeline Register Flash)
    --                    |||||+---- MA WE    (EX/MA Pipeline Register Write Enable)
    --                    ||||||+--- MA FLASH (EX/MA Pipeline Register Flash)
    --                    |||||||+-- WB WE    (MA/WB Pipeline Register Write Enable)
    --                    ||||||||+- WB FLASH (MA/WB Pipeline Register Flash)
    --                    |||||||||
    hzd_cmd_ex_br_sig <= "001010000" and (8 downto 0 => ex_sel_br_sig);

    -- Behavior during data hazard occurrence:
    --      +------+------+------+------+------+
    --      |    IF/ID  ID/EX  EX/MA  MA/WB    |
    --      +------+------+------+------+------+
    -- CYC1 |  I3  | (I2) |  I1  |      |      | Detected data hazard(The part enclosed in parentheses).
    --      +------+------+------+------+------+
    -- CYC2 |  I3  |  I2  |  XX  |  T1  |      | Flash the stored data in the pipeline registers.
    --      | HOLD | HOLD |      |      |      |
    --      +------+------+------+------+------+
    -- CYC3 |      |      |  I2  |  XX  |  I1  | Forward the data from the MA stage to the EX stage.
    --      +------+------+------+------+------+
    -- I1: Memory read, PSR read, or multiplication instruction.
    -- I2: The instruction that uses the immediately preceding register.
    -- I3: I2 is followed by the next executed instruction.
    -- XX: Disabled instructon.
    --
    --                    +--------- IF WEN   (Program Counter Write Enable)
    --                    |+-------- ID WEN   (IF/ID Pipeline Register Write Enable)
    --                    ||+------- ID FLASH (IF/ID Pipeline Register Flash)
    --                    |||+------ EX WE    (ID/EX Pipeline Register Write Enable)
    --                    ||||+----- EX FLASH (ID/EX Pipeline Register Flash)
    --                    |||||+---- MA WE    (EX/MA Pipeline Register Write Enable)
    --                    ||||||+--- MA FLASH (EX/MA Pipeline Register Flash)
    --                    |||||||+-- WB WE    (MA/WB Pipeline Register Write Enable)
    --                    ||||||||+- WB FLASH (MA/WB Pipeline Register Flash)
    --                    |||||||||
    hzd_cmd_id_sig    <= "110010000" and (8 downto 0 => id_sel_sig   );

    hzd_cmd_sig <= hzd_cmd_ma_sig
                or hzd_cmd_ex_ex_sig
                or hzd_cmd_ex_br_sig
                or hzd_cmd_id_sig;

    iuhdu_pc_wen_out     <= hzd_cmd_sig(IUHDU_IF_WEN);
    iuhdu_ifid_wen_out   <= hzd_cmd_sig(IUHDU_ID_WEN);
    iuhdu_ifid_flash_out <= hzd_cmd_sig(IUHDU_ID_FLASH);
    iuhdu_idex_wen_out   <= hzd_cmd_sig(IUHDU_EX_WEN);
    iuhdu_idex_flash_out <= hzd_cmd_sig(IUHDU_EX_FLASH);
    iuhdu_exma_wen_out   <= hzd_cmd_sig(IUHDU_MA_WEN);
    iuhdu_exma_flash_out <= hzd_cmd_sig(IUHDU_MA_FLASH);
    iuhdu_mawb_wen_out   <= hzd_cmd_sig(IUHDU_WB_WEN);
    iuhdu_mawb_flash_out <= hzd_cmd_sig(IUHDU_WB_FLASH);

end rtl;
