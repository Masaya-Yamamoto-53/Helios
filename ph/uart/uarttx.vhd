library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.uart_pac.all;

entity uarttx is
    port (
        uarttx_cs_in    : in    std_logic;
        uarttx_te_in    : in    std_logic;
        uarttx_clk_in   : in    std_logic;
        uarttx_rst_in   : in    std_logic;

        uarttx_we_in    : in    std_logic;
        uarttx_addr_in  : in    std_logic_vector(3 downto 0);
        uarttx_di_in    : in    std_logic_vector(7 downto 0);

        uarttx_bclk_in  : in    std_logic;
        uarttx_chr_in   : in    std_logic;
        uarttx_pe_in    : in    std_logic;
        uarttx_pm_in    : in    std_logic;
        uarttx_stop_in  : in    std_logic;

        uarttx_tdr_in   : in    std_logic_vector(7 downto 0);

        uarttx_tend_out :   out std_logic;
        uarttx_tei_out  :   out std_logic;
        uarttx_sdo_out  :   out std_logic
    );
end uarttx;

architecture rtl of uarttx is

    signal clk16_hold_reg : std_logic;
    signal clk16_stat_reg : std_logic_vector (7 downto 0);
    signal clk16_trg_reg  : std_logic;

    signal tx_req_reg     : std_logic;
    signal tx_start_reg   : std_logic;
    signal tx_end_reg     : std_logic;
    signal tx_cnt_reg     : std_logic_vector (3 downto 0);

    signal scts_reg       : std_logic_vector (7 downto 0);

    signal chr_sig        : std_logic_vector (3 downto 0);
    signal next_stop_reg  : std_logic;
    signal parity_reg     : std_logic;
    signal parity_chk_reg : std_logic;

    signal tend_reg       : std_logic; -- SCSS 2bit: TEND
    signal tei_reg        : std_logic; -- SCSS 7bit: TDRE
    signal sdo_reg        : std_logic; -- Serial Data Output

