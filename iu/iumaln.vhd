library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iu_pac.all;
use work.iuexma_pac.all;
use work.iufwu_pac.all;

use work.iumastg_pac.all;
use work.iumul32_pac.all;
use work.iuschk_pac.all;
use work.ius_pac.all;
use work.iuet_pac.all;
use work.iupil_pac.all;
use work.iumawb_pac.all;

use work.iumaln_pac.all;

entity iumaln is
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
end iumaln;

architecture rtl of iumaln is

    -- IU Multiply Unit (Post) I/F
    signal iumul32post_do_sig      : std_logic_vector(31 downto 0);

    -- IU Privileged Check I/F
    signal iuschk_rett_en_sig      : std_logic;
    signal iuschk_psr_inst_sig     : std_logic;
    signal iuschk_psr_en_sig       : std_logic;
    signal iuschk_lda_en_sig       : std_logic;
    signal iuschk_sta_en_sig       : std_logic;

    -- IU Supervisor Register I/F
    signal ius_we_sig              : std_logic;
    signal ius_di_sig              : std_logic;
    signal ius_do_sig              : std_logic;

    -- IU Enable Interrupt Register I/F
    signal iuet_we_sig             : std_logic;
    signal iuet_di_sig             : std_logic;
    signal iuet_do_sig             : std_logic;

    -- IU Proc Instruction Level Register I/F
    signal iupil_we_sig            : std_logic;
    signal iupil_di_sig            : std_logic_vector( 3 downto 0);
    signal iupil_do_sig            : std_logic_vector( 3 downto 0);

    signal iupsr_do_sig            : std_logic_vector(31 downto 0);

    -- IU MA Stage I/F
    signal iumastg_di_sig          : iu_data_if;
    signal iumastg_read_sig        : std_logic;
    signal iumastg_write_sig       : std_logic;
    signal iumastg_mem_re_sig      : std_logic;
    signal iumastg_mem_we_sig      : std_logic;
    signal iumastg_mem_dqm_sig     : std_logic_vector( 3 downto 0);
    signal iumastg_mem_addr_sig    : std_logic_vector(31 downto 0);
    signal iumastg_mem_a_sig       : std_logic;
    signal iumastg_mem_di_sig      : std_logic_vector(31 downto 0);
    signal iumastg_mem_algnchk_sig : std_logic;
    signal iumastg_do_sig          : iu_data_if;

    signal intr_algnchk_sig        : std_logic;
    signal intr_privileged_sig     : std_logic;

    signal iumaln_di_sig           : st_iumawb_if;
    signal iumaln_intr_rett_sig    : std_logic;
    signal iumaln_do_sig           : st_iumawb_if;

    signal ma_data_cs_sig          : std_logic;
    signal ma_data_sig             : std_logic_vector(31 downto 0);

    signal excep_we_sig            : std_logic;

