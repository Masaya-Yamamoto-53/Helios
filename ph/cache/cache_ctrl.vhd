library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.cache_pac.all;

entity cache_ctrl is
    port (
        ctrl_clk_in       : in    std_logic;
        ctrl_rstn_in      : in    std_logic;

        ctrl_req_in       : in    std_logic;

        ctrl_addr_in      : in    std_logic_vector (31 downto 0);
        ctrl_tag_data_in  : in    std_logic_vector (C_TAG_BIT-1 downto 0);

        ctrl_hit_in       : in    std_logic;
        ctrl_fill_in      : in    std_logic;

        ctrl_read_rdy     : in    std_logic;
        ctrl_write_rdy    : in    std_logic;

        ctrl_mem_ack_in   : in    std_logic;
        ctrl_mem_req_out  :   out std_logic;

        ctrl_addr_out     :   out std_logic_vector (31 downto 0);
        ctrl_tag_data_out :   out std_logic_vector (C_TAG_BIT-1 downto 0);
        ctrl_v_out        :   out std_logic;
        ctrl_wrn_out      :   out std_logic;
        ctrl_tag_wrn_out  :   out std_logic
    );
end cache_ctrl;

architecture RTL of cache_ctrl is

signal cache_addr_sig : std_logic_vector (31 downto 0);

begin

    ctrl_addr_out <= cache_addr_sig;

    cache_ctrl : process (
        ctrl_clk_in,
        ctrl_rstn_in
    )

    variable cache_load_state : std_logic_vector (2 downto 0);
    constant CACHE_IDLE       : std_logic_vector (2 downto 0) := "000";
    constant CACHE_CYCLE1     : std_logic_vector (2 downto 0) := "001";
    constant CACHE_CYCLE2     : std_logic_vector (2 downto 0) := "010";
    constant CACHE_CYCLE3     : std_logic_vector (2 downto 0) := "011";
    constant CACHE_WAIT       : std_logic_vector (2 downto 0) := "100";
    constant CACHE_ADDR_INC   : std_logic_vector (2 downto 0) := "101";

    begin
        if (ctrl_rstn_in = '0') then
            cache_addr_sig   <= (others => '0');
            ctrl_mem_req_out <= '0';
            ctrl_wrn_out     <= '0';
            ctrl_tag_wrn_out <= '0';
            cache_load_state := CACHE_IDLE;
        elsif (ctrl_clk_in'event and ctrl_clk_in = '1') then
            if (ctrl_hit_in = '0') then
                case cache_load_state is
                when CACHE_IDLE =>
                    if (ctrl_req_in = '1') then
                        if (ctrl_fill_in = '1') then
                            cache_addr_sig (C_TAG_MSB downto C_TAG_LSB) <= ctrl_addr_in (C_TAG_MSB downto C_TAG_LSB);
                        else
                            cache_addr_sig (C_TAG_MSB downto C_TAG_LSB) <= ctrl_tag_data_in;
                        end if;
                        cache_addr_sig (C_LINE_MSB downto C_LINE_LSB)   <= ctrl_addr_in (C_LINE_MSB downto C_LINE_LSB);
                        cache_addr_sig (C_DATA_MSB downto          0)   <= (others => '0');
                        ctrl_tag_wrn_out <= '0';
                        cache_load_state := CACHE_CYCLE1;
                    end if;
                when CACHE_CYCLE1 =>
                    ctrl_mem_req_out <= '1';
                    ctrl_wrn_out     <= '0';
                    ctrl_tag_wrn_out <= '0';
                    cache_load_state := CACHE_CYCLE2;
                when CACHE_CYCLE2 =>
                    ctrl_mem_req_out <= '0';
                    if ((ctrl_read_rdy  = '1')
                     or (ctrl_write_rdy = '1')) then
                        if (ctrl_fill_in = '1') then
                            ctrl_wrn_out <= '1';
                        else
                            ctrl_wrn_out <= '0';
                        end if;

                        if (cache_addr_sig (C_DATA_MSB downto C_DATA_LSB) /= "111") then
                            cache_addr_sig (C_DATA_MSB downto C_DATA_LSB) <= cache_addr_sig (C_DATA_MSB downto C_DATA_LSB) + '1';
                        else
                            cache_load_state := CACHE_CYCLE3;
                        end if;
                    end if;
                when CACHE_CYCLE3 =>
                    if (ctrl_fill_in = '1') then
                        ctrl_v_out <= '1';
                        ctrl_tag_data_out <= ctrl_addr_in (C_TAG_MSB downto C_TAG_LSB);
                    else
                        ctrl_v_out <= '0';
                        ctrl_tag_data_out <= (others => '0');
                    end if;
                    ctrl_wrn_out <= '0';
                    ctrl_tag_wrn_out <= '1';
                    cache_load_state := CACHE_WAIT;
                when CACHE_WAIT =>
                    ctrl_v_out <= '0';
                    ctrl_tag_data_out <= (others => '0');
                    ctrl_wrn_out     <= '0';
                    ctrl_tag_wrn_out <= '0';
                    cache_load_state := CACHE_IDLE;
                when CACHE_ADDR_INC =>
                    cache_addr_sig (C_DATA_MSB downto C_DATA_LSB) <= cache_addr_sig (C_DATA_MSB downto C_DATA_LSB) + '1';
                    ctrl_mem_req_out <= '1';
                    ctrl_wrn_out     <= '0';
                    ctrl_tag_wrn_out <= '0';
                    cache_load_state := CACHE_CYCLE2;
                when others =>
                    cache_load_state := CACHE_IDLE;
                end case;
            end if;
        end if;
    end process cache_ctrl;

end RTL;
