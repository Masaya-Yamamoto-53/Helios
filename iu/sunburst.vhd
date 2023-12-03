library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iu_pac.all;
use work.iuimem_pac.all;
use work.iudmem_pac.all;

use work.sramctrl_pac.all;

use work.intc_pac.all;
use work.gpo_pac.all;
use work.gpi_pac.all;
use work.segdisp_pac.all;
--use work.cmt_pac.all;
use work.uart_pac.all;
use work.spi_pac.all;
use work.rgbled_pac.all;

entity sunburst is
    port (
        h_sys_clk_in            : in    std_logic;
        --h_sys_rst_in          : in    std_logic;

        -- LED Ports
        h_sys_led_out           :   out std_logic_vector( 1 downto 0);

        -- Switch Ports
        h_sys_sw_in             : in    std_logic_vector( 1 downto 0);

        -- RGB LED Ports
        h_sys_r_led_out         :   out std_logic;
        h_sys_g_led_out         :   out std_logic;
        h_sys_b_led_out         :   out std_logic;

        -- UART Ports
        h_sys_uart_sdi_in       : in    std_logic;
        h_sys_uart_sdo_out      :   out std_logic;

        -- Segment Display Ports
        h_sys_segdisp_a_out     :   out std_logic;
        h_sys_segdisp_b_out     :   out std_logic;
        h_sys_segdisp_c_out     :   out std_logic;
        h_sys_segdisp_d_out     :   out std_logic;
        h_sys_segdisp_e_out     :   out std_logic;
        h_sys_segdisp_f_out     :   out std_logic;
        h_sys_segdisp_g1_out    :   out std_logic;
        h_sys_segdisp_g2_out    :   out std_logic;
        h_sys_segdisp_h_out     :   out std_logic;
        h_sys_segdisp_j_out     :   out std_logic;
        h_sys_segdisp_k_out     :   out std_logic;
        h_sys_segdisp_l_out     :   out std_logic;
        h_sys_segdisp_m_out     :   out std_logic;
        h_sys_segdisp_n_out     :   out std_logic;
        h_sys_segdisp_dp_out    :   out std_logic;
        h_sys_segdisp_dig1_out  :   out std_logic;
        h_sys_segdisp_dig2_out  :   out std_logic;

        -- ISSI 512K x 8 High-Speed Asynhronous CMOS Static RAM
        h_sys_ext_sram_addr_out :   out std_logic_vector(18 downto 0);
        h_sys_ext_sran_dq_inout : inout std_logic_vector( 7 downto 0);
        h_sys_ext_sram_oen_out  :   out std_logic;
        h_sys_ext_sram_wen_out  :   out std_logic;
        h_sys_ext_sram_cen_out  :   out std_logic
        
        --pio45                   :   out std_logic;
        --pio46                   :   out std_logic;
        --pio47                   :   out std_logic;
        --pio48                   :   out std_logic

        --h_sys_spi_csn_out    :   out std_logic;
        --h_sys_spi_clk_out    :   out std_logic;
        --h_sys_spi_sdi_in     : in    std_logic;
        --h_sys_spi_sdo_out    :   out std_logic
    );
end sunburst;