begin

    -----------------------------------------------------------
    -- IU MA Stage                                           --
    -----------------------------------------------------------
    iumastg_di_sig    <= iupsr_do_sig when iumaln_di_in.psr_read = '1' else
                         iumaln_di_in.mem_data;

    iumastg_read_sig  <= iumaln_di_in.mem_read
                     and iuschk_rett_en_sig
                     and iuschk_lda_en_sig;

    iumastg_write_sig <= iumaln_di_in.mem_write
                     and iuschk_sta_en_sig;

    IU_MA_Stage : iumastg
    port map (
        iumastg_read_in         => iumastg_read_sig,
        iumastg_write_in        => iumastg_write_sig,
        iumastg_a_in            => iumaln_di_in.inst_a,
        iumastg_sign_in         => iumaln_di_in.mem_sign,
        iumastg_type_in         => iumaln_di_in.mem_type,
        iumastg_addr_in         => iumaln_di_in.rd_data,
        iumastg_di_in           => iumastg_di_sig,
        iumastg_mem_re_out      => iumastg_mem_re_sig,
        iumastg_mem_we_out      => iumastg_mem_we_sig,
        iumastg_mem_dqm_out     => iumastg_mem_dqm_sig,
        iumastg_mem_addr_out    => iumastg_mem_addr_sig,
        iumastg_mem_a_out       => iumastg_mem_a_sig,
        iumastg_mem_di_out      => iumastg_mem_di_sig,
        iumastg_mem_do_in       => iumaln_mem_do_in,
        iumastg_mem_algnchk_out => iumastg_mem_algnchk_sig,
        iumastg_do_out          => iumastg_do_sig
    );

    -----------------------------------------------------------
    -- IU Privileged Check                                   --
    -----------------------------------------------------------
    iuschk_psr_inst_sig <= iumaln_di_in.psr_read
                        or iumaln_di_in.s_we
                        or iumaln_di_in.et_we
                        or iumaln_di_in.pil_we;

    IU_Privileged_Check : iuschk
    port map (
        iuschk_intr_req_in => iumaln_di_in.intr_req,
        iuschk_rett_in     => iumaln_di_in.rett,
        iuschk_psr_in      => iuschk_psr_inst_sig,
        iuschk_read_in     => iumaln_di_in.mem_read,
        iuschk_write_in    => iumaln_di_in.mem_write,
        iuschk_a_in        => iumaln_di_in.inst_a,
        iuschk_s_in        => ius_do_sig,
        iuschk_rett_en_out => iuschk_rett_en_sig,
        iuschk_psr_en_out  => iuschk_psr_en_sig,
        iuschk_lda_en_out  => iuschk_lda_en_sig,
        iuschk_sta_en_out  => iuschk_sta_en_sig
    );

    -----------------------------------------------------------
    -- IU Memory I/F                                         --
    -----------------------------------------------------------
    iumaln_mem_re_out   <= iumastg_mem_re_sig;
    iumaln_mem_we_out   <= iumastg_mem_we_sig;
    iumaln_mem_dqm_out  <= iumastg_mem_dqm_sig;
    iumaln_mem_addr_out <= iumastg_mem_addr_sig;
    iumaln_mem_a_out    <= iumastg_mem_a_sig;
    iumaln_mem_di_out   <= iumastg_mem_di_sig;

    -----------------------------------------------------------
    -- IU Multiply Unit (Post)                               --
    -----------------------------------------------------------
    IU_Multiply_Unit_Post : iumul32post
    port map (

        iumul32post_hi_in   => iumaln_mul_in.hi,
        iumul32post_mul1_in => iumaln_mul_in.mul1_data,
        iumul32post_mul2_in => iumaln_mul_in.mul2_data,
        iumul32post_mul3_in => iumaln_mul_in.mul3_data,
        iumul32post_mul4_in => iumaln_mul_in.mul4_data,
        iumul32post_do_out  => iumul32post_do_sig
    );

    -----------------------------------------------------------
    -- IU Supervisor Register                                --
    -----------------------------------------------------------
    ius_we_sig <= iumaln_di_in.s_we
              and iuschk_psr_en_sig;

    ius_di_sig <= iumastg_do_sig(5) when iumaln_di_in.mem_read = '1' else
                  iumaln_di_in.rd_data(5);

    IU_Supervisor_Register : ius
    port map (
        ius_clk_in  => iumaln_clk_in,
        ius_rst_in  => iumaln_rst_in,
        ius_we_in   => ius_we_sig,
        ius_di_in   => ius_di_sig,
        ius_do_out  => ius_do_sig
    );

    -----------------------------------------------------------
    -- IU Enable Interrupt Register                          --
    -----------------------------------------------------------
    iuet_we_sig  <= iumaln_di_in.et_we
                and iuschk_psr_en_sig;

    iuet_di_sig  <= iumastg_do_sig(4) when iumaln_di_in.mem_read = '1' else
                    iumaln_di_in.rd_data(4);

    IU_Enable_Interrupt_Register : iuet
    port map (
        iuet_clk_in  => iumaln_clk_in,
        iuet_rst_in  => iumaln_rst_in,
        iuet_we_in   => iuet_we_sig,
        iuet_di_in   => iuet_di_sig,
        iuet_do_out  => iuet_do_sig
    );

    -----------------------------------------------------------
    -- IU Proc Instruction Level Register                    --
    -----------------------------------------------------------
    iupil_we_sig <= iumaln_di_in.pil_we
                and iuschk_psr_en_sig;

    iupil_di_sig <= iumastg_do_sig(3 downto 0) when iumaln_di_in.mem_read = '1' else
                    iumaln_di_in.rd_data(3 downto 0);

    IU_Proc_Intrrupt_Level_Register : iupil
    port map (
        iupil_clk_in  => iumaln_clk_in,
        iupil_rst_in  => iumaln_rst_in,
        iupil_we_in   => iupil_we_sig,
        iupil_di_in   => iupil_di_sig,
        iupil_do_out  => iupil_do_sig
    );

    iupsr_do_sig <= IU_PSR_IMPL
                  & IU_PSR_VER
                  & X"0000" & "00"
                  & ius_do_sig & iuet_do_sig & iupil_do_sig;

    -- To Interrut Control Unit
    iumaln_intr_dis_out <= (not iuet_do_sig);
                        --or iumaln_intr_rett_sig;

    iumaln_intr_pil_out <= iupil_di_sig when ((iumaln_rst_in = '0')
                                          and (iupil_we_sig  = '1')) else
                           iupil_do_sig;

    intr_algnchk_sig    <= iumastg_mem_algnchk_sig;
    intr_privileged_sig <= (not iuschk_rett_en_sig)
                        or (not iuschk_psr_en_sig)
                        or (not iuschk_lda_en_sig)
                        or (not iuschk_sta_en_sig);

    iumaln_intr_algnchk_out    <= intr_algnchk_sig;
    iumaln_intr_privileged_out <= intr_privileged_sig;

    -- iumaln_excep_we_out   <= '1' when ((iumastg_mem_algnchk_sig = '1')
    --                                 or (intr_privileged_sig     = '1')) else
    --                          '0';

    -- iumaln_excep_addr_out <= iumaln_di_in.pc when ((iumastg_mem_algnchk_sig = '1')
    --                                             or (intr_privileged_sig     = '1')) else
    --                          (others => '0');
    excep_we_sig <= iumastg_mem_algnchk_sig or intr_privileged_sig;
    iumaln_excep_we_out   <= excep_we_sig;
    iumaln_excep_addr_out <= (std_logic_vector(unsigned(iumaln_di_in.pc) + 1))
                         and (29 downto 0 => excep_we_sig);

    -- iumaln_intr_rett_sig  <= iumaln_di_in.rett when iuschk_rett_en_sig = '1' else '0';
    iumaln_intr_rett_sig  <= iumaln_di_in.rett and iuschk_rett_en_sig;
    iumaln_intr_rett_out  <= iumaln_intr_rett_sig;

    iumaln_rett_we_out    <= iumaln_intr_rett_sig;
    iumaln_rett_addr_out  <= iumaln_mem_do_in(31 downto 2) and (31 downto 2 => iumaln_intr_rett_sig);

    -----------------------------------------------------------
    -- IU MA/WB Pipeline Register                            --
    -----------------------------------------------------------
    -- To Instruction Decode Stage
    iumaln_di_sig.rd_we  <= iumaln_di_in.rd_we;
    iumaln_di_sig.rd_sel <= iumaln_di_in.rd_sel;

    ma_data_cs_sig <= iumaln_di_in.mul_cs
                   or iumaln_di_in.mem_read
                   or iumaln_di_in.psr_read
                   or iumaln_di_in.branch;

    ma_data_sig <= (iumul32post_do_sig     and (31 downto 0 => iumaln_di_in.mul_cs  ))
                or (iumastg_do_sig         and (31 downto 0 => iumaln_di_in.mem_read))
                or (iupsr_do_sig           and (31 downto 0 => iumaln_di_in.psr_read))
                or (iumaln_di_in.pc & "00" and (31 downto 0 => iumaln_di_in.branch  ));

    iumaln_di_sig.rd_data <= ma_data_sig when ma_data_cs_sig = '1' else
                             iumaln_di_in.rd_data;

    iumaln_ma_rd_out.we  <= iumaln_di_in.rd_we;
    iumaln_ma_rd_out.sel <= iumaln_di_in.rd_sel;

    IU_MAWB_Pipeline_Register : iumawb
    port map (
        iumawb_clk_in   => iumaln_clk_in,
        iumawb_rst_in   => iumaln_rst_in,
        iumawb_wen_in   => iumaln_wen_in,
        iumawb_flash_in => iumaln_flash_in,
        iumawb_di_in    => iumaln_di_sig,
        iumawb_do_out   => iumaln_do_sig
    );

    -- To Forwarding Unit
    iumaln_wb_rd_out.we   <= iumaln_do_sig.rd_we;
    iumaln_wb_rd_out.data <= iumaln_do_sig.rd_data;

    -- To Write Back Stage
    iumaln_do_out <= iumaln_do_sig;

end rtl;
