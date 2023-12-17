library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rgbledctrl_pac.all;
use work.rgbled_pac.all;

entity rgbled is
    generic (
        -- PWM Resolution
        C_GEN_PW_EXP : integer := 8
    );
    port (
        rgbled_cs_in     : in    std_logic;
        rgbled_clk_in    : in    std_logic;
        rgbled_rst_in    : in    std_logic;

        rgbled_we_in     : in    std_logic;
        rgbled_addr_in   : in    std_logic_vector(1 downto 0);
        rgbled_di_in     : in    std_logic_vector(C_GEN_PW_EXP-1 downto 0);
        rgbled_do_out    :   out std_logic_vector(C_GEN_PW_EXP-1 downto 0);

        rgbled_r_out     :   out std_logic;
        rgbled_g_out     :   out std_logic;
        rgbled_b_out     :   out std_logic
    );
end rgbled;

architecture rtl of rgbled is

    signal st_reg   : std_logic := '0';
    signal r_reg    : std_logic_vector(C_GEN_PW_EXP-1 downto 0);
    signal g_reg    : std_logic_vector(C_GEN_PW_EXP-1 downto 0);
    signal b_reg    : std_logic_vector(C_GEN_PW_EXP-1 downto 0);

    signal data_sig : std_logic_vector(C_GEN_PW_EXP-1 downto 0);

begin

    RGBLED_Start_Register : process (
        rgbled_cs_in,
        rgbled_clk_in,
        rgbled_rst_in,
        rgbled_we_in,
        rgbled_addr_in,
        rgbled_di_in
    ) begin
        if(rgbled_clk_in'event and rgbled_clk_in = '1') then
            if(rgbled_rst_in = '1') then
                st_reg <= '0';
            else
                if ((rgbled_cs_in   = '1')
                and (rgbled_we_in   = '1')
                and (rgbled_addr_in = RGBLED_ADDR_STR)) then
                    st_reg <= rgbled_di_in(0);
                end if;
            end if;
        end if;
    end process;

    RGBLED_Data_Register : process (
        rgbled_cs_in,
        rgbled_clk_in,
        rgbled_rst_in,
        rgbled_we_in,
        rgbled_addr_in,
        rgbled_di_in
    ) begin
        if(rgbled_clk_in'event and rgbled_clk_in = '1') then
            if(rgbled_rst_in = '1') then
                r_reg <= (others => '0');
                g_reg <= (others => '0');
                b_reg <= (others => '0');
            else
                if ((rgbled_cs_in   = '1')
                and (rgbled_we_in   = '1')
                and (rgbled_addr_in = RGBLED_ADDR_RDATA)) then
                    r_reg <= rgbled_di_in;
                end if;

                if ((rgbled_cs_in   = '1')
                and (rgbled_we_in   = '1')
                and (rgbled_addr_in = RGBLED_ADDR_GDATA)) then
                    g_reg <= rgbled_di_in;
                end if;

                if ((rgbled_cs_in   = '1')
                and (rgbled_we_in   = '1')
                and (rgbled_addr_in = RGBLED_ADDR_BDATA)) then
                    b_reg <= rgbled_di_in;
                end if;
            end if;
        end if;
    end process;

    RGBLED_Controller : rgbledctrl
    generic map (
        C_GEN_PW_EXP => C_GEN_PW_EXP
    )
    port map (
        rgbledctrl_clk_in    => rgbled_clk_in,
        rgbledctrl_st_reg_in => st_reg,
        rgbledctrl_r_reg_in  => r_reg,
        rgbledctrl_g_reg_in  => g_reg,
        rgbledctrl_b_reg_in  => b_reg,
        rgbledctrl_r_out     => rgbled_r_out,
        rgbledctrl_g_out     => rgbled_g_out,
        rgbledctrl_b_out     => rgbled_b_out
    );

    data_sig <= (C_GEN_PW_EXP-1 downto 1 => '0') & st_reg when rgbled_addr_in = RGBLED_ADDR_STR   else
                r_reg                                     when rgbled_addr_in = RGBLED_ADDR_RDATA else
                g_reg                                     when rgbled_addr_in = RGBLED_ADDR_GDATA else
                b_reg                                     when rgbled_addr_in = RGBLED_ADDR_BDATA else
                (others => '0');

    rgbled_do_out <= data_sig when rgbled_cs_in = '1' and rgbled_we_in = '0' else
                     (others => '0');

end rtl;
