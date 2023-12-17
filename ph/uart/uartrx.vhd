library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.uart_pac.all;

entity uartrx is
    port (
        uartrx_re_in     : in    std_logic;
        uartrx_clk_in    : in    std_logic;
        uartrx_rst_in    : in    std_logic;
        uartrx_dis_in    : in    std_logic;
        uartrx_bclk_in   : in    std_logic;
        uartrx_chr_in    : in    std_logic;
        uartrx_pe_in     : in    std_logic;
        uartrx_pm_in     : in    std_logic;
        uartrx_stop_in   : in    std_logic;
        uartrx_sdi_in    : in    std_logic;

        uartrx_orer_out  :   out std_logic;
        uartrx_fer_out   :   out std_logic;
        uartrx_per_out   :   out std_logic;

        uartrx_rdrf_in   : in    std_logic;
        uartrx_rdrf_out  :   out std_logic;

        uartrx_rx_end_out :   out std_logic;
        uartrx_rsr_out    :   out std_logic_vector( 7 downto 0)
    );
end uartrx;

architecture rtl of uartrx is

    signal clk16_stat_reg  : std_logic_vector(7 downto 0);
    signal clk16_trg_reg   : std_logic;

    signal cntnum_sig      : std_logic_vector(3 downto 0);

    signal rx_req_reg      : std_logic;
    signal rx_start_reg    : std_logic;
    signal rx_end_reg      : std_logic;
    signal rx_suspend_reg  : std_logic;
    signal rx_cnt_reg      : std_logic_vector(3 downto 0);

    signal next_stop_reg   : std_logic;
    signal parity_reg      : std_logic;
    signal parity_chk_reg  : std_logic;

    signal rsr_reg        : std_logic_vector(7 downto 0); -- Receive Shift Register
    signal orer_reg        : std_logic;
    signal fer_reg         : std_logic;
    signal per_reg         : std_logic;
    signal rdrf_reg        : std_logic;

