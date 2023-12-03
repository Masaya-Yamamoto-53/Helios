library ieee;
use ieee.std_logic_1164.all;

use work.iu_pac.all;
use work.iumawb_pac.all;

package iurf_pac is

    constant IURF_R_ZERO : std_logic_vector(4 downto 0) :=  "00000"; -- Zero Register
    constant IURF_R_RET  : std_logic_vector(4 downto 0) :=  "11101"; -- Return Address
    constant IURF_R_PC   : std_logic_vector(4 downto 0) :=  "11110"; -- Program Counter
    constant IURF_R_SP   : std_logic_vector(4 downto 0) :=  "11111"; -- Stack Pointer

    subtype iurf_rs_sel_if  is std_logic_vector( 4 downto 0);
    subtype iurf_rs_data_if is std_logic_vector(31 downto 0);
    subtype iurf_pc_if      is std_logic_vector(29 downto 0);

    component iurf
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
    end component;

end iurf_pac;

-- package body iurf_pac is
-- end iurf_pac;
