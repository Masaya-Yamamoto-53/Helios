library ieee;
use ieee.std_logic_1164.all;

use work.spicks_pac.all;
use work.spibg_pac.all;
use work.spitxrx_pac.all;

use work.spi_pac.all;

entity spi is
    port (
        spi_cs_in   : in    std_logic;
        spi_clk_in  : in    std_logic;
        spi_rst_in  : in    std_logic;

        spi_we_in   : in    std_logic;
        spi_addr_in : in    std_logic_vector( 3 downto 0);
        spi_di_in   : in    std_logic_vector( 7 downto 0);
        spi_do_out  :   out std_logic_vector( 7 downto 0);

        spi_ti_out  :   out std_logic;
        spi_rxi_out :   out std_logic;
        spi_tei_out :   out std_logic;

        spi_csn_out :   out std_logic;
        spi_clk_out :   out std_logic;
        spi_sdi_in  : in    std_logic;
        spi_sdo_out :   out std_logic
    );
end spi;

architecture rtl of spi is

    signal scsm_sig : std_logic_vector(7 downto 0); -- Serial Mode Register
    signal scbr_sig : std_logic_vector(7 downto 0); -- Bit Rate Register
    signal scsc_sig : std_logic_vector(7 downto 0); -- Serial Control Register
    signal sctd_sig : std_logic_vector(7 downto 0); -- Transmit Data Register
    signal scss_sig : std_logic_vector(7 downto 0); -- Serial Status Register
    signal scrd_sig : std_logic_vector(7 downto 0); -- Receive Data Register

    -----------------------------------------------------------
    -- Bit Rate Register (SCBRR)                             --
    -----------------------------------------------------------
    signal scbr_reg : std_logic_vector(7 downto 0);

    -----------------------------------------------------------
    -- Serial Mode Register (SCSMR)                          --
    -----------------------------------------------------------
                                                   -- bit7  : Reserved
                                                   -- bit6  : Reserved
                                                   -- bit5  : Reserved
                                                   -- bit4  : Reserved
    signal ckp_reg : std_logic;                    -- bit3  : CKP
    signal cke_reg : std_logic;                    -- bit2  : CKE
    signal cks_reg : std_logic_vector(1 downto 0); -- bit1,0: CKS

    -----------------------------------------------------------
    -- Serial Control Register (SCSCR)                       --
    -----------------------------------------------------------
    signal tie_reg  : std_logic; -- bit7  : Transmit Interrupt Enable
    signal rie_reg  : std_logic; -- bit6  : Receive Interrupt Enable
    signal en_reg   : std_logic; -- bit5  : Transmit Enable
    signal re_reg   : std_logic; -- bit4  : Reserved
                                 -- bit3  : Reserved
    signal teie_reg : std_logic; -- bit2  : Transmit End Interrupt Enable
                                 -- bit1,0: Reserved

    -----------------------------------------------------------
    -- Serial Status Register (SCSSR)                        --
    -----------------------------------------------------------
    signal tdre_reg    : std_logic; -- bit7  : Transmit Data Empty
    signal tdre_we_reg : std_logic; --         TDRE Write Enable
    signal rdrf_reg    : std_logic; -- bit6  : Receive Data Register Full
    signal rdrf_we_reg : std_logic; --         RDRF Write Enable
    signal orer_reg    : std_logic; -- bit5  : Reserved
                                    -- bit4  : Reserved
                                    -- bit3  : Reserved
    signal tend_reg    : std_logic; -- bit2  : Transmit End
                                    -- bit1,0: Reserved

    -- Clock Selector Signal
    signal spicks_cs_sig   : std_logic;
    signal spicks_clk_sig  : std_logic;

    -- Baud Rate Generator Signal
    signal spibg_cs_sig    : std_logic;
    signal spibg_clk_sig   : std_logic;

    -- Transmitter Signal
    signal spitx_tend_sig  : std_logic;
    signal spitx_tei_sig   : std_logic;

    -- Receiver Signal
    signal spirx_rdrf_sig  : std_logic;

    -- SPI Register Data Output Signal
    signal do_sig          : std_logic_vector(7 downto 0);