begin

    UART_RX_Start_Detect : process (
        uartrx_re_in,
        uartrx_clk_in,
        uartrx_rst_in,
        uartrx_dis_in,
        uartrx_sdi_in,
        rx_suspend_reg,
        rx_end_reg,
        rx_req_reg
    )
    begin
        if (uartrx_clk_in'event and uartrx_clk_in = '1') then
            if ((uartrx_rst_in  = '1')
             or (uartrx_re_in   = '0')
             or (uartrx_dis_in  = '1')
             or (rx_suspend_reg = '1')
             or (rx_end_reg     = '1')) then
                rx_req_reg <= '0';
            else
                if (uartrx_sdi_in = UART_START_BIT) then
                    rx_req_reg <= '1';
                end if;
            end if;
        end if;
    end process;

    process (
        uartrx_clk_in,
        uartrx_rst_in,
        uartrx_dis_in,
        uartrx_bclk_in,
        rx_suspend_reg,
        rx_end_reg,
        rx_req_reg
    )
    begin
        if (uartrx_clk_in'event and uartrx_clk_in = '1') then
            if ((uartrx_rst_in = '1')
             or (uartrx_dis_in = '1')
             or (rx_suspend_reg = '1')
             or (rx_end_reg     = '1')) then
                clk16_trg_reg  <= '0';
                clk16_stat_reg <= (others => '0');
            else
                if ((rx_req_reg     = '1')
                and (uartrx_bclk_in = '1')) then
                    case clk16_stat_reg is
                        when "00000000" => clk16_trg_reg <= '0'; clk16_stat_reg <= "00000001";
                        when "00000001" => clk16_trg_reg <= '0'; clk16_stat_reg <= "00000011";
                        when "00000011" => clk16_trg_reg <= '0'; clk16_stat_reg <= "00000111";
                        when "00000111" => clk16_trg_reg <= '0'; clk16_stat_reg <= "00001111";
                        when "00001111" => clk16_trg_reg <= '0'; clk16_stat_reg <= "00011111";
                        when "00011111" => clk16_trg_reg <= '0'; clk16_stat_reg <= "00111111";
                        when "00111111" => clk16_trg_reg <= '1'; clk16_stat_reg <= "01111111";
                        when "01111111" => clk16_trg_reg <= '0'; clk16_stat_reg <= "11111111";
                        when "11111111" => clk16_trg_reg <= '0'; clk16_stat_reg <= "11111110";
                        when "11111110" => clk16_trg_reg <= '0'; clk16_stat_reg <= "11111100";
                        when "11111100" => clk16_trg_reg <= '0'; clk16_stat_reg <= "11111000";
                        when "11111000" => clk16_trg_reg <= '0'; clk16_stat_reg <= "11110000";
                        when "11110000" => clk16_trg_reg <= '0'; clk16_stat_reg <= "11100000";
                        when "11100000" => clk16_trg_reg <= '0'; clk16_stat_reg <= "11000000";
                        when "11000000" => clk16_trg_reg <= '0'; clk16_stat_reg <= "10000000";
                        when "10000000" => clk16_trg_reg <= '0'; clk16_stat_reg <= "00000000";
                        when others     => clk16_trg_reg <= '0'; clk16_stat_reg <= "00000000";
                    end case;
                else
                    clk16_trg_reg  <= '0';
                    clk16_stat_reg <= clk16_stat_reg;
                end if;
            end if;
        end if;
    end process;

    process (
        uartrx_clk_in,
        uartrx_rst_in,
        uartrx_dis_in,
        uartrx_sdi_in,
        rx_suspend_reg,
        rx_end_reg,
        rx_start_reg
    )
    begin
        if (uartrx_clk_in'event and uartrx_clk_in = '1') then
            if ((uartrx_rst_in = '1')
             or (uartrx_dis_in = '1')
             or (rx_suspend_reg = '1')
             or (rx_end_reg     = '1')) then
                rx_start_reg   <= '0';
                rx_suspend_reg <= '0';
            else
                if (clk16_trg_reg = '1') then
                    if (uartrx_sdi_in = '0') then
                        rx_start_reg   <= '1';
                        rx_suspend_reg <= rx_suspend_reg;
                    else
                        rx_start_reg   <= rx_start_reg;
                        if (rx_start_reg = '0') then
                            rx_suspend_reg <= '1';
                        else
                            rx_suspend_reg <= rx_suspend_reg;
                        end if;
                    end if;
                else
                    rx_start_reg   <= rx_start_reg;
                    rx_suspend_reg <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Character Length 0: 8bits
    --                  1: 7bits
    cntnum_sig <= "1000" when uartrx_chr_in = '0' else
                  "0111";

    process (
        uartrx_clk_in,
        uartrx_rst_in,
        uartrx_pm_in,
        uartrx_sdi_in,
        rx_end_reg,
        rx_start_reg,
        clk16_trg_reg,
        rsr_reg,
        parity_reg,
        parity_chk_reg,
        cntnum_sig
    )
    begin
        if (uartrx_clk_in'event and uartrx_clk_in = '1') then
            if ((uartrx_rst_in = '1')
             or (rx_end_reg    = '1')) then
                rsr_reg       <= (others => '0');
                rx_cnt_reg     <= (others => '0');
                rx_end_reg     <= '0';
                next_stop_reg  <= '0';
                fer_reg        <= '0';
                per_reg        <= '0';
                parity_reg     <= '0';
                parity_chk_reg <= '0';
            else
                if ((rx_start_reg = '1')
                and (clk16_trg_reg    = '1')) then
                   if (rx_cnt_reg = cntnum_sig) then
                        if ((uartrx_pe_in   = '1')    -- Parity Enable
                        and (parity_chk_reg = '0')) then -- Parity Check
                            parity_chk_reg <= '1';
                            if (uartrx_pm_in  = '0') then -- Even Parity
                                if (uartrx_sdi_in /= parity_reg) then
                                    rx_end_reg    <= '1';
                                    per_reg       <= '1';
                                end if;
                            else                          -- Odo  Parity
                                if (uartrx_sdi_in  = parity_reg) then
                                    rx_end_reg    <= '1';
                                    per_reg       <= '1';
                                end if;
                            end if;
                        else
                            if (uartrx_sdi_in = '1') then -- stop bit 1
                                if (uartrx_stop_in = '0') then
                                    rx_end_reg    <= '1';
                                else
                                    next_stop_reg <= '1';
                                end if;

                                if (next_stop_reg = '1') then
                                    rx_end_reg    <= '1';
                                end if;
                            else
                                if (uartrx_stop_in = '0') then
                                    rx_end_reg    <= '1';
                                    fer_reg       <= '1';
                                end if;

                                if (next_stop_reg = '1') then
                                    rx_end_reg    <= '1';
                                    fer_reg       <= '1';
                                end if;
                            end if;
                        end if;
                    else
                        if (uartrx_pe_in = '1') then -- Parity Enable
                            parity_reg <= parity_reg xor uartrx_sdi_in;
                        end if;
                        rsr_reg (7) <= uartrx_sdi_in;
                        rsr_reg (6 downto 0) <= rsr_reg (7 downto 1);
                        rx_cnt_reg <= std_logic_vector(unsigned(rx_cnt_reg) + 1);
                    end if;
                end if;
            end if;
        end if;
    end process;

    process (
        uartrx_clk_in,
        uartrx_rst_in,
        uartrx_sdi_in,
        uartrx_chr_in,
        rx_end_reg
    )
    begin
        if (uartrx_clk_in'event and uartrx_clk_in = '1') then
            if (uartrx_rst_in = '1') then
                rdrf_reg <= '0';
                orer_reg <= '0';
            else
                if (rx_end_reg = '1') then
                    rdrf_reg <= '1';
                else
                    rdrf_reg <= '0';
                end if;

                -- over flow error
                if (rx_end_reg = '1') then
                    -- receive data register full?
                    if (uartrx_rdrf_in = '1') then
                        orer_reg <= '1';
                    else
                        orer_reg <= orer_reg;
                    end if;
                else
                    orer_reg <= '0';
                end if;
            end if;
        end if;
    end process;

    uartrx_rsr_out    <= rsr_reg;
    uartrx_orer_out   <= orer_reg;
    uartrx_fer_out    <= fer_reg;
    uartrx_per_out    <= per_reg;

    uartrx_rx_end_out <= rx_end_reg;
    uartrx_rdrf_out   <= rdrf_reg;

end rtl;