architecture rtl of sunburst is
    signal reset_cnt_reg  : std_logic_vector( 3 downto 0) := (others => '0');

    signal h_sys_clk_reg  : std_logic_vector( 1 downto 0) := (others => '0');
    signal h_sys_clk_sig  : std_logic := '0';
    signal h_sys_rst_sig  : std_logic;

    signal intc_irq_sig   : std_logic_vector(15 downto 0);
    signal h_intr_int_sig : std_logic;
    signal h_intr_irl_sig : std_logic_vector( 3 downto 0);
    signal h_intr_ack_sig : std_logic;


    signal h_inst_addr_sig : std_logic_vector(29 downto 0);
    signal h_inst_data_sig : iu_data_if;

    signal iuimem_data_sig : std_logic_vector(31 downto 0);

    signal h_data_re_sig   : std_logic;
    signal h_data_we_sig   : std_logic;
    signal h_data_dqm_sig  : std_logic_vector( 3 downto 0);
    signal h_data_addr_sig : std_logic_vector(31 downto 0);
    signal h_data_a_sig    : std_logic;
    signal h_data_di_sig   : std_logic_vector(31 downto 0);
    signal h_data_do_sig   : std_logic_vector(31 downto 0);

    signal rgbled_cs_sig   : std_logic;
    signal rgbled_do_sig   : std_logic_vector(7 downto 0);

    signal uart_cs_sig     : std_logic;
    signal uart_ti_sig     : std_logic;
    signal uart_rxi_sig    : std_logic;
    signal uart_eri_sig    : std_logic;
    signal uart_tei_sig    : std_logic;

    signal uart_do_sig     : std_logic_vector( 7 downto 0);

    signal ph_seg_cs_sig          : std_logic;
    signal segdisp_do_sig      : std_logic_vector(15 downto 0);
    signal segdisp_seg_do_sig  : std_logic_vector(14 downto 0);
    signal segdisp_seg_sel_sig : std_logic_vector( 1 downto 0);

    signal spi_cs_sig      : std_logic;
    signal spi_do_sig      : std_logic_vector( 7 downto 0);
    signal h_sys_spi_sdi_in: std_logic;

    signal uart_sdo_sig   : std_logic;

    signal dram_cs_sig       : std_logic;

    signal sram_cs_sig        : std_logic;
    signal sramctrl_sys_do_sig : std_logic_vector(31 downto 0);
    signal sramctrl_di_sig     : std_logic_vector( 7 downto 0);
    signal sramctrl_do_sig     : std_logic_vector( 7 downto 0);

    signal intc_cs_sig    : std_logic;
    signal gpo_cs_sig     : std_logic;
    signal gpi_cs_sig     : std_logic;

    signal iudmem_do_sig     : std_logic_vector(31 downto 0);
    signal gpo_do_sig     : std_logic_vector( 1 downto 0);
    signal gpi_di_sig     : std_logic_vector( 1 downto 0);
    signal gpi_do_sig     : std_logic_vector( 1 downto 0);
    signal intc_do_sig    : std_logic_vector(15 downto 0);
    --signal cmt_do_sig      : std_logic_vector(15 downto 0);

