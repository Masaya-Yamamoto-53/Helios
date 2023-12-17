library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity segdispcks is
    port (
        segdispcks_cs_in   : in    std_logic;
        segdispcks_clk_in  : in    std_logic;
        segdispcks_rst_in  : in    std_logic;
        segdispcks_cks_in  : in    std_logic_vector(1 downto 0);
        segdispcks_clk_out :   out std_logic
    );
end segdispcks;

architecture rtl of segdispcks is

    signal clk_reg : std_logic_vector(5 downto 0);

begin

    process (
        segdispcks_cs_in,
        segdispcks_clk_in,
        segdispcks_rst_in
    ) begin
        if (segdispcks_clk_in'event and segdispcks_clk_in = '1') then
            if ((segdispcks_rst_in = '1')
             or (segdispcks_cs_in  = '0')) then
                clk_reg <= (others => '0');
            else
                clk_reg <= std_logic_vector(unsigned(clk_reg) + 1);
            end if;
        end if;
    end process;

    segdispcks_clk_out <= segdispcks_clk_in when segdispcks_cks_in = "00" else -- PΦ
                          clk_reg(1)        when segdispcks_cks_in = "01" else -- PΦ/4
                          clk_reg(3)        when segdispcks_cks_in = "10" else -- PΦ/16
                          clk_reg(5);                                          -- PΦ/64

end rtl;
