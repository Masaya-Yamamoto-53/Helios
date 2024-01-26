--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU(Interger Unit)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package iu_pac is

    -- Processor Status Register Defined
    -- IMPL=0001: Digilent Cmod A7 (Xilinx Artix-7 FPGA Module)
    --  VER=0011: Helios-III is 32bit 5-Stage Pipeline RISC Machine.
    constant IU_PSR_IMPL : std_logic_vector( 3 downto  0) := "0001";
    constant IU_PSR_VER  : std_logic_vector( 3 downto  0) := "0011";

    -- Data Memory Size
    -- Memory Size = 32-bit x IU_DATA_MEM_SIZE
    constant IU_DATA_MEM_SIZE : integer := 255;

    -- IU Instruction Instruction & Address I/F
    subtype iu_data_if is std_logic_vector(31 downto 0);
    subtype iu_addr_if is std_logic_vector(29 downto 0);

    component iu
        port (
            iu_sys_clk_in    : in    std_logic;
            iu_sys_rst_in    : in    std_logic;

            iu_inst_addr_out :   out std_logic_vector(29 downto 0);
            iu_inst_data_in  : in    std_logic_vector(31 downto 0);

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
