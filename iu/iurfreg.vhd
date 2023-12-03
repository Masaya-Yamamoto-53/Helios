library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iu_pac.all;
use work.iurf_pac.all;
use work.iumawb_pac.all;

entity iurfreg is
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
end iurfreg;

architecture rtl of iurfreg is

    type reg_t  is array (0 to 31) of std_logic_vector(31 downto 0);
    signal g_reg : reg_t;

begin

    IU_RegisterFile : process (
        iurfreg_clk_in,
        iurfreg_w_in,
        g_reg
    )
    begin
        if (iurfreg_clk_in'event and iurfreg_clk_in = '1') then
            if (iurfreg_w_in.rd_we = '1') then
                g_reg(to_integer(unsigned(iurfreg_w_in.rd_sel))) <= iurfreg_w_in.rd_data;
            end if;
        end if;
    end process IU_RegisterFile;

    iurfreg_rs1_do_out <= g_reg(to_integer(unsigned(iurfreg_rs1_sel_in)));
    iurfreg_rs2_do_out <= g_reg(to_integer(unsigned(iurfreg_rs2_sel_in)));
    iurfreg_rs3_do_out <= g_reg(to_integer(unsigned(iurfreg_rs3_sel_in)));

end rtl;