begin

    process (
        uarttx_te_in,
        uarttx_clk_in,
        uarttx_rst_in,
        uarttx_we_in,
        uarttx_addr_in,
        uarttx_di_in,
        tei_reg
    )
    begin
        if (uarttx_clk_in'event and uarttx_clk_in = '1') then
            if ((uarttx_rst_in = '1')        -- Transmit reset signal
             or (uarttx_te_in   = '0')) then -- Transmit disable signal
                tx_req_reg <= '0';
            else
                -- When the transmitted data is written to the transmit data register(sctd_reg),
                -- the transmission process of the UART is started.
                if ((uarttx_cs_in   = '1'          )
                and (uarttx_addr_in = UART_ADDR_TDR)
                and (uarttx_we_in   = '1'          )) then
                    tx_req_reg <= '1';          -- Transmit start request
                elsif (tei_reg = '1') then
                    tx_req_reg <= '0';          -- No transmit start request
                end if;
            end if;
        end if;
    end process;

    process (
        uarttx_clk_in,
        uarttx_rst_in,
        tend_reg,
        tx_req_reg
    )
    begin
        if (uarttx_clk_in'event and uarttx_clk_in = '1') then
            if    (uarttx_rst_in = '1') then
                clk16_hold_reg <= '1';
            elsif (tend_reg = '1') then
                -- When tere is no next transmitted data.
                if (tx_req_reg = '0') then
                    clk16_hold_reg <= '1';
                end if;
            else
                if (tx_req_reg = '1') then
                    clk16_hold_reg <= '0';
                end if;
            end if;
        end if;
    end process;

    process (
        uarttx_clk_in,
        uarttx_rst_in,
        uarttx_bclk_in,
        tend_reg,
        tx_req_reg
    )
    begin
        if (uarttx_clk_in'event and uarttx_clk_in = '1') then
            if   ((uarttx_rst_in = '1')
               or (tend_reg         = '1')) then
                clk16_trg_reg  <= '0';
                clk16_stat_reg <= (others => '0');
            else
                if ((clk16_hold_reg = '0')
                and (uarttx_bclk_in = '1')) then
                    case clk16_stat_reg is
                        when "00000000" => clk16_trg_reg <= '0'; clk16_stat_reg <= "00000001";
                        when "00000001" => clk16_trg_reg <= '0'; clk16_stat_reg <= "00000011";
                        when "00000011" => clk16_trg_reg <= '0'; clk16_stat_reg <= "00000111";
                        when "00000111" => clk16_trg_reg <= '0'; clk16_stat_reg <= "00001111";
                        when "00001111" => clk16_trg_reg <= '0'; clk16_stat_reg <= "00011111";
                        when "00011111" => clk16_trg_reg <= '0'; clk16_stat_reg <= "00111111";
                        when "00111111" => clk16_trg_reg <= '0'; clk16_stat_reg <= "01111111";
                        when "01111111" => clk16_trg_reg <= '1'; clk16_stat_reg <= "11111111";
                        when "11111111" => clk16_trg_reg <= '0'; clk16_stat_reg <= "11111110";
                        when "11111110" => clk16_trg_reg <= '0'; clk16_stat_reg <= "11111100";
                        when "11111100" => clk16_trg_reg <= '0'; clk16_stat_reg <= "11111000";
                        when "11111000" => clk16_trg_reg <= '0'; clk16_stat_reg <= "11110000";
                        when "11110000" => clk16_trg_reg <= '0'; clk16_stat_reg <= "11100000";
                        when "11100000" => clk16_trg_reg <= '0'; clk16_stat_reg <= "11000000";
                        when "11000000" => clk16_trg_reg <= '0'; clk16_stat_reg <= "10000000";
                        when "10000000" => clk16_trg_reg <= '0'; clk16_stat_reg <= "00000000";
                        when others     => clk16_trg_reg <= '0'; clk16_stat_reg <= (others => '1');
                    end case;
                else
                    clk16_trg_reg  <= '0';
                    clk16_stat_reg <= clk16_stat_reg;
                end if;
            end if;
        end if;
    end process;

    process (
        uarttx_clk_in,
        uarttx_rst_in,
        clk16_trg_reg,
        tx_start_reg,
        tx_cnt_reg,
        tend_reg
    )
    begin
        if (uarttx_clk_in'event and uarttx_clk_in = '1') then
            if ((uarttx_rst_in = '1')
             or (tend_reg = '1')) then
                tx_cnt_reg     <= (others => '0');
            else
                if (clk16_trg_reg = '1') then
                    if (tx_start_reg = '1') then
                        -- All bits have been send.
                        if (tx_cnt_reg = chr_sig) then
                            tx_cnt_reg <= tx_cnt_reg;
                        else
                            tx_cnt_reg <= std_logic_vector(unsigned(tx_cnt_reg) + 1);
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -----------------------------------------------------------
    -- Transmitter Start Register                            --
    -----------------------------------------------------------
    process (
        uarttx_clk_in,
        uarttx_rst_in,
        clk16_trg_reg,
        tx_start_reg,
        tend_reg
    )
    begin
        if (uarttx_clk_in'event and uarttx_clk_in = '1') then
            if ((uarttx_rst_in = '1')
             or (tend_reg = '1')) then
                tx_start_reg   <= '0';
                tei_reg        <= '0';
            else
                if (clk16_trg_reg = '1') then
                    -- Start sending data after stop bit transmission
                    if (tx_start_reg = '0') then
                        tx_start_reg <= '1';
                        tei_reg      <= '1';
                    end if;
                else
                    tei_reg <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Character Length 0: 8bits
    --                  1: 7bits
    chr_sig <= "1000" when uarttx_chr_in = '0' else
               "0111";

    process (
        uarttx_clk_in,
        uarttx_rst_in,
        uarttx_pe_in,
        uarttx_pm_in,
        uarttx_stop_in,
        clk16_trg_reg,
        tx_cnt_reg,
        tend_reg,
        parity_chk_reg,
        next_stop_reg
    )
    begin
        if (uarttx_clk_in'event and uarttx_clk_in = '1') then
            if ((uarttx_rst_in = '1')
             or (tend_reg = '1')) then
                sdo_reg        <= UART_STOP_BIT;
                next_stop_reg  <= '0';
                tx_end_reg     <= '0';
                tend_reg       <= '0';
                scts_reg       <= (others => '0');
                parity_reg     <= '0';
                parity_chk_reg <= '0';
            else
                if (clk16_trg_reg = '1') then
                    -- Sending start bit
                    if (tx_start_reg = '0') then
                        sdo_reg <= UART_START_BIT; -- set start bit
                        if (uarttx_chr_in = '0') then -- 8bit data length
                            scts_reg  <= uarttx_tdr_in;
                        else                          -- 7bit data length
                            scts_reg  <= '0' & uarttx_tdr_in(6 downto 0);
                        end if;
                    -- Start sending data after start bit transmission
                    else
                        -- All bits have been send.
                        if (tx_cnt_reg = chr_sig) then
                            if (tx_end_reg = '0') then
                                -- When parity bit need to be send>
                                if ((uarttx_pe_in   = '1')
                                and (parity_chk_reg = '0')) then
                                    parity_chk_reg <= '1';
                                    if (uarttx_pm_in = '0') then
                                        sdo_reg <=     parity_reg;
                                    else
                                        sdo_reg <= not parity_reg;
                                    end if;
                                -- No need to send parity bits, or after sending parity bit.
                                else
                                    if (uarttx_stop_in = '0') then -- 1 stop bit
                                        tx_end_reg    <= '1';
                                        sdo_reg       <= UART_STOP_BIT;
                                    else                           -- 2 stop bit
                                        next_stop_reg <= '1';
                                        sdo_reg       <= UART_STOP_BIT;
                                    end if;

                                    if (next_stop_reg = '1') then
                                        tx_end_reg    <= '1';
                                        sdo_reg       <= '1';
                                    end if;
                                end if;
                            else
                                tend_reg <= '1';
                            end if;
                        -- Sending data
                        else
                            scts_reg (6 downto 0) <= scts_reg (7 downto 1);
                            sdo_reg               <= scts_reg (0);

                            if (uarttx_pe_in = '1') then
                                -- Calc parity bit
                                parity_reg <= parity_reg xor scts_reg (0);
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    uarttx_tend_out <= '1' when tend_reg = '1' and tx_req_reg = '0' else '0';
    uarttx_tei_out  <= tei_reg;
    uarttx_sdo_out  <= sdo_reg;

end rtl;
