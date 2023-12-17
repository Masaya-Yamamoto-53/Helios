--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Register File Register
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.iurf_pac.all;
use work.iumawb_pac.all;

package iurfreg_pac is

    component iurfreg
        port (
           iurfreg_clk_in     : in    std_logic;
           iurfreg_rs1_sel_in : in    iurf_rs_sel_if;
           iurfreg_rs2_sel_in : in    iurf_rs_sel_if;
           iurfreg_rs3_sel_in : in    iurf_rs_sel_if;
           iurfreg_w_in       : in    st_iumawb_if;
           iurfreg_rs1_do_out :   out iurf_rs_data_if;
           iurfreg_rs2_do_out :   out iurf_rs_data_if;
           iurfreg_rs3_do_out :   out iurf_rs_data_if
        );
    end component;

end iurfreg_pac;

-- package body iurfreg_pac is
-- end iurfreg_pac;
