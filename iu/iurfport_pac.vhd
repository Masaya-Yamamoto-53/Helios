library ieee;
use ieee.std_logic_1164.all;

use work.iurf_pac.all;
use work.iumawb_pac.all;

package iurfport_pac is

    component iurfport
        port (
           iurfport_sel_in : in    iurf_rs_sel_if;
           iurfport_di_in  : in    iurf_rs_data_if;
           iurfport_pc_in  : in    iurf_pc_if;
           iurfport_w_in   : in    st_iumawb_if;
           iurfport_do_out :   out iurf_rs_data_if
        );
    end component;

end iurfport_pac;

-- package body iurfport_pac is
-- end iurfport_pac;
