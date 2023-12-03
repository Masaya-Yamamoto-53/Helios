library ieee;
use ieee.std_logic_1164.all;

package iuintr_pac is

    component iuintr
        port (
            iuintr_clk_in        : in    std_logic;
            iuintr_rst_in        : in    std_logic;

            iuintr_dis_in        : in    std_logic;

            iuintr_excep_req_in  : in    std_logic_vector(15 downto 0);

            iuintr_rett_req_in   : in    std_logic;
            iuintr_rett_we_in    : in    std_logic;
            iuintr_rett_addr_in  : in    std_logic_vector(29 downto 0);

            iuintr_intr_in       : in    std_logic;
            iuintr_irl_in        : in    std_logic_vector( 3 downto 0);
            iuintr_pil_in        : in    std_logic_vector( 3 downto 0);

            iuintr_vec_we_out    :   out std_logic;
            iuintr_vec_addr_out  :   out std_logic_vector(29 downto 0);

            iuintr_intr_req_out  :   out std_logic;
            iuintr_intr_inst_out :   out std_logic_vector(31 downto 0);
            iuintr_intr_ack_out  :   out std_logic
        );
    end component;

end iuintr_pac;

-- package body iuintr_pac is
-- end iuintr_pac;
