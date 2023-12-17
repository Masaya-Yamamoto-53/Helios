library ieee;
use ieee.std_logic_1164.all;

package sramctrl_pac is

    component sramctrl
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
    end component;

end sramctrl_pac;

-- package body sramctrl_pac is
-- end sramctrl_pac;
