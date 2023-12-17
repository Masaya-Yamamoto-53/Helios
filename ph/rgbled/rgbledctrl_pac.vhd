library ieee;
use ieee.std_logic_1164.all;

package rgbledctrl_pac is

    component rgbledctrl
        generic (
            C_GEN_PW_EXP : integer := 8
        );
        port (
            rgbledctrl_clk_in    : in    std_logic;

            rgbledctrl_st_reg_in : in    std_logic;

            rgbledctrl_r_reg_in  : in    std_logic_vector(C_GEN_PW_EXP-1 downto 0);
            rgbledctrl_g_reg_in  : in    std_logic_vector(C_GEN_PW_EXP-1 downto 0);
            rgbledctrl_b_reg_in  : in    std_logic_vector(C_GEN_PW_EXP-1 downto 0);

            rgbledctrl_r_out     :   out std_logic;
            rgbledctrl_g_out     :   out std_logic;
            rgbledctrl_b_out     :   out std_logic
        );
    end component;

end rgbledctrl_pac;

-- package body rgbledctrl_pac is
-- end rgbledctrl_pac;
