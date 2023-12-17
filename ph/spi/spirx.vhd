library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spi_pac.all;

entity spirx is
    port (
        spirx_re_in      : in    std_logic;
        spirx_clk_in     : in    std_logic;
        spirx_spi_clk_in : in    std_logic;
        spirx_spi_csn_in : in    std_logic;
        spirx_rst_in     : in    std_logic;

        spirx_ckp_in     : in    std_logic;
        spirx_cke_in     : in    std_logic;

        spirx_scrd_out   :   out std_logic_vector (7 downto 0);
        spirx_rdrf_out   :   out std_logic;

        spirx_sdi_in     : in    std_logic
    );
end spirx;

architecture rtl of spirx is

    signal rx_cnt_reg      : std_logic_vector(3 downto 0);

    signal scrs_reg        : std_logic_vector(7 downto 0);
    signal scrd_reg        : std_logic_vector(7 downto 0);

    signal rdrf_reg        : std_logic;

    signal spi_clk_reg     : std_logic;

begin

    PH_SPI_RX_CTRL : process (
        spirx_clk_in
    )

    variable mode_sig : std_logic_vector(1 downto 0);

    begin
        mode_sig := spirx_ckp_in & spirx_cke_in;

        if (spirx_clk_in'event and spirx_clk_in = '1') then
            if ((spirx_rst_in = '1')
             or (spirx_re_in  = '0')) then
                rdrf_reg   <= '0';
                scrs_reg   <= (others => '0');
                scrd_reg   <= (others => '0');
                rx_cnt_reg <= (others => '0');
            else
                spi_clk_reg <= spirx_spi_clk_in;
                if (((spi_clk_reg   = '0' )
                 and (spirx_spi_clk_in   = '1' )
                 and ((mode_sig = "00")
                   or (mode_sig = "11")))

                 or ((spi_clk_reg   = '1' )
                 and (spirx_spi_clk_in   = '0' )
                 and ((mode_sig = "01")
                   or (mode_sig = "10")))) then

                    case rx_cnt_reg is
                    when "0000" | "0001" | "0010" | "0011"
                       | "0100" | "0101" | "0110" | "0111" =>
                        rdrf_reg <= '0';
                        if  (spirx_spi_csn_in = '0') then
                            scrs_reg(7 downto 1) <= scrs_reg(6 downto 0);
                            scrs_reg(0)          <= spirx_sdi_in;
                            rx_cnt_reg           <= std_logic_vector(unsigned(rx_cnt_reg) + 1);
                        end if;
                    when "1000" =>
                        rdrf_reg             <= '1';
                        scrs_reg(7 downto 1) <= scrs_reg(6 downto 0);
                        scrs_reg(0)          <= spirx_sdi_in;
                        scrd_reg             <= scrs_reg;
                        if (spirx_spi_csn_in = '1') then
                            rx_cnt_reg <= (others => '0');
                        else
                            rx_cnt_reg <= "0001";
                        end if;
                    when others =>
                        rdrf_reg   <= '0';
                        scrs_reg   <= (others => '0');
                        scrd_reg   <= (others => '0');
                        rx_cnt_reg <= (others => '0');
                    end case;
                end if;
            end if;
        end if;
    end process PH_SPI_RX_CTRL;

    spirx_scrd_out <= scrd_reg;
    spirx_rdrf_out <= rdrf_reg;

end rtl;
