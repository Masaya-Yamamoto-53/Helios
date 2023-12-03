library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iu_pac.all;
use work.iurf_pac.all;
use work.iumawb_pac.all;

use work.iurfreg_pac.all;
use work.iurfport_pac.all;

entity iurf is
    port (
       iurf_clk_in     : in    std_logic;
       iurf_rs1_sel_in : in    iurf_rs_sel_if;
       iurf_rs2_sel_in : in    iurf_rs_sel_if;
       iurf_rs3_sel_in : in    iurf_rs_sel_if;
       iurf_w_in       : in    st_iumawb_if;
       iurf_pc_in      : in    iurf_pc_if;
       iurf_rs1_do_out :   out iurf_rs_data_if;
       iurf_rs2_do_out :   out iurf_rs_data_if;
       iurf_rs3_do_out :   out iurf_rs_data_if
    );
end iurf;

architecture rtl of iurf is

    signal iurf_rs1_do_sig : iurf_rs_data_if;
    signal iurf_rs2_do_sig : iurf_rs_data_if;
    signal iurf_rs3_do_sig : iurf_rs_data_if;

begin

    IU_RegisterFile : iurfreg
    port map (
       iurfreg_clk_in     => iurf_clk_in,
       iurfreg_rs1_sel_in => iurf_rs1_sel_in,
       iurfreg_rs2_sel_in => iurf_rs2_sel_in,
       iurfreg_rs3_sel_in => iurf_rs3_sel_in,
       iurfreg_w_in       => iurf_w_in,
       iurfreg_rs1_do_out => iurf_rs1_do_sig,
       iurfreg_rs2_do_out => iurf_rs2_do_sig,
       iurfreg_rs3_do_out => iurf_rs3_do_sig
    );

    IU_rs1_port : iurfport
    port map (
       iurfport_sel_in => iurf_rs1_sel_in,
       iurfport_di_in  => iurf_rs1_do_sig,
       iurfport_pc_in  => iurf_pc_in,
       iurfport_w_in   => iurf_w_in,
       iurfport_do_out => iurf_rs1_do_out
    );

    IU_rs2_port : iurfport
    port map (
       iurfport_sel_in => iurf_rs2_sel_in,
       iurfport_di_in  => iurf_rs2_do_sig,
       iurfport_pc_in  => iurf_pc_in,
       iurfport_w_in   => iurf_w_in,
       iurfport_do_out => iurf_rs2_do_out
    );

    IU_rs3_port : iurfport
    port map (
       iurfport_sel_in => iurf_rs3_sel_in,
       iurfport_di_in  => iurf_rs3_do_sig,
       iurfport_pc_in  => iurf_pc_in,
       iurfport_w_in   => iurf_w_in,
       iurfport_do_out => iurf_rs3_do_out
    );

end rtl;
