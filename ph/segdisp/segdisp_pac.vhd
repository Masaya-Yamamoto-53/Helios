library ieee;
use ieee.std_logic_1164.all;

package segdisp_pac is

    component segdisp
    port(
        segdisp_cs_in       : in    std_logic;
        segdisp_clk_in      : in    std_logic;
        segdisp_rst_in      : in    std_logic;
        segdisp_we_in       : in    std_logic;
        segdisp_addr_in     : in    std_logic_vector( 1 downto 0);
        segdisp_di_in       : in    std_logic_vector(15 downto 0);
        segdisp_do_out      :   out std_logic_vector(15 downto 0);
        segdisp_seg_do_out  :   out std_logic_vector(14 downto 0);
        segdisp_seg_sel_out :   out std_logic_vector( 1 downto 0)
        );
    end component;

end segdisp_pac;

-- package body segdisp_pac is
-- end segdisp_pac;
