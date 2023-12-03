library ieee;
use ieee.std_logic_1164.all;

package iu_pac is

    -- Processor Status Register Defined
    constant IU_PSR_IMPL : std_logic_vector( 3 downto  0) := "0000";
    constant IU_PSR_VER  : std_logic_vector( 3 downto  0) := "0000";

    -- IU Instruction Instruction & Address I/F
    subtype iu_data_if is std_logic_vector(31 downto 0);
    subtype iu_addr_if is std_logic_vector(29 downto 0);

    component iu
        port (
            iu_sys_clk_in    : in    std_logic;
            iu_sys_rst_in    : in    std_logic;

            iu_inst_addr_out :   out std_logic_vector(29 downto 0);
            iu_inst_data_in  : in    iu_data_if;

            iu_data_re_out   :   out std_logic;
            iu_data_we_out   :   out std_logic;
            iu_data_dqm_out  :   out std_logic_vector( 3 downto 0);
            iu_data_addr_out :   out std_logic_vector(31 downto 0);
            iu_data_a_out    :   out std_logic;
            iu_data_di_out   :   out std_logic_vector(31 downto 0);
            iu_data_do_in    : in    std_logic_vector(31 downto 0);

            iu_intr_int_in   : in    std_logic;
            iu_intr_irl_in   : in    std_logic_vector( 3 downto 0);
            iu_intr_ack_out  :   out std_logic
        );
    end component;

end iu_pac;

-- package body iu_pac is
-- end iu_pac;
