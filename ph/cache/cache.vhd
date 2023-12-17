library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.cache_pac.all;

entity cache is
    port (
        cache_clk_in       : in    std_logic;
        cache_rstn_in      : in    std_logic;

        cache_req_in       : in    std_logic;
        cache_mem_ack_in   : in    std_logic;
        cache_mem_req_out  :   out std_logic;

        cache_wrn_in       : in    std_logic;
        cache_dqmn_in      : in    std_logic_vector ( 3 downto 0);
        cache_addr_in      : in    std_logic_vector (31 downto 0);

        cache_read_in      : in    std_logic;
        cache_write_in     : in    std_logic;

        cache_data_in      : in    std_logic_vector (31 downto 0);
        cache_mem_data_in  : in    std_logic_vector (31 downto 0);

        cache_dqmn_out     :   out std_logic_vector ( 3 downto 0);
        cache_addr_out     :   out std_logic_vector (31 downto 0);
        cache_data_out     :   out std_logic_vector (31 downto 0);

        cache_hit_out      :   out std_logic;
        cache_fill_out     :   out std_logic
    );
end cache;

architecture RTL of cache is

component cache_ctrl
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
end component;
signal ctrl_mem_req_sig  : std_logic;
signal ctrl_addr_sig     : std_logic_vector (31 downto 0);
signal ctrl_tag_data_sig : std_logic_vector (C_TAG_BIT-1 downto 0);
signal ctrl_v_sig        : std_logic;
signal ctrl_wrn_sig      : std_logic;
signal ctrl_tag_wrn_sig  : std_logic;

component cache_fill
    port (
        cf_v_in     : in    std_logic;
        cf_u_in     : in    std_logic;
        cf_fill_out :   out std_logic
    );
end component;
signal cf_fill_sig : std_logic;

component cache_hit
    port (
        ch_tag_in  : in    std_logic_vector (C_TAG_BIT-1 downto 0);
        ch_addr_in : in    std_logic_vector (C_TAG_MSB downto C_TAG_LSB);
        ch_v_in    : in    std_logic;
        ch_hit_out :   out std_logic
    );
end component;
signal ch_hit_sig : std_logic;

component cache_tag
    port (
        tag_clk_in     : in    std_logic;
        tag_we_in      : in    std_logic;
        tag_addr_in    : in    TYPE_LineWidth;
        tag_data_in    : in    std_logic_vector (C_TAG_BIT-1 downto 0);
        tag_data_out   :   out std_logic_vector (C_TAG_BIT-1 downto 0)
    );
end component;
signal tag_data_sig : std_logic_vector (C_TAG_BIT-1 downto 0);

component cache_flg
    port (
        flg_clk_in   : in    std_logic;
        flg_we_in    : in    std_logic;
        flg_addr_in  : in    TYPE_LineWidth;
        flg_data_in  : in    std_logic;
        flg_data_out :   out std_logic
    );
end component;
signal flg_v_sig : std_logic;
signal flg_u_sig : std_logic;

component cache_data
    port (
        cache_clk_in   : in    std_logic;
        cache_we_in    : in    std_logic;
        cache_dqmn_in  : in    std_logic_vector ( 3 downto 0);
        cache_addr_in  : in    TYPE_DataWidth;
        cache_data_in  : in    std_logic_vector (31 downto 0);
        cache_data_out :   out std_logic_vector (31 downto 0)
    );
end component;
signal cache_data_sig : std_logic_vector (31 downto 0);

signal mux_cache_dqmn_sig : std_logic_vector ( 3 downto 0);
signal mux_cache_addr_sig : std_logic_vector (31 downto 0);
signal mux_cache_data_sig : std_logic_vector (31 downto 0);
signal mux_cache_we_sig   : std_logic;

signal mux_flg_u_wrn_sig  : std_logic;
signal mux_flg_u_sig      : std_logic;

