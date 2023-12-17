library ieee;
use ieee.std_logic_1164.all;

use work.uartcks_pac.all;
use work.uartbg_pac.all;
use work.uartan_pac.all;

use work.uarttx_pac.all;
use work.uartrx_pac.all;

use work.uartsmr_pac.all;
use work.uartbrr_pac.all;
use work.uartscr_pac.all;
use work.uarttdr_pac.all;
use work.uartrdr_pac.all;
use work.uartssr_pac.all;

use work.uart_pac.all;

entity uart is
    port (
        uart_cs_in   : in    std_logic;
        uart_clk_in  : in    std_logic;
        uart_rst_in  : in    std_logic;

        uart_sdi_in  : in    std_logic;
        uart_sdo_out :   out std_logic;

        uart_we_in   : in    std_logic;
        uart_addr_in : in    std_logic_vector( 3 downto 0);
        uart_di_in   : in    std_logic_vector( 7 downto 0);
        uart_do_out  :   out std_logic_vector( 7 downto 0);

        uart_ti_out  :   out std_logic;
        uart_rxi_out :   out std_logic;
        uart_eri_out :   out std_logic;
        uart_tei_out :   out std_logic
    );
end uart;

architecture rtl of uart is


    signal smr_do_sig : std_logic_vector(7 downto 0); -- Serial Mode Register
    signal brr_do_sig : std_logic_vector(7 downto 0); -- Bit Rate Register
    signal scr_do_sig : std_logic_vector(7 downto 0); -- Serial Control Register
    signal tdr_do_sig : std_logic_vector(7 downto 0); -- Transmit Data Register
    signal ssr_do_sig : std_logic_vector(7 downto 0); -- Serial Status Register
    signal rdr_do_sig : std_logic_vector(7 downto 0); -- Receive Data Register

    -- Clock Selector Signal
    signal uartcks_en_sig  : std_logic;
    signal uartcks_clk_sig : std_logic;

    -- Baud Rate Generator Signal
    signal uartbg_en_sig   : std_logic;
    signal uartbg_clk_sig  : std_logic;
    signal uartan_sdi_sig  : std_logic;

    -- Transmitter Signal
    signal uarttx_tend_sig : std_logic;
    signal uarttx_tei_sig  : std_logic;

    -- Receiver Signal
    signal uartrx_dis_sig    : std_logic;
    signal uartrx_rdrf_sig   : std_logic;
    signal uartrx_orer_sig   : std_logic;
    signal uartrx_fer_sig    : std_logic;
    signal uartrx_per_sig    : std_logic;
    signal uartrx_rx_end_sig : std_logic;
    signal uartrx_rsr_sig    : std_logic_vector(7 downto 0); -- Receive Shift Register

    -- Serial Mode Register    (SMR)
    signal smr_sig : st_uartsmr_if;

    -- Serial Control Register (SCR)
    signal scr_sig : st_uartscr_if;

    -- Serial Status Register  (SSR)
    signal ssr_sig : st_uartssr_if;

    -- Serial Data Bus
    signal do_sig  : std_logic_vector(7 downto 0);

