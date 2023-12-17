library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spibg is
    port (
        spibg_en_in   : in    std_logic;
        spibg_clk_in  : in    std_logic;
        spibg_rst_in  : in    std_logic;
        spibg_scbr_in : in    std_logic_vector(7 downto 0);
        spibg_clk_out :   out std_logic
    );
end spibg;

architecture rtl of spibg is

    signal clkgn_cnt_reg : std_logic_vector(7 downto 0);
    signal clkgn_reg     : std_logic;

begin

    process (
        spibg_en_in,
        spibg_clk_in,
        spibg_rst_in,
        spibg_scbr_in,
        clkgn_cnt_reg,
        clkgn_reg
    )
    begin
        if (spibg_clk_in'event and spibg_clk_in = '1') then
            if ((spibg_rst_in = '1')
             or (spibg_en_in   = '0')) then
                clkgn_cnt_reg <= (others => '0');
                clkgn_reg     <= '0';
            else
                clkgn_cnt_reg <= std_logic_vector(unsigned(clkgn_cnt_reg) + 1);
                if (clkgn_cnt_reg = spibg_scbr_in) then
                    clkgn_cnt_reg <= (others => '0');
                    clkgn_reg     <= not clkgn_reg;
                end if;
            end if;
        end if;
    end process;

    spibg_clk_out <= clkgn_reg;

end rtl;
