library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spi_pac.all;

entity spitxrx is
    port (
        spitxrx_cs_in    : in    std_logic;
        spitxrx_en_in    : in    std_logic;
        spitxrx_clk_in   : in    std_logic;
        spitxrx_rst_in   : in    std_logic;

        spitxrx_we_in    : in    std_logic;
        spitxrx_addr_in  : in    std_logic_vector (3 downto 0);
        spitxrx_di_in    : in    std_logic_vector (7 downto 0);

        spitxrx_bclk_in  : in    std_logic;
        spitxrx_ckp_in   : in    std_logic;
        spitxrx_cke_in   : in    std_logic;

        spitxrx_tend_out :   out std_logic;
        spitxrx_tei_out  :   out std_logic;

        spitxrx_sctd_out :   out std_logic_vector (7 downto 0);
        spitxrx_scrd_out :   out std_logic_vector (7 downto 0);
        spitxrx_rdrf_out :   out std_logic;

        spitxrx_csn_out  :   out std_logic;
        spitxrx_clk_out  :   out std_logic;
        spitxrx_sdi_in   : in    std_logic;
        spitxrx_sdo_out  :   out std_logic
    );
end spitxrx;

architecture rtl of spitxrx is

    signal bclk_reg    : std_logic := '0';
    signal bclk_trg_sig   : std_logic := '0';

    signal clk16_hold_reg : std_logic;
    signal clk16_cnt_reg   : std_logic_vector(3 downto 0);
    signal clk16_trg_reg       : std_logic;

    signal req_reg      : std_logic;
    signal tx_start_reg    : std_logic;
    signal rx_start_reg : std_logic;

    signal txrx_cnt_reg      : std_logic_vector(3 downto 0);

    signal sctd_reg        : std_logic_vector(7 downto 0);
    signal scts_reg        : std_logic_vector(7 downto 0);

    signal scrs_reg        : std_logic_vector(7 downto 0);
    signal scrd_reg        : std_logic_vector(7 downto 0);

    signal tend_reg        : std_logic;
    signal tei_reg         : std_logic;

    signal rdrf_reg        : std_logic;

    signal spi_clk_reg     : std_logic;

    signal txrx_csn_reg    : std_logic;
    signal txrx_clk_sig    : std_logic;
    signal txrx_clk_reg    : std_logic;
    signal txrx_sdo_reg    : std_logic;