begin

    -----------------------------------------------------------
    -- Clock Selector                                        --
    -----------------------------------------------------------
    uartcks_en_sig <= scr_sig.te_reg  -- Serial Control Register (SCR) bit5: Transmit Enable
                   or scr_sig.re_reg; --                               bit4:  Receive Enable

    UART_Clock_Selector : uartcks
    port map (
        uartcks_en_in   => uartcks_en_sig,
        uartcks_clk_in  => uart_clk_in,     -- External Clock (P:System Clock)
        uartcks_rst_in  => uart_rst_in,
        uartcks_cks_in  => smr_sig.cks_reg, -- Serial Mode Register (SMR)
                                            --     bit1, 0: Clock Select
                                            --              (00: PΦ, 01: PΦ/4, 10: PΦ/16, 11: PΦ/64)
        uartcks_clk_out => uartcks_clk_sig  -- Internal Clock
    );

    -----------------------------------------------------------
    -- Boud Rate Generator                                   --
    -----------------------------------------------------------
    uartbg_en_sig  <= scr_sig.te_reg  -- Serial Control Register (SCR) bit5: Transmit Enable
                   or scr_sig.re_reg; --                               bit4:  Receive Enable

    UART_Baud_Rate_Generator : uartbg
    port map (
        uartbg_en_in   => uartbg_en_sig,
        uartbg_clk_in  => uartcks_clk_sig,
        uartbg_rst_in  => uart_rst_in,
        uartbg_scbr_in => brr_do_sig,      -- Bit Rate Register (SCBRR)
        uartbg_clk_out => uartbg_clk_sig   -- Boud Rate
    );

    -----------------------------------------------------------
    -- Anti Noize                                            --
    -----------------------------------------------------------
    UART_Anti_Noize : uartan
    port map (
        uartan_clk_in  => uartcks_clk_sig,
        uartan_rst_in  => uart_rst_in,
        uartan_sdi_in  => uart_sdi_in,
        uartan_sdi_out => uartan_sdi_sig
    );

    -----------------------------------------------------------
    -- Transmitter                                           --
    -----------------------------------------------------------
    UART_Transmitter : uarttx
    port map (
        uarttx_cs_in    => uart_cs_in,
        uarttx_te_in    => scr_sig.te_reg,
        uarttx_clk_in   => uart_clk_in,
        uarttx_rst_in   => uart_rst_in,
        uarttx_we_in    => uart_we_in,
        uarttx_addr_in  => uart_addr_in,
        uarttx_di_in    => uart_di_in,
        uarttx_bclk_in  => uartbg_clk_sig,   -- Boud Rate
        uarttx_chr_in   => smr_sig.chr_reg,  -- SMR bit6: Character Length
        uarttx_pe_in    => smr_sig.pe_reg,   -- SMR bit5: Parity Enable
        uarttx_pm_in    => smr_sig.pm_reg,   -- SMR bit4: Parity Mode
        uarttx_stop_in  => smr_sig.stop_reg, -- SMR bit3: Stop Bit
        uarttx_tdr_in   => tdr_do_sig,
        uarttx_tend_out => uarttx_tend_sig,
        uarttx_tei_out  => uarttx_tei_sig,
        uarttx_sdo_out  => uart_sdo_out
    );

    -----------------------------------------------------------
    -- Receiver                                              --
    -----------------------------------------------------------
    -- Receive Disable Signal
    uartrx_dis_sig <= ssr_sig.orer_reg -- Serial Status Register (SSR) bit5: Overrun Error
                   or ssr_sig.fer_reg  --                              bit4: Framing Error
                   or ssr_sig.per_reg; --                              bit3: Parity  Error

    UART_Receiver : uartrx
    port map (
        uartrx_re_in      => scr_sig.re_reg,    -- SCR bit4: Receive Enable
        uartrx_clk_in     => uart_clk_in,
        uartrx_rst_in     => uart_rst_in,
        uartrx_dis_in     => uartrx_dis_sig,    -- Receive Disable Signal
        uartrx_bclk_in    => uartbg_clk_sig,    -- Boud Rate
        uartrx_chr_in     => smr_sig.chr_reg,   -- SMR bit6: Character Length
        uartrx_pe_in      => smr_sig.pe_reg,    -- SMR bit5: Parity Enable
        uartrx_pm_in      => smr_sig.pm_reg,    -- SMR bit4: Parity Mode
        uartrx_stop_in    => smr_sig.stop_reg,  -- SMR bit3: Stop Bit
        uartrx_sdi_in     => uartan_sdi_sig,    -- Serial Data input (anti noise)
        uartrx_orer_out   => uartrx_orer_sig,   -- Overrun Error Signal
        uartrx_fer_out    => uartrx_fer_sig,    -- Framing Error Signal
        uartrx_per_out    => uartrx_per_sig,    -- Parity Error Signal
        uartrx_rdrf_in    => ssr_sig.rdrf_reg,  -- SSR bit6: Receive Data Register Full
        uartrx_rdrf_out   => uartrx_rdrf_sig,   -- Receive Data Signal
        uartrx_rx_end_out => uartrx_rx_end_sig, 
        uartrx_rsr_out    => uartrx_rsr_sig     -- Receive Data Register Signal
    );

    -----------------------------------------------------------
    -- Serial Mode Register (SMR)                            --
    -----------------------------------------------------------
    UART_Serial_Mode_Register : uartsmr
    port map (
        uartsmr_cs_in   => uart_cs_in,
        uartsmr_clk_in  => uart_clk_in,
        uartsmr_rst_in  => uart_rst_in,

        uartsmr_we_in   => uart_we_in,
        uartsmr_addr_in => uart_addr_in,
        uartsmr_di_in   => uart_di_in,
        uartsmr_do_out  => smr_sig
    );

    smr_do_sig <= "0"              -- bit7  : Reserved
                & smr_sig.chr_reg  -- bit6  : Character Length
                & smr_sig.pe_reg   -- bit5  : Parity Enable
                & smr_sig.pm_reg   -- bit4  : Parity Mode
                & smr_sig.stop_reg -- bit3  : Stop Bit
                & "0"              -- bit2  : Reserved
                & smr_sig.cks_reg; -- bit1,0: Clock Select

    -----------------------------------------------------------
    -- Bit Rate Register (BRR)                               --
    -----------------------------------------------------------
    UART_Serial_Bit_Rate_Register : uartbrr
    port map (
        uartbrr_cs_in   => uart_cs_in,
        uartbrr_clk_in  => uart_clk_in,
        uartbrr_rst_in  => uart_rst_in,

        uartbrr_we_in   => uart_we_in,
        uartbrr_addr_in => uart_addr_in,
        uartbrr_di_in   => uart_di_in,
        uartbrr_do_out  => brr_do_sig
    );

    -----------------------------------------------------------
    -- Serial Control Register (SCR)                         --
    -----------------------------------------------------------
    UART_Serial_Control_Register : uartscr
    port map (
        uartscr_cs_in   => uart_cs_in,
        uartscr_clk_in  => uart_clk_in,
        uartscr_rst_in  => uart_rst_in,
   
        uartscr_we_in   => uart_we_in,
        uartscr_addr_in => uart_addr_in,
        uartscr_di_in   => uart_di_in,
        uartscr_do_out  => scr_sig
    );

    scr_do_sig <= scr_sig.tie_reg  -- bit7 : Transmit Interrupt Enable
                & scr_sig.rie_reg  -- bit6 : Receive Interrupt Enable
                & scr_sig.te_reg   -- bit5 : Transmit Enable
                & scr_sig.re_reg   -- bit4 : Receive Enable
                & '0'              -- bit3 : Reserved
                & scr_sig.teie_reg -- bit2 : Transmit End Interrupt Enable
                & '0'              -- bit1 : Reserved
                & '0';             -- bit0 : Reserved

    -----------------------------------------------------------
    -- Transmit Data Register (TDR)                          --
    -----------------------------------------------------------
    UART_Transmit_Data_Register : uarttdr
    port map (
            uarttdr_cs_in   => uart_cs_in,
            uarttdr_clk_in  => uart_clk_in,
            uarttdr_rst_in  => uart_rst_in,

            uarttdr_te_in   => scr_sig.te_reg,

            uarttdr_we_in   => uart_we_in,
            uarttdr_addr_in => uart_addr_in,
            uarttdr_di_in   => uart_di_in,
            uarttdr_do_out  => tdr_do_sig
    );

    -----------------------------------------------------------
    -- Serial Status Register (SSR)                          --
    -----------------------------------------------------------
    UART_Serial_Status_Register :  uartssr
    port map (
        uartssr_cs_in   => uart_cs_in,
        uartssr_clk_in  => uart_clk_in,
        uartssr_rst_in  => uart_rst_in,

        uartssr_tei_in  => uarttx_tei_sig,
        uartssr_rdrf_in => uartrx_rdrf_sig,

        uartssr_orer_in => uartrx_orer_sig,
        uartssr_fer_in  => uartrx_fer_sig,
        uartssr_per_in  => uartrx_per_sig,

        uartssr_tend_in => uarttx_tend_sig,

        uartssr_we_in   => uart_we_in,
        uartssr_addr_in => uart_addr_in,
        uartssr_di_in   => uart_di_in,
        uartssr_do_out  => ssr_sig
    );

    ssr_do_sig <= ssr_sig.tdre_reg -- bit7  : Transmit Data Empty
                & ssr_sig.rdrf_reg -- bit6  : Receive Data Register Full
                & ssr_sig.orer_reg -- bit5  : Overrun Error
                & ssr_sig.fer_reg  -- bit4  : Framing Error
                & ssr_sig.per_reg  -- bit3  : Parity  Error
                & ssr_sig.tend_reg -- bit2  : Transmit End
                & "00";            -- bit1,0: Reserved

    -----------------------------------------------------------
    -- Receive Data Register (RDR)                           --
    -----------------------------------------------------------
    UART_Receive_Data_Register : uartrdr
    port map(
        uartrdr_cs_in     => uart_cs_in,
        uartrdr_clk_in    => uart_clk_in,
        uartrdr_rst_in    => uart_rst_in,

        uartrdr_chr_in    => smr_sig.chr_reg,  -- SMR bit6: Character Length
        uartrdr_rx_end_in => uartrx_rx_end_sig, 

        uartrdr_di_in     => uartrx_rsr_sig,   -- Receive Data Register Signal
        uartrdr_do_out    => rdr_do_sig
    );

    with uart_addr_in select
    do_sig  <= smr_do_sig      when UART_ADDR_SMR, -- Serial Mode Register
               brr_do_sig      when UART_ADDR_BRR, -- Bit Rate Register
               scr_do_sig      when UART_ADDR_SCR, -- Serial Control Register
               tdr_do_sig      when UART_ADDR_TDR, -- Transmit Data Register
               ssr_do_sig      when UART_ADDR_SSR, -- Serial Status Register
               rdr_do_sig      when UART_ADDR_RDR, -- Receive Data Register
               (others => '0') when others;

    uart_do_out  <= do_sig           and (7 downto 0 => uart_cs_in);
    uart_ti_out  <= ssr_sig.tdre_reg and scr_sig.tie_reg;  -- Transmit Data Empty Interrupt
    uart_rxi_out <= ssr_sig.rdrf_reg and scr_sig.rie_reg;  -- Receive Data Full Interrupt
    uart_eri_out <= uartrx_dis_sig   and scr_sig.rie_reg;  -- Receive Error Interrupt
    uart_tei_out <= ssr_sig.tend_reg and scr_sig.teie_reg; -- Transmit End Interrupt

end rtl;
