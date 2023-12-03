library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iu_pac.all;
use work.iumawb_pac.all;
use work.iurf_pac.all;

entity iurfport is
    port (
       iurfport_sel_in : in    iurf_rs_sel_if;
       iurfport_di_in  : in    iurf_rs_data_if;
       iurfport_pc_in  : in    iurf_pc_if;
       iurfport_w_in   : in    st_iumawb_if;
       iurfport_do_out :   out iurf_rs_data_if
    );
end iurfport;

architecture rtl of iurfport is

    signal do_sig : std_logic_vector(31 downto 0);

begin

    do_sig <= iurfport_w_in.rd_data when ((iurfport_w_in.rd_sel = iurfport_sel_in)
                                      and (iurfport_w_in.rd_we  = '1'            )) else
              iurfport_di_in;

    with iurfport_sel_in select
    iurfport_do_out <= (others => '0')       when IURF_R_ZERO,
                       iurfport_pc_in & "00" when IURF_R_PC,
                       do_sig                when others;

end rtl;