begin

    process (
        spitxrx_clk_in,
        spitxrx_cs_in,
        spitxrx_we_in,
        spitxrx_addr_in
    ) begin
        if (spitxrx_clk_in'event and spitxrx_clk_in = '1') then
            if((spitxrx_rst_in = '1')
            or (spitxrx_en_in  = '0')) then
                req_reg  <= '0';
                sctd_reg <= (others => '0');
            else
                if ((spitxrx_cs_in   = '1'          )
                and (spitxrx_we_in   = '1'          )
                and (spitxrx_addr_in = SPI_ADDR_SCTD)) then
                    req_reg  <= '1';
                    sctd_reg <= spitxrx_di_in;
                elsif (tei_reg = '1') then
                    req_reg  <= '0';
                end if;
            end if;
        end if;
    end process;

    process (
        spitxrx_clk_in,
        spitxrx_rst_in,
        spitxrx_en_in,
        spitxrx_bclk_in
    ) begin
        if (spitxrx_clk_in'event and spitxrx_clk_in = '1') then
            if((spitxrx_rst_in = '1')
            or (spitxrx_en_in  = '0')) then
                bclk_reg <= '0';
            else
                bclk_reg <= spitxrx_bclk_in;
            end if;
        end if;
    end process;

    bclk_trg_sig <= '1' when bclk_reg = '0' and spitxrx_bclk_in = '1' else '0';

    process (
        spitxrx_clk_in,
        spitxrx_rst_in,
        spitxrx_bclk_in,
        tend_reg,
        req_reg
    )
    begin
        if (spitxrx_clk_in'event and spitxrx_clk_in = '1') then
            if(spitxrx_rst_in = '1') then
                clk16_hold_reg <= '1';
            elsif (tend_reg = '1') then
                if (req_reg = '0') then
                    clk16_hold_reg <= '1';
                end if;
            else
                if (req_reg = '1') then
                    clk16_hold_reg <= '0';
                end if;
            end if;
        end if;
    end process;

    process (
        spitxrx_clk_in,
        spitxrx_rst_in,
        spitxrx_en_in
    ) begin
        if (spitxrx_clk_in'event and spitxrx_clk_in = '1') then
            if((spitxrx_rst_in = '1')
            or (spitxrx_en_in  = '0')) then
                clk16_cnt_reg <= (others => '0');
            else
                if ((clk16_hold_reg = '0')
                and (bclk_trg_sig   = '1')) then
                    clk16_cnt_reg <= std_logic_vector(unsigned(clk16_cnt_reg) + 1);
                end if;

                if (bclk_reg = '1') then
                    if (clk16_cnt_reg = "1111") then
                        clk16_trg_reg <= '1';
                    else
                        clk16_trg_reg <= '0';
                    end if;
                else
                        clk16_trg_reg <= '0';
                end if;
            end if;
        end if;
    end process;

    process (
        spitxrx_clk_in
    ) begin
        if (spitxrx_clk_in'event and spitxrx_clk_in = '1') then
            if((spitxrx_rst_in = '1')
            or (spitxrx_en_in  = '0')) then
                tx_start_reg <= '0';
            else
                if ((req_reg      = '1')
                and (tx_start_reg = '0')) then
                    tx_start_reg <= '1';
                elsif (clk16_trg_reg = '1') then
                    if (txrx_cnt_reg = "1001") then
                        tx_start_reg <= '0';
                    else
                        tx_start_reg <= tx_start_reg;
                    end if;
                else
                    tx_start_reg <= tx_start_reg;
                end if;
            end if;
        end if;
    end process;

    --PH_SPI_CSn : process (
    --    spitxrx_clk_in
    --) begin
    --    if (spitxrx_clk_in'event and spitxrx_clk_in = '1') then
    --        if((spitxrx_rst_in = '1')
    --        or (spitxrx_en_in  = '0')) then
    --            txrx_csn_reg <= '1';
    --        else
    --            if (bclk_trg_sig = '1') then
    --                if    ((txrx_cnt_reg     = "0000")
    --                   and (clk16_cnt_reg <= "1010")) then
    --                    txrx_csn_reg <= '1';
    --                elsif ((txrx_cnt_reg     = "1010")
    --                   and (clk16_cnt_reg >= "0011")) then
    --                    txrx_csn_reg <= '1';
    --                elsif (tx_start_reg    = '0'    ) then
    --                    txrx_csn_reg <= '1';
    --                else
    --                    txrx_csn_reg <= '0';
    --                end if;
    --            end if;
    --        end if;
    --    end if;
    --end process;

    txrx_clk_sig <=     spitxrx_cke_in when clk16_cnt_reg = "0111" else
                    not spitxrx_cke_in when clk16_cnt_reg = "1111" else
                        spitxrx_ckp_in;

    PH_SPI_CLK : process (
        spitxrx_clk_in,
        spitxrx_rst_in
    ) begin
        if (spitxrx_clk_in'event and spitxrx_clk_in = '1') then
            if ((spitxrx_rst_in = '1')
             or (spitxrx_en_in  = '0')
             or (tend_reg = '1'      )) then
                txrx_clk_reg <= spitxrx_ckp_in;
            else
                if (spitxrx_bclk_in = '1') then
                    if (clk16_cnt_reg = "0111") then
                        txrx_clk_reg <= spitxrx_cke_in;

                    elsif ((txrx_cnt_reg = "1001")
                       and (clk16_cnt_reg = "1111")) then
                        txrx_clk_reg <= spitxrx_ckp_in;
                    elsif (clk16_cnt_reg = "1111") then
                        txrx_clk_reg <= not spitxrx_cke_in;
                    end if;
                end if;
            end if;
        end if;
    end process;

    process (
        spitxrx_clk_in,
        spitxrx_rst_in,
        spitxrx_en_in
    ) begin
        if (spitxrx_clk_in'event and spitxrx_clk_in = '1') then
            if((spitxrx_rst_in = '1')
            or (spitxrx_en_in  = '0')) then
                tei_reg      <= '0';
                tend_reg     <= '0';
                txrx_cnt_reg   <= (others => '0');
            else
                case txrx_cnt_reg is
                when "0000" =>
                    if (tx_start_reg = '1') then
                        if (clk16_trg_reg = '1') then
                            txrx_cnt_reg <= "0001";
                        end if;
                        tei_reg  <= '0';
                        tend_reg <= '0';
                    else
                        if (req_reg   = '1') then
                            tei_reg      <= '1';
                        else
                            tei_reg      <= '0';
                        end if;
                        tend_reg   <= '0';
                        txrx_cnt_reg <= txrx_cnt_reg;
                    end if;
                when "0001" | "0010" | "0011" | "0100" | "0101" | "0110" =>
                    if (clk16_trg_reg = '1') then
                        txrx_cnt_reg   <= std_logic_vector(unsigned(txrx_cnt_reg) + 1);
                    else
                        txrx_cnt_reg   <= txrx_cnt_reg;
                    end if;
                    tei_reg    <= '0';
                    tend_reg   <= '0';
                when "0111" =>
                    if (clk16_trg_reg = '1') then
                        if (req_reg = '1') then
                            tei_reg      <= '1';
                            tend_reg     <= '0';
                            txrx_cnt_reg   <= "1000";
                        else
                            tei_reg    <= '0';
                            tend_reg   <= '0';
                            txrx_cnt_reg <= "1001";
                        end if;
                    else
                        tei_reg      <= '0';
                        tend_reg     <= '0';
                        txrx_cnt_reg   <= txrx_cnt_reg;
                    end if;
                when "1000" =>
                    if (clk16_trg_reg = '1') then
                        txrx_cnt_reg <= "0001";
                    end if;
                    tei_reg    <= '0';
                    tend_reg   <= '0';
                when "1001" =>
                    tei_reg    <= '0';
                    if (clk16_trg_reg = '1') then
                        txrx_cnt_reg <= "0000";
                        tend_reg   <= '1';
                    end if;
                when others =>
                    tei_reg      <= '0';
                    tend_reg     <= '0';
                    txrx_cnt_reg   <= "0000";
                end case;
            end if;
        end if;
    end process;

    SPI_TX_CTRL : process (
        spitxrx_clk_in,
        spitxrx_rst_in,
        spitxrx_en_in
    ) begin
        if (spitxrx_clk_in'event and spitxrx_clk_in = '1') then
            if((spitxrx_rst_in = '1')
            or (spitxrx_en_in  = '0')) then
                scts_reg     <= (others => '0');
                txrx_sdo_reg <= '0';
                rx_start_reg <= '0';
            else
                case txrx_cnt_reg is
                when "0000" =>
                    if (tx_start_reg = '1') then
                        if (clk16_trg_reg = '1') then
                            scts_reg(7 downto 1) <= scts_reg(6 downto 0);
                            txrx_sdo_reg         <= scts_reg(7);
                        end if;
                    else
                        if (req_reg   = '1') then
                            scts_reg     <= sctd_reg;
                        end if;
                    end if;
                when "0001" | "0010" | "0011" | "0100" | "0101" | "0110" =>
                    if (clk16_trg_reg = '1') then
                        scts_reg(7 downto 1) <= scts_reg(6 downto 0);
                        txrx_sdo_reg <= scts_reg(7);
                    end if;
                when "0111" =>
                    if (clk16_trg_reg = '1') then
                        if (req_reg = '1') then
                            scts_reg     <= sctd_reg;
                            txrx_sdo_reg <= scts_reg(0);
                        else
                            scts_reg(7 downto 1) <= scts_reg(6 downto 0);
                            txrx_sdo_reg         <= scts_reg(7);
                        end if;
                    end if;
                when "1000" =>
                    if (clk16_trg_reg = '1') then
                        scts_reg(7 downto 1) <= scts_reg(6 downto 0);
                        txrx_sdo_reg         <= scts_reg(7);
                    end if;
                    rx_start_reg <= '1';
                when "1001" =>
                    if (clk16_trg_reg = '1') then
                        rx_start_reg <= '0';
                    end if;
                when others =>
                end case;
            end if;
        end if;
    end process;

    PH_SPI_RX_CTRL : process (
        spitxrx_clk_in,
        spitxrx_rst_in,
        spitxrx_en_in
    )

    variable mode_sig : std_logic_vector(1 downto 0);

    begin

        mode_sig := spitxrx_ckp_in & spitxrx_cke_in;

        if (spitxrx_clk_in'event and spitxrx_clk_in = '1') then
            if ((spitxrx_rst_in = '1')
             or (spitxrx_en_in  = '0')) then
                rdrf_reg   <= '0';
                scrs_reg   <= (others => '0');
                scrd_reg   <= (others => '0');
            else
                spi_clk_reg <= txrx_clk_sig;
                if (((spi_clk_reg  = '0' )
                 and (txrx_clk_sig = '1' )
                 and ((mode_sig    = "00")
                   or (mode_sig    = "11")))

                 or ((spi_clk_reg  = '1' )
                 and (txrx_clk_sig = '0' )
                 and ((mode_sig    = "01")
                   or (mode_sig    = "10")))) then

                    if (rx_start_reg = '1') then
                        case txrx_cnt_reg is
                        when "0000" | "0001" | "0010" | "0011"
                           | "0100" | "0101" | "0110" | "0111" =>
                            rdrf_reg <= '0';
                            scrs_reg(7 downto 1) <= scrs_reg(6 downto 0);
                            scrs_reg(0)          <= spitxrx_sdi_in;
                        when "1000" =>
                            rdrf_reg             <= '1';
                            scrs_reg(7 downto 1) <= scrs_reg(6 downto 0);
                            scrs_reg(0)          <= spitxrx_sdi_in;
                            scrd_reg             <= scrs_reg;
                        when others =>
                            rdrf_reg   <= '0';
                            scrs_reg   <= (others => '0');
                            scrd_reg   <= (others => '0');
                        end case;
                    end if;
                end if;
            end if;
        end if;
    end process PH_SPI_RX_CTRL;

    spitxrx_csn_out  <= txrx_csn_reg; -- Chip Select Signal (Negative)
    spitxrx_clk_out  <= txrx_clk_reg; -- Clock Signal
    spitxrx_sdo_out  <= txrx_sdo_reg; -- Serial Data Out signal

    spitxrx_tend_out <= tend_reg; -- Transmit End Signal
    spitxrx_tei_out  <= tei_reg;  -- Transmit Data Empty Signal

    spitxrx_sctd_out <= sctd_reg; -- Transmit Data Register
    spitxrx_scrd_out <= scrd_reg; -- Receive Data Register
    spitxrx_rdrf_out <= rdrf_reg; -- Receive Data Register Full

end rtl;
