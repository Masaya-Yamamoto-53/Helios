library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spicks is
    port (
        spicks_en_in   : in    std_logic;
        spicks_clk_in  : in    std_logic;
        spicks_bclk_in : in    std_logic;
        spicks_rst_in  : in    std_logic;
        spicks_cks_in  : in    std_logic_vector(1 downto 0);
        spicks_clk_out :   out std_logic
    );
end spicks;

architecture rtl of spicks is

    signal bclk_reg : std_logic;
    signal clk_reg  : std_logic_vector(5 downto 0);

begin

    process (
        spicks_en_in,
        spicks_clk_in,
        spicks_rst_in
    )
    begin
        if (spicks_clk_in'event and spicks_clk_in = '1') then
            if ((spicks_rst_in = '1')
             or (spicks_en_in  = '0')) then
                bclk_reg <= '0';
                clk_reg  <= (others => '0');
            else
                bclk_reg <= spicks_bclk_in;
                if ((bclk_reg       = '0')
                and (spicks_bclk_in = '1')) then
                    clk_reg <= std_logic_vector(unsigned(clk_reg) + 1);
                end if;
            end if;
        end if;
    end process;

    spicks_clk_out <= spicks_clk_in when spicks_cks_in = "00" else
                      clk_reg(1)    when spicks_cks_in = "01" else
                      clk_reg(3)    when spicks_cks_in = "10" else
                      clk_reg(5);

end rtl;
