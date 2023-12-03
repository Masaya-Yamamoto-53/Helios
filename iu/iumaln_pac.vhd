library ieee;
use ieee.std_logic_1164.all;

use work.iu_pac.all;
use work.iuexma_pac.all;
use work.iumawb_pac.all;
use work.iufwu_pac.all;
use work.iumul32_pac.all;

package iumaln_pac is

    component iumaln
        port (
            iumaln_clk_in              : in    std_logic;
            iumaln_rst_in              : in    std_logic;
            iumaln_wen_in              : in    std_logic;
            iumaln_flash_in            : in    std_logic;
            iumaln_di_in               : in    st_iuexma_if;

            iumaln_mul_in              : in    st_iumul32_if;

            iumaln_ma_rd_out           :   out st_iufwpre_if;

            iumaln_intr_dis_out        :   out std_logic;
            iumaln_intr_pil_out        :   out std_logic_vector( 3 downto 0);

            iumaln_intr_privileged_out :   out std_logic;
            iumaln_intr_algnchk_out    :   out std_logic;
            iumaln_intr_rett_out       :   out std_logic;

            iumaln_mem_re_out          :   out std_logic;
            iumaln_mem_we_out          :   out std_logic;
            iumaln_mem_dqm_out         :   out std_logic_vector( 3 downto 0);
            iumaln_mem_addr_out        :   out std_logic_vector(31 downto 0);
            iumaln_mem_a_out           :   out std_logic;
            iumaln_mem_di_out          :   out std_logic_vector(31 downto 0);
            iumaln_mem_do_in           : in    std_logic_vector(31 downto 0);

            iumaln_excep_we_out        :   out std_logic;
            iumaln_excep_addr_out      :   out std_logic_vector(29 downto 0);

            iumaln_rett_we_out         :   out std_logic;
            iumaln_rett_addr_out       :   out std_logic_vector(29 downto 0);

            iumaln_wb_rd_out           :   out st_iufwpast_if;
            iumaln_do_out              :   out st_iumawb_if
        );
    end component;

end iumaln_pac;

-- package body iumaln_pac is
-- end iumaln_pac;
