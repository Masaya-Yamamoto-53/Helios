library ieee;
use ieee.std_logic_1164.all;

use work.iu_pac.all;
use work.iuifid_pac.all;

package iuifln_pac is

    component iuifln
        port (
            iuifln_clk_in           : in    std_logic;
            iuifln_rst_in           : in    std_logic;

            iuifln_inst_addr_out    :   out std_logic_vector(29 downto 0);
            iuifln_inst_data_in     : in    iu_data_if;

            iuifln_excep_ex_we_in   : in    std_logic;
            iuifln_excep_ex_addr_in : in    std_logic_vector(29 downto 0);
            iuifln_excep_ma_we_in   : in    std_logic;
            iuifln_excep_ma_addr_in : in    std_logic_vector(29 downto 0);

            iuifln_intr_req_in      : in    std_logic;
            iuifln_intr_inst_in     : in    std_logic_vector(31 downto 0);
            iuifln_intr_vec_we_in   : in    std_logic;
            iuifln_intr_vec_addr_in : in    std_logic_vector(29 downto 0);

            iuifln_bprc_we_in       : in    std_logic;
            iuifln_bprc_addr_in     : in    std_logic_vector(29 downto 0);

            iuifln_pc_wen_in        : in    std_logic;

            iuifln_wen_in           : in    std_logic;
            iuifln_flash_in         : in    std_logic;

            iuifln_rett_out         :   out std_logic;

            iuifln_do_out           :   out st_iuifid_if
        );
    end component;

end iuifln_pac;

-- package body iuifln_pac is
-- end iuifln_pac;
