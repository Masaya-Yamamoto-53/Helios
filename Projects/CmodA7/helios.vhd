library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- IU(Integer Unit)
use work.iu_pac.all;
use work.iuimem_pac.all;
use work.iudmem_pac.all;

-- Peripherals
use work.sramctrl_pac.all;
use work.intc_pac.all;
use work.uart_pac.all;

entity helios is
    port (
        -- System Clock
        h_sys_clk_in            : in    std_logic;

        -- ISSI 512K x 8 High-Speed Asynhronous CMOS Static RAM
        h_sys_ext_sram_addr_out :   out std_logic_vector(18 downto 0);
        h_sys_ext_sran_dq_inout : inout std_logic_vector( 7 downto 0);
        h_sys_ext_sram_oen_out  :   out std_logic;
        h_sys_ext_sram_wen_out  :   out std_logic;
        h_sys_ext_sram_cen_out  :   out std_logic
    );
end helios;

architecture rtl of helios is
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

    signal dram_cs_sig       : std_logic;

    signal sram_cs_sig        : std_logic;
    signal sramctrl_sys_do_sig : std_logic_vector(31 downto 0);
    signal sramctrl_di_sig     : std_logic_vector( 7 downto 0);
    signal sramctrl_do_sig     : std_logic_vector( 7 downto 0);

    signal intc_cs_sig    : std_logic;

    signal iudmem_do_sig     : std_logic_vector(31 downto 0);
    signal intc_do_sig    : std_logic_vector(15 downto 0);

begin

    h_sys_clk_sig <= h_sys_clk_in;

    --------------------------------------------------------------------------------
    -- IU Reset Generator
    --
    -- To prevent processor malfunctions,
    -- assert the reset signal for a certain period of time.
    --------------------------------------------------------------------------------
    IU_Reset_Generator : process (
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
    end process IU_Reset_Generator;


    --------------------------------------------------------------------------------
    -- IU Helis
    --------------------------------------------------------------------------------
    IU_Helios : iu
    port map (
        iu_sys_clk_in    => h_sys_clk_sig,
        iu_sys_rst_in    => h_sys_rst_sig,

        iu_inst_addr_out => h_inst_addr_sig,
        iu_inst_data_in  => h_inst_data_sig,

        iu_data_re_out   => h_data_re_sig,
        iu_data_we_out   => h_data_we_sig,
        iu_data_dqm_out  => h_data_dqm_sig,
        iu_data_addr_out => h_data_addr_sig,
        iu_data_di_out   => h_data_di_sig,
        iu_data_do_in    => h_data_do_sig,

        iu_intr_int_in   => h_intr_int_sig,
        iu_intr_irl_in   => h_intr_irl_sig,
        iu_intr_ack_out  => h_intr_ack_sig
    );

    --------------------------------------------------------------------------------
    -- IU Instruction Memory
    --------------------------------------------------------------------------------
    IU_Instruction_Memory : iuimem
    port map (
        iuimem_addr_in => h_inst_addr_sig( 8 downto 0),
        iuimem_do_out  => iuimem_data_sig
    );

    h_inst_data_sig <= iuimem_data_sig;

    --------------------------------------------------------------------------------
    -- Memory Map
    --------------------------------------------------------------------------------
    -- 0000 0000 --   1KB: Block RAM (1KB)
    -- 0000 03FF --
    -- FFF0 0000 -- 512KB: ISSI High-Speed Asynchronous CMOS Static RAM (512KB)
    -- FFF7 FFFF --

    -- FFFF F000 -- Interrupt Controller

    -- FFFF F400 -- UART           : SCSMR: Serial Mode Register
    -- FFFF F404 --                : SCBRR: Serial Control Register
    -- FFFF F408 --                : SCSCR: Serial Status Register
    -- FFFF F412 --                : SCTDR: Serial Transmit Data Register
    -- FFFF F416 --                : SCSSR: Serial Status Register
    -- FFFF F420 --                : SCRDR: Serial Receive Data Register

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

    uart_cs_sig   <=  '1' when ((h_data_addr_sig(31 downto  8) = X"FFFF" & X"F4")
                           and ((h_data_re_sig = '1')
                             or (h_data_we_sig = '1'))) else
                      '0';


    h_data_do_sig <= X"000000"  & uart_do_sig       when uart_cs_sig   = '1' and h_data_re_sig = '1' else
                     sramctrl_sys_do_sig            when sram_cs_sig   = '1' and h_data_re_sig = '1' else
                     iudmem_do_sig;

    --------------------------------------------------------------------------------
    -- IU Data Memory
    --------------------------------------------------------------------------------
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
    h_sys_ext_sran_dq_inout <= sramctrl_do_sig when sram_cs_sig = '1' and h_data_we_sig = '1' else (others => 'Z');

    --------------------------------------------------------------------------------
    -- PH SRAM
    -- ISSI High-Speed Asynchronous CMOS Static RAM (512KB)
    --------------------------------------------------------------------------------
    PH_SRAM_0 : sramctrl
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

    --------------------------------------------------------------------------------
    -- IU Interrupt Controller
    --------------------------------------------------------------------------------
    intc_irq_sig( 0) <= '0';
    intc_irq_sig( 1) <= '0';
    intc_irq_sig( 2) <= '0';
    intc_irq_sig( 3) <= '0';
    intc_irq_sig( 4) <= '0';
    intc_irq_sig( 5) <= '0';
    intc_irq_sig( 6) <= '0';
    intc_irq_sig( 7) <= uart_ti_sig;  -- Transmit Data Empty Interrupt
    intc_irq_sig( 8) <= uart_rxi_sig; --   Receive Data Full Interrupt
    intc_irq_sig( 9) <= uart_eri_sig; --       Receive Error Interrupt
    intc_irq_sig(10) <= uart_tei_sig; --        Transmit End Interrupt
    intc_irq_sig(11) <= '0';
    intc_irq_sig(12) <= '0';
    intc_irq_sig(13) <= '0';
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

    h_sys_uart_sdo_out <= uart_sdo_sig;

    --------------------------------------------------------------------------------
    -- PH Universal Asynchronous Receiver/Transmitter
    --------------------------------------------------------------------------------
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
        uart_eri_out => uart_eri_sig , --     Receive Error Interrupt
        uart_tei_out => uart_tei_sig   --      Transmit End Interrupt
    );

end rtl;
