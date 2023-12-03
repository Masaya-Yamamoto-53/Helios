library ieee;
use ieee.std_logic_1164.all;

use work.iu_pac.all;

package iuifid_pac is

    type st_iuifid_if is
    record
        intr_req : std_logic;
        pc       : std_logic_vector(29 downto  0);
        inst     : std_logic_vector(31 downto  0);
        token    : std_logic;
    end record;
    constant st_iuifid_if_INIT : st_iuifid_if := (
        '0',             -- intr_req
        (others => '0'), -- pc
        (others => '0'), -- inst
        '0'              -- token
    );

    component iuifid
        port (
            iuifid_clk_in   : in    std_logic;
            iuifid_rst_in   : in    std_logic;
            iuifid_wen_in   : in    std_logic;
            iuifid_flash_in : in    std_logic;
            iuifid_di_in    : in    st_iuifid_if;
            iuifid_do_out   :   out st_iuifid_if
        );
    end component;

end iuifid_pac;

-- package body iuifid_pac is
-- end iuifid_pac;