begin

    cache_mem_req_out  <= ctrl_mem_req_sig;

    cache_dqmn_out     <= mux_cache_dqmn_sig;
    cache_addr_out     <= ctrl_addr_sig (31 downto 5) & "000" & "00";
    cache_data_out     <= cache_data_sig;

    cache_fill_out     <= cf_fill_sig;
    cache_hit_out      <= ch_hit_sig;

    mux_cache_dqmn_sig <= cache_dqmn_in when ch_hit_sig = '1' else
                          (others => '0');

    mux_cache_addr_sig <= cache_addr_in when ch_hit_sig = '1' else
                          ctrl_addr_sig;

    mux_cache_data_sig <= cache_data_in when ch_hit_sig = '1' else
                          cache_mem_data_in;

    mux_cache_we_sig   <= cache_wrn_in  when ch_hit_sig = '1' else
                          cache_read_in;
                          --ctrl_wrn_sig;

    Ucache_ctrl : cache_ctrl
    port map (
        ctrl_clk_in       => cache_clk_in,
        ctrl_rstn_in      => cache_rstn_in,

        ctrl_req_in       => cache_req_in,

        ctrl_addr_in      => cache_addr_in,
        ctrl_tag_data_in  => tag_data_sig,

        ctrl_hit_in       => ch_hit_sig,
        ctrl_fill_in      => cf_fill_sig,

        ctrl_read_rdy     => cache_read_in,
        ctrl_write_rdy    => cache_write_in,

        ctrl_mem_ack_in   => cache_mem_ack_in,
        ctrl_mem_req_out  => ctrl_mem_req_sig,

        ctrl_addr_out     => ctrl_addr_sig,
        ctrl_tag_data_out => ctrl_tag_data_sig,
        ctrl_v_out        => ctrl_v_sig,
        ctrl_wrn_out      => ctrl_wrn_sig,
        ctrl_tag_wrn_out  => ctrl_tag_wrn_sig
    );

    Ucache_fill : cache_fill
    port map (
        cf_v_in     => flg_v_sig,
        cf_u_in     => flg_u_sig,
        cf_fill_out => cf_fill_sig
    );

    Ucache_hit : cache_hit
    port map (
        ch_tag_in  => tag_data_sig,
        ch_addr_in => cache_addr_in (C_TAG_MSB downto C_TAG_LSB),
        ch_v_in    => flg_v_sig,
        ch_hit_out => ch_hit_sig
    );

    Ucache_tag : cache_tag
    port map (
        tag_clk_in   => cache_clk_in,
        tag_we_in    => ctrl_tag_wrn_sig,
        tag_addr_in  => cache_addr_in (C_LINE_MSB downto C_LINE_LSB),
        tag_data_in  => ctrl_tag_data_sig,
        tag_data_out => tag_data_sig
    );

    Ucache_flg_v : cache_flg
    port map (
        flg_clk_in   => cache_clk_in,
        flg_we_in    => ctrl_tag_wrn_sig,
        flg_addr_in  => cache_addr_in (C_LINE_MSB downto C_LINE_LSB),
        flg_data_in  => ctrl_v_sig,
        flg_data_out => flg_v_sig
    );

    mux_flg_u_wrn_sig <= mux_cache_we_sig when ch_hit_sig = '1' else
                         ctrl_tag_wrn_sig;

    mux_flg_u_sig     <= '1' when ch_hit_sig = '1' else
                         '0';

    Ucache_flg_u : cache_flg
    port map (
        flg_clk_in   => cache_clk_in,
        flg_we_in    => mux_flg_u_wrn_sig,
        flg_addr_in  => cache_addr_in (C_LINE_MSB downto C_LINE_LSB),
        flg_data_in  => mux_flg_u_sig,
        flg_data_out => flg_u_sig
    );

    Ucache_data : cache_data
    port map (
        cache_clk_in   => cache_clk_in,
        cache_we_in    => mux_cache_we_sig,
        cache_dqmn_in  => mux_cache_dqmn_sig,
        cache_addr_in  => mux_cache_addr_sig ((C_LINE_BIT + C_DATA_BIT)-1+C_UNUSED_BIT downto 0+C_UNUSED_BIT),
        cache_data_in  => mux_cache_data_sig,
        cache_data_out => cache_data_sig
    );

end RTL;
