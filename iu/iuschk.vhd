--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Privileged Instruction Detection
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iuschk_pac.all;

entity iuschk is
    port (
        iuschk_intr_req_in : in    std_logic;
        iuschk_rett_in     : in    std_logic;
        iuschk_psr_in      : in    std_logic;
        iuschk_read_in     : in    std_logic;
        iuschk_write_in    : in    std_logic;
        iuschk_a_in        : in    std_logic;
        iuschk_s_in        : in    std_logic;
        iuschk_rett_en_out :   out std_logic;
        iuschk_psr_en_out  :   out std_logic;
        iuschk_lda_en_out  :   out std_logic;
        iuschk_sta_en_out  :   out std_logic
    );
end iuschk;

architecture rtl of iuschk is

begin

    -- rett  s   en 
    -- +---+---+---+
    -- | 0 | 0 | 1 | Not Supervisor
    -- | 0 | 1 | 1 |     Supervisor
    -- | 1 | 0 | 0 | Not Supervisor
    -- | 1 | 1 | 1 |     Supervisor
    -- +---+---+---+
    iuschk_rett_en_out <= '0' when ((iuschk_rett_in     = '1')
                                and (iuschk_s_in        = '0')) else
                          '1';

    --  psr  s   en 
    -- +---+---+---+
    -- | 0 | 0 | 1 | Not Supervisor
    -- | 0 | 1 | 1 |     Supervisor
    -- | 1 | 0 | 0 | Not Supervisor
    -- | 1 | 1 | 1 |     Supervisor
    -- +---+---+---+
    iuschk_psr_en_out  <= '0' when ((iuschk_intr_req_in = '0')
                                and (iuschk_psr_in      = '1')
                                and (iuschk_s_in        = '0')) else
                          '1';

    --   a   s   en 
    -- +---+---+---+
    -- | 0 | 0 | 1 | Non-Privileged & Not Supervisor
    -- | 0 | 1 | 1 | Non-Privileged &     Supervisor
    -- | 1 | 0 | 0 |     Privilegad & Not Supervisor
    -- | 1 | 1 | 1 |     Privilegad &     Supervisor
    -- +---+---+---+
    iuschk_lda_en_out  <= '0' when ((iuschk_read_in     = '1')
                                and (iuschk_a_in        = '1')
                                and (iuschk_s_in        = '0')) else
                          '1';

    --   a   s   en 
    -- +---+---+---+
    -- | 0 | 0 | 1 | Non-Privileged & Not Supervisor
    -- | 0 | 1 | 1 | Non-Privileged &     Supervisor
    -- | 1 | 0 | 0 |     Privilegad & Not Supervisor
    -- | 1 | 1 | 1 |     Privilegad &     Supervisor
    -- +---+---+---+
    iuschk_sta_en_out  <= '0' when ((iuschk_write_in    = '1')
                                and (iuschk_a_in        = '1')
                                and (iuschk_s_in        = '0')) else
                          '1';

end rtl;