begin

    SPI_Clock_Selector : spicks
    port map (
        spicks_cs_in   => en_reg,
        spicks_clk_in  => spi_clk_in,
        spicks_bclk_in => spibg_clk_sig,
        spicks_rst_in  => spi_rst_in,
        spicks_cks_in  => cks_reg,
        spicks_clk_out => spicks_clk_sig
    );

    SPI_Baud_Rate_Generator : spibg
    port map (
        spibg_cs_in   => en_reg,
        spibg_clk_in  => spicks_clk_sig,
        spibg_rst_in  => spi_rst_in,
        spibg_scbr_in => scbr_sig,
        spibg_clk_out => spibg_clk_sig
    );

    SPI_Transmitter_and_Reveiver : spitxrx
    port map (
        spitxrx_cs_in    => spi_cs_in,
        spitxrx_en_in    => en_reg,
        spitxrx_clk_in   => spi_clk_in,
        spitxrx_rst_in   => spi_rst_in,

        spitxrx_we_in    => spi_we_in,
        spitxrx_addr_in  => spi_addr_in,
        spitxrx_di_in    => spi_di_in,

        spitxrx_bclk_in  => spibg_clk_sig,
        spitxrx_ckp_in   => ckp_reg,
        spitxrx_cke_in   => cke_reg,

        spitxrx_tend_out => spitx_tend_sig,
        spitxrx_tei_out  => spitx_tei_sig,

        spitxrx_sctd_out => sctd_sig,
        spitxrx_scrd_out => scrd_sig,
        spitxrx_rdrf_out => spirx_rdrf_sig,

        spitxrx_csn_out  => spi_csn_out,
        spitxrx_clk_out  => spi_clk_out,
        spitxrx_sdi_in   => spi_sdi_in,
        spitxrx_sdo_out  => spi_sdo_out
    );

    ----------------------------------------
    -- Serial Mode Register (SCSMR)       --
    ----------------------------------------
    scsm_sig <= "0"
              & '0'
              & '0'
              & "0"
              & ckp_reg
              & cke_reg
              & cks_reg;

    Serial_Mode_Register : process (
        spi_cs_in,
        spi_clk_in,
        spi_rst_in,
        spi_addr_in,
        spi_we_in
    )
    begin
        if (spi_clk_in'event and spi_clk_in = '1') then
            if (spi_rst_in = '1') then
                ckp_reg  <= '0';
                cke_reg  <= '0';
                cks_reg  <= (others => '0');
            else
                if ((spi_cs_in   = '1'          )
                and (spi_addr_in = SPI_ADDR_SCSM)
                and (spi_we_in   = '1'          )) then
                    ckp_reg  <= spi_di_in(3);
                    cke_reg  <= spi_di_in(2);
                    cks_reg  <= spi_di_in(1 downto 0);
                end if;
            end if;
        end if;
    end process Serial_Mode_Register;

    ----------------------------------------
    -- Bit Rate Register (SCBRR)          --
    ----------------------------------------
    scbr_sig <= scbr_reg;

    Bit_Rate_Register : process (
        spi_cs_in,
        spi_clk_in,
        spi_rst_in,
        spi_addr_in,
        spi_di_in
    )
    begin
        if (spi_clk_in'event and spi_clk_in = '1') then
            if (spi_rst_in = '1') then
                scbr_reg <= (others => '0');
            else
                if ((spi_cs_in   = '1'          )
                and (spi_addr_in = SPI_ADDR_SCBR)
                and (spi_we_in   = '1'          )) then
                    scbr_reg <= spi_di_in;
                end if;
            end if;
        end if;
    end process Bit_Rate_Register;

    ----------------------------------------
    -- Serial Control Register (SCSCR)    --
    ----------------------------------------
    scsc_sig <= tie_reg
              & rie_reg
              & en_reg
              & '0'
              & '0'
              & teie_reg
              & "00";

    Serial_Control_Register : process (
        spi_cs_in,
        spi_clk_in,
        spi_rst_in,
        spi_addr_in,
        spi_we_in
    )
    begin
        if (spi_clk_in'event and spi_clk_in = '1') then
            if (spi_rst_in = '1') then
                tie_reg  <= '0';
                rie_reg  <= '0';
                en_reg   <= '0';
                teie_reg <= '0';
            else
                if ((spi_cs_in   = '1'          )
                and (spi_addr_in = SPI_ADDR_SCSC)
                and (spi_we_in   = '1'          )) then
                    tie_reg  <= spi_di_in(7); -- bit7  : Transmit Interrupt Enable
                    rie_reg  <= spi_di_in(6); -- bit6  : Receive Interrupt Enable
                    en_reg   <= spi_di_in(5); -- bit5  : Transmit Enable
                    teie_reg <= spi_di_in(2); -- bit2  : Transmit End Interrupt Enable
                end if;
            end if;
        end if;
    end process Serial_Control_Register;

    ----------------------------------------
    -- Serial Status Register (SCSSR)     --
    ----------------------------------------
    scss_sig <= tdre_reg
              & rdrf_reg
              & '0'
              & '0'
              & '0'
              & tend_reg
              & "00";

    Serial_Status_Register : process (
        spi_cs_in,
        spi_clk_in,
        spi_rst_in,
        spi_we_in,
        spi_addr_in,
        spi_di_in
    )
    begin
        if (spi_clk_in'event and spi_clk_in = '1') then
            if (spi_rst_in = '1') then
                tdre_reg    <= '0';
                tdre_we_reg <= '0';
                rdrf_reg    <= '0';
                rdrf_we_reg <= '0';
                tend_reg    <= '0';
            else
                -- bit7 : Transmit Data Empty
                if     (spitx_tei_sig = '1')  then
                    tdre_reg    <= '1';
                    tdre_we_reg <= '0';
                elsif ((spi_cs_in   = '1'          )
                   and (spi_addr_in = SPI_ADDR_SCSS)
                   and (spi_we_in   = '0'          )) then
                   if (tdre_reg = '1') then
                        tdre_we_reg <= '1';
                    else
                        tdre_we_reg <= '0';
                    end if;
                elsif ((spi_cs_in   = '1'          )
                   and (spi_addr_in = SPI_ADDR_SCSS)
                   and (spi_we_in   = '1'          )
                   and (tdre_we_reg = '1'         )) then
                    tdre_reg    <= spi_di_in(7);
                    tdre_we_reg <= '0';
                end if;

                -- bit6: RDRF : Receive Data Register Full
                if     (spirx_rdrf_sig = '1')  then
                    rdrf_reg    <= spirx_rdrf_sig;
                    rdrf_we_reg <= '0';
                elsif ((spi_cs_in   = '1'          )
                   and (spi_addr_in = SPI_ADDR_SCSS)
                   and (spi_we_in   = '0'          )) then
                    if (rdrf_reg = '1') then
                        rdrf_we_reg <= '1';
                    else
                        rdrf_we_reg <= '0';
                    end if;
                elsif ((spi_cs_in   = '1'          )
                   and (spi_addr_in = SPI_ADDR_SCSS)
                   and (spi_we_in   = '1'          )
                   and (rdrf_we_reg = '1'          )) then
                    rdrf_reg    <= spi_di_in(6);
                    rdrf_we_reg <= '0';
                end if;

                -- bit2: TEND : Transmit End
                -- TEND is Read Only Register
                if    (spitx_tend_sig = '1')  then
                    tend_reg    <= spitx_tend_sig;
                elsif ((spi_cs_in     = '1'          )
                   and (spi_addr_in   = SPI_ADDR_SCSS)
                   and (spi_we_in     = '1'          )) then
                    tend_reg <= spi_di_in(7);
                end if;
            end if;
        end if;
    end process Serial_Status_Register;

    do_sig  <= scsm_sig when spi_addr_in = SPI_ADDR_SCSM else -- Serial Mode Register
               scbr_sig when spi_addr_in = SPI_ADDR_SCBR else -- Bit Rate Register
               scsc_sig when spi_addr_in = SPI_ADDR_SCSC else -- Serial Control Register
               sctd_sig when spi_addr_in = SPI_ADDR_SCTD else -- Transmit Data Register
               scss_sig when spi_addr_in = SPI_ADDR_SCSS else -- Serial Status Register
               scrd_sig when spi_addr_in = SPI_ADDR_SCRD else -- Receive Data Register
               (others => '0');

    spi_do_out  <= do_sig   and (7 downto 0 => spi_cs_in);
    spi_ti_out  <= tdre_reg and tie_reg;  -- Transmit Data Empty Interrupt
    spi_rxi_out <= rdrf_reg and rie_reg;  -- Receive Data Full Interrupt
    spi_tei_out <= tend_reg and teie_reg; -- Transmit End Interrupt

end rtl;