begin

    h_sys_clk_sig <= h_sys_clk_in;

    --h_sys_rst_sig <= h_sys_rst_in; -- Exist Reset Signal
    -- Not exist Reset Signal
    IU_ResetGenerator : process (
        h_sys_clk_in,
        reset_cnt_reg
    )
    begin
        if (h_sys_clk_in'event and h_sys_clk_in = '1') then
            if (reset_cnt_reg /= "1111") then
                reset_cnt_reg <= std_logic_vector(unsigned(reset_cnt_reg) + 1);
            end if;
        end if;

        if (reset_cnt_reg = "1111") then
            h_sys_rst_sig <= '0';
        else
            h_sys_rst_sig <= '1';
        end if;
    end process IU_ResetGenerator;

    IU_HeliosIII : iu
    port map (
        iu_sys_clk_in    => h_sys_clk_sig,
        iu_sys_rst_in    => h_sys_rst_sig,

        iu_inst_addr_out => h_inst_addr_sig,
        iu_inst_data_in  => h_inst_data_sig,

        iu_data_re_out   => h_data_re_sig,
        iu_data_we_out   => h_data_we_sig,
        iu_data_dqm_out  => h_data_dqm_sig,
        iu_data_addr_out => h_data_addr_sig,
        --iu_data_a_out    => open,
        iu_data_di_out   => h_data_di_sig,
        iu_data_do_in    => h_data_do_sig,

        iu_intr_int_in   => h_intr_int_sig,
        iu_intr_irl_in   => h_intr_irl_sig,
        iu_intr_ack_out  => h_intr_ack_sig
    );

    IU_Instruction_Memory : iuimem
    port map (
        iuimem_addr_in => h_inst_addr_sig( 8 downto 0),
        iuimem_do_out  => iuimem_data_sig
    );

    h_inst_data_sig <= iuimem_data_sig;

    -- Memory Map
    -- 0000 0000 --   1KB: Block RAM (1KB)
    -- 0000 03FF --
    -- FFF0 0000 -- 512KB: ISSI High-Speed Asynchronous CMOS Static RAM (512KB)
    -- FFF7 FFFF --

    -- FFFF F000 -- Interrupt Controller

    -- FFFF F100 -- Global Purpose Output

    -- FFFF F200 -- Global Purpose Input

    -- FFFF F300 -- Segment Display: SDMR: Segment Display Mode Register
    -- FFFF F304 --                : SDCR: Segment Display Compare Register
    -- FFFF F308 --                : SDDR: Segment Display Data Register

    -- FFFF F400 -- UART           : SCSMR: Serial Mode Register
    -- FFFF F404 --                : SCBRR: Serial Control Register
    -- FFFF F408 --                : SCSCR: Serial Status Register
    -- FFFF F412 --                : SCTDR: Serial Transmit Data Register
    -- FFFF F416 --                : SCSSR: Serial Status Register
    -- FFFF F420 --                : SCRDR: Serial Receive Data Register

    -- FFFF F500 -- SPI

    -- FFFF F600 -- RGB LED Driver

                      -- 0000 0000 0000 0000 0000 0011 1111 1111
    dram_cs_sig <=    '1' when ((h_data_addr_sig(31 downto 10) = X"0000" & X"0" & "00")
                           and ((h_data_re_sig = '1')
                             or (h_data_we_sig = '1'))) else
                      '0';

                      -- 1111 1111 1111 0111 1111 1111 1111 1111
    sram_cs_sig   <=  '1' when ((h_data_addr_sig(31 downto 19) = X"FFF" & "0")
                           and ((h_data_re_sig = '1')
                             or (h_data_we_sig = '1'))) else
                      '0';

    intc_cs_sig   <=  '1' when ((h_data_addr_sig(31 downto  8) = X"FFFF" & X"F0")
                           and ((h_data_re_sig = '1')
                             or (h_data_we_sig = '1'))) else
                      '0';

    gpo_cs_sig    <=  '1' when ((h_data_addr_sig(31 downto  8) = X"FFFF" & X"F1")
                           and ((h_data_re_sig = '1')
                             or (h_data_we_sig = '1'))) else
                      '0';

    gpi_cs_sig    <=  '1' when ((h_data_addr_sig(31 downto  8) = X"FFFF" & X"F2")
                           and ((h_data_re_sig = '1')
                             or (h_data_we_sig = '1'))) else
                      '0';

    ph_seg_cs_sig <=  '1' when ((h_data_addr_sig(31 downto  8) = X"FFFF" & X"F3")
                           and ((h_data_re_sig = '1')
                             or (h_data_we_sig = '1'))) else
                      '0';

    uart_cs_sig   <=  '1' when ((h_data_addr_sig(31 downto  8) = X"FFFF" & X"F4")
                           and ((h_data_re_sig = '1')
                             or (h_data_we_sig = '1'))) else
                      '0';

    spi_cs_sig    <=  '1' when ((h_data_addr_sig(31 downto  8) = X"FFFF" & X"F5")
                           and ((h_data_re_sig = '1')
                             or (h_data_we_sig = '1'))) else
                      '0';

    rgbled_cs_sig  <= '1' when ((h_data_addr_sig(31 downto  8) = X"FFFF" & X"F6")
                           and ((h_data_re_sig = '1')
                             or (h_data_we_sig = '1'))) else
                      '0';

    h_data_do_sig <= X"0000000" & "00" & gpo_do_sig when gpo_cs_sig    = '1' and h_data_re_sig = '1' else
                     X"0000000" & "00" & gpi_do_sig when gpi_cs_sig    = '1' and h_data_re_sig = '1' else
                     X"000000"  & uart_do_sig       when uart_cs_sig   = '1' and h_data_re_sig = '1' else
                     X"000000"  & spi_do_sig        when spi_cs_sig    = '1' and h_data_re_sig = '1' else
                     X"0000"    & segdisp_do_sig    when ph_seg_cs_sig = '1' and h_data_re_sig = '1' else
                     sramctrl_sys_do_sig            when sram_cs_sig   = '1' and h_data_re_sig = '1' else
                     X"000000"  & rgbled_do_sig     when rgbled_cs_sig = '1' and h_data_re_sig = '1' else
                     iudmem_do_sig;

    IU_Data_Memory : iudmem
    port map (
        iudmem_cs_in   => dram_cs_sig,
        iudmem_clk_in  => h_sys_clk_sig,
        iudmem_we_in   => h_data_we_sig,
        iudmem_dqm_in  => h_data_dqm_sig,
        iudmem_addr_in => h_data_addr_sig( 9 downto 2),
        iudmem_di_in   => h_data_di_sig,
        iudmem_do_out  => iudmem_do_sig
    );

    sramctrl_di_sig <= h_sys_ext_sran_dq_inout;
    h_sys_ext_sran_dq_inout <= sramctrl_do_sig when sram_cs_sig = '1' and h_data_we_sig = '1' else
                               (others => 'Z');

    PH_SRAM_1 : sramctrl
    port map (
        sramctrl_sys_cs_in   => sram_cs_sig,
        sramctrl_sys_clk_in  => h_sys_clk_sig,
        sramctrl_sys_we_in   => h_data_we_sig,
        sramctrl_sys_addr_in => h_data_addr_sig(18 downto 0),
        sramctrl_sys_di_in   => h_data_di_sig,
        sramctrl_sys_di_out  => sramctrl_sys_do_sig,

        sramctrl_wen_out     => h_sys_ext_sram_wen_out,
        sramctrl_cen_out     => h_sys_ext_sram_cen_out,
        sramctrl_oen_out     => h_sys_ext_sram_oen_out,

        sramctrl_di_in       => sramctrl_di_sig,
        sramctrl_addr_out    => h_sys_ext_sram_addr_out,
        sramctrl_do_out      => sramctrl_do_sig
    );

    intc_irq_sig( 0) <= '0';
    intc_irq_sig( 1) <= '0';
    intc_irq_sig( 2) <= '0';
    intc_irq_sig( 3) <= '0';
    intc_irq_sig( 4) <= '0';
    intc_irq_sig( 5) <= '0';
    intc_irq_sig( 6) <= '0';
    intc_irq_sig( 7) <= uart_ti_sig;  -- Transmit Data Empty Interrupt
    intc_irq_sig( 8) <= uart_rxi_sig; -- Receive Data Full Interrupt
    intc_irq_sig( 9) <= uart_eri_sig; -- Receive Error Interrupt
    intc_irq_sig(10) <= uart_tei_sig; -- Transmit End Interrupt
    intc_irq_sig(11) <= '0';
    intc_irq_sig(12) <= '0';
    intc_irq_sig(13) <= '0';
    --intc_irq_sig(14) <= cmt_cmi_sig;
    intc_irq_sig(14) <= '0';
    intc_irq_sig(15) <= '0';

    IU_Interrupt_Controller : intc
    port map (
        intc_clk_in  => h_sys_clk_sig,
        intc_rst_in  => h_sys_rst_sig,
        intc_inta_in => h_intr_ack_sig,
        intc_irq_in  => intc_irq_sig,
        intc_int_out => h_intr_int_sig,
        intc_irl_out => h_intr_irl_sig,

        intc_cs_in   => intc_cs_sig,
        intc_we_in   => h_data_we_sig,
        intc_addr_in => h_data_addr_sig( 3 downto 2),
        intc_di_in   => h_data_di_sig(15 downto 0),
        intc_do_out  => intc_do_sig
    );

    -- I/O Device
    PH_GPIO_0 : gpo
    generic map (
        WIDTH => 2
    )
    port map (
        gpo_cs_in   => gpo_cs_sig,
        gpo_clk_in  => h_sys_clk_sig,
        gpo_rst_in  => h_sys_rst_sig,
        gpo_we_in   => h_data_we_sig,
        gpo_di_in   => h_data_di_sig( 1 downto 0),
        gpo_do_out  => gpo_do_sig
    );

    h_sys_led_out <= gpo_do_sig;

    gpi_di_sig <= h_sys_sw_in;

    PH_GPIO_1 : gpi
    generic map (
        WIDTH => 2
    )
    port map (
        gpi_clk_in  => h_sys_clk_sig,
        gpi_rst_in  => h_sys_rst_sig,
        gpi_di_in   => gpi_di_sig,
        gpi_do_out  => gpi_do_sig
    );

    PH_Segment_Display_1 : segdisp
    port map (
        segdisp_cs_in       => ph_seg_cs_sig,
        segdisp_clk_in      => h_sys_clk_sig,
        segdisp_rst_in      => h_sys_rst_sig,
        segdisp_we_in       => h_data_we_sig,
        segdisp_addr_in     => h_data_addr_sig(3 downto 2),
        segdisp_di_in       => h_data_di_sig(15 downto 0),
        segdisp_do_out      => segdisp_do_sig,
        segdisp_seg_do_out  => segdisp_seg_do_sig,
        segdisp_seg_sel_out => segdisp_seg_sel_sig
    );

    h_sys_segdisp_a_out  <= segdisp_seg_do_sig(14);
    h_sys_segdisp_b_out  <= segdisp_seg_do_sig(13);
    h_sys_segdisp_c_out  <= segdisp_seg_do_sig(12);
    h_sys_segdisp_d_out  <= segdisp_seg_do_sig(11);
    h_sys_segdisp_e_out  <= segdisp_seg_do_sig(10);
    h_sys_segdisp_f_out  <= segdisp_seg_do_sig( 9);
    h_sys_segdisp_g1_out <= segdisp_seg_do_sig( 8);
    h_sys_segdisp_g2_out <= segdisp_seg_do_sig( 7);
    h_sys_segdisp_h_out  <= segdisp_seg_do_sig( 6);
    h_sys_segdisp_j_out  <= segdisp_seg_do_sig( 5);
    h_sys_segdisp_k_out  <= segdisp_seg_do_sig( 4);
    h_sys_segdisp_l_out  <= segdisp_seg_do_sig( 3);
    h_sys_segdisp_m_out  <= segdisp_seg_do_sig( 2);
    h_sys_segdisp_n_out  <= segdisp_seg_do_sig( 1);
    h_sys_segdisp_dp_out <= segdisp_seg_do_sig( 0);

    h_sys_segdisp_dig1_out <= segdisp_seg_sel_sig(1);
    h_sys_segdisp_dig2_out <= segdisp_seg_sel_sig(0);

    RGB_LED_Driver : rgbled
    generic map (
        -- PWM Resolution
        C_GEN_PW_EXP => 8
    )
    port map (
        rgbled_cs_in   => rgbled_cs_sig,
        rgbled_clk_in  => h_sys_clk_sig,
        rgbled_rst_in  => h_sys_rst_sig,

        rgbled_we_in   => h_data_we_sig,
        rgbled_addr_in => h_data_addr_sig(3 downto 2),
        rgbled_di_in   => h_data_di_sig(7 downto 0),
        rgbled_do_out  => rgbled_do_sig,

        rgbled_r_out   => h_sys_r_led_out,
        rgbled_g_out   => h_sys_g_led_out,
        rgbled_b_out   => h_sys_b_led_out
    );

    h_sys_uart_sdo_out <= uart_sdo_sig;

    -- Universal Asynchronous Receiver/Transmitter
    PH_UART_0 : uart
    port map (
        uart_cs_in   => uart_cs_sig,
        uart_clk_in  => h_sys_clk_sig,
        uart_rst_in  => h_sys_rst_sig,
        uart_sdi_in  => h_sys_uart_sdi_in,
        uart_sdo_out => uart_sdo_sig,
        uart_we_in   => h_data_we_sig,
        uart_addr_in => h_data_addr_sig( 5 downto 2),
        uart_di_in   => h_data_di_sig( 7 downto 0),
        uart_do_out  => uart_do_sig,
        uart_ti_out  => uart_ti_sig,
        uart_rxi_out => uart_rxi_sig , -- Receive Data Full Interrupt
        uart_eri_out => uart_eri_sig , -- Receive Error Interrupt
        uart_tei_out => uart_tei_sig   -- Transmit End Interrupt
    );

    PH_SPI : spi
    port map (
        spi_cs_in   => spi_cs_sig,
        spi_clk_in  => h_sys_clk_sig,
        spi_rst_in  => h_sys_rst_sig,

        spi_we_in   => h_data_we_sig,
        spi_addr_in => h_data_addr_sig( 5 downto 2),
        spi_di_in   => h_data_di_sig(7 downto 0),
        spi_do_out  => spi_do_sig,

        spi_ti_out  => open,
        spi_rxi_out => open,
        spi_tei_out => open,

        spi_csn_out => open, --h_sys_spi_csn_out,
        spi_clk_out => open, --h_sys_spi_clk_out,
        spi_sdi_in  => h_sys_spi_sdi_in,
        spi_sdo_out => open  --h_sys_spi_sdo_out
    );

end rtl;
