----------------------------------------------------------------------------------
-- Create Date    : 2022/02/27
-- Design Name    : 
-- Module Name    : sramctrl - RTL
-- Target Devices : 
-- Description    : 
--
-- Dependencies   : 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.sramctrl_pac.all;

entity sramctrl is
    port (
        sramctrl_sys_cs_in   : in    std_logic;
        sramctrl_sys_clk_in  : in    std_logic;
        sramctrl_sys_we_in   : in    std_logic;
        sramctrl_sys_addr_in : in    std_logic_vector (18 downto 0);
        sramctrl_sys_di_in   : in    std_logic_vector (31 downto 0);
        sramctrl_sys_di_out  :   out std_logic_vector (31 downto 0);

        sramctrl_wen_out     :   out std_logic;
        sramctrl_cen_out     :   out std_logic;
        sramctrl_oen_out     :   out std_logic;

        sramctrl_di_in       : in    std_logic_vector ( 7 downto 0);
        sramctrl_addr_out    :   out std_logic_vector (18 downto 0);
        sramctrl_do_out      :   out std_logic_vector ( 7 downto 0)
    );
end sramctrl;

architecture rtl of sramctrl is

    signal di_sig : std_logic_vector (31 downto 0);
    signal do_sig : std_logic_vector ( 7 downto 0);

begin

    sramctrl_wen_out  <= '0' when ((sramctrl_sys_cs_in = '1') and (sramctrl_sys_we_in = '1')) else
                         '1' when ((sramctrl_sys_cs_in = '1') and (sramctrl_sys_we_in = '0')) else
                         '1';

    sramctrl_cen_out  <= '0' when ((sramctrl_sys_cs_in = '1') and (sramctrl_sys_we_in = '1')) else
                         '0' when ((sramctrl_sys_cs_in = '1') and (sramctrl_sys_we_in = '0')) else
                         '1';

    sramctrl_oen_out  <= '0' when ((sramctrl_sys_cs_in = '1') and (sramctrl_sys_we_in = '1')) else
                         '0' when ((sramctrl_sys_cs_in = '1') and (sramctrl_sys_we_in = '0')) else
                         '1';

    sramctrl_addr_out <= sramctrl_sys_addr_in when sramctrl_sys_cs_in = '1' else
                        (others => '0');

    -- Byte Store
    with sramctrl_sys_addr_in(1 downto 0) select
    di_sig <=       sramctrl_di_in & X"000000" when "00",
              X"00" & sramctrl_di_in & X"0000" when "01",
              X"0000" & sramctrl_di_in & X"00" when "10",
              X"000000" & sramctrl_di_in       when others;

    sramctrl_sys_di_out <= di_sig when ((sramctrl_sys_cs_in = '1')
                                   and (sramctrl_sys_we_in = '0')) else
                           (others => '0');

    -- Byte Load
    with sramctrl_sys_addr_in(1 downto 0) select
    do_sig <= sramctrl_sys_di_in(31 downto 24) when "00",
              sramctrl_sys_di_in(23 downto 16) when "01",
              sramctrl_sys_di_in(15 downto  8) when "10",
              sramctrl_sys_di_in( 7 downto  0) when others;

    sramctrl_do_out <= do_sig when ((sramctrl_sys_cs_in = '1')
                               and (sramctrl_sys_we_in = '1')) else
                       (others => '0');

end rtl;
