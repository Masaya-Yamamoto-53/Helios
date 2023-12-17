library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spi_pac.all;

entity spitxrx is
    port (
        spitxrx_cs_in    : in    std_logic;
        spitxrx_clk_in   : in    std_logic;
        spitxrx_rst_in   : in    std_logic;

        spitxrx_we_in    : in    std_logic;
        spitxrx_addr_in  : in    std_logic_vector (3 downto 0);
        spitxrx_di_in    : in    std_logic_vector (7 downto 0);

        spitxrx_bclk_in  : in    std_logic;
        spitxrx_ckp_in   : in    std_logic;
        spitxrx_cke_in   : in    std_logic;

        spitxrx_start_out :   out std_logic;

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

    signal clk_sig   : std_logic;
    signal sctd_reg : std_logic_vector( 7 downto 0); -- Transmit Data Register
    signal start_reg : std_logic;
    signal cpol_reg  : std_logic;

    signal bclk_o_reg: std_logic;
    signal bclk_trg_sig: std_logic;

    signal state_reg : std_logic_vector(3 downto 0);

begin

    process (
        spitxrx_clk_in,
        spitxrx_rst_in
    ) begin
        if(spitxrx_clk_in'event and spitxrx_clk_in = '1') then
            if(spitxrx_rst_in = '1') then
                sctd_reg  <= (others => '0');
                start_reg <= '0';
            else
                if ((spitxrx_cs_in   = '1'          )
                and (spitxrx_we_in   = '1'          )
                and (spitxrx_addr_in = SPI_ADDR_SCTD)) then
                    sctd_reg  <= spitxrx_di_in;
                    start_reg <= '1';
                end if;
            end if;
        end if;
    end process;

    process(
        spitxrx_clk_in,
        spitxrx_rst_in
    ) begin
        if(spitxrx_clk_in'event and spitxrx_clk_in = '1') then
            if(spitxrx_rst_in = '1') then
                bclk_o_reg <= '0';
                bclk_trg_sig <= '0';
            else
                bclk_o_reg <= spitxrx_bclk_in;

                if(bclk_o_reg = '0' and spitxrx_bclk_in = '1') then
                    bclk_trg_sig <= '1';
                else
                    bclk_trg_sig <= '0';
                end if;
            end if;
        end if;
    end process;

    process (
        spitxrx_clk_in,
        spitxrx_rst_in
    ) begin
        if(spitxrx_clk_in'event and spitxrx_clk_in = '1') then
            if(spitxrx_rst_in = '1') then
                cpol_reg <= '0';
            end if;
        end if;
    end process;

    process (
        spitxrx_clk_in,
        spitxrx_rst_in
    ) begin
        if(spitxrx_clk_in'event and spitxrx_clk_in = '1') then
            if(spitxrx_rst_in = '1') then
                state_reg < = (others => '0');
            else
                if
                if(bclk_trg_sig = '1') then
                    scts_reg(7 downto 1) <= scts_reg(6 downto 0);
                    sdo_sig <= scts_reg(7);
                end if;
            end if;
        end if;
    end process;

    process (
        spitxrx_clk_in,
        spitxrx_rst_in
    ) begin
        if(spitxrx_clk_in'event and spitxrx_clk_in = '1') then
            if((spitxrx_rst_in = '1')
            or (start_reg  = '0')) then
                clk_sig <= cpol_reg;
            else
                clk_sig <= not clk_sig;
            end if;
        end if;
    end process;

    spitxrx_start_out <= start_reg;
    spitxrx_clk_out   <= clk_sig;
    spitxrx_sdo_out   <= sdo_sig;

end rtl;
