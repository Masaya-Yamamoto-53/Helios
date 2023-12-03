library ieee;
use ieee.std_logic_1164.all;

package iuschk_pac is

    component iuschk
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
    end component;

end iuschk_pac;

-- package body iuschk_pac is
-- end iuschk_pac;
