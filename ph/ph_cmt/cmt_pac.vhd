library ieee;
use ieee.std_logic_1164.all;

package cmt_pac is

    component cmt
        port (
            cmt_cs_in   : in    std_logic;
            cmt_clk_in  : in    std_logic;
            cmt_rst_in  : in    std_logic;
            cmt_we_in   : in    std_logic;
            cmt_addr_in : in    std_logic_vector ( 1 downto 0);
            cmt_di_in   : in    std_logic_vector (15 downto 0);
            cmt_do_out  :   out std_logic_vector (15 downto 0);
            cmt_cmi_out :   out std_logic
        );
    end component;

end cmt_pac;

-- package body cmt_pac is
-- end cmt_pac;
