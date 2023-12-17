library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cmtcks_pac.all;

entity cmtcks is
    port (
        cmtcks_cs_in   : in    std_logic;
        cmtcks_clk_in  : in    std_logic;
        cmtcks_rst_in  : in    std_logic;
        cmtcks_cks_in  : in    std_logic_vector (1 downto 0);
        cmtcks_clk_out :   out std_logic
    );
end cmtcks;

architecture rtl of cmtcks is

    signal clk_reg : std_logic_vector (8 downto 0);

begin

    process (
        cmtcks_cs_in,
        cmtcks_clk_in,
        cmtcks_rst_in,
        cmtcks_cks_in
    )
    begin
        if (cmtcks_clk_in'event and cmtcks_clk_in = '1') then
            if ((cmtcks_rst_in = '1')
             or (cmtcks_cs_in   = '0')) then
                clk_reg <= (others => '0');
            else
                clk_reg <= std_logic_vector(unsigned(clk_reg) + 1);
            end if;
        end if;
    end process;

    cmtcks_clk_out <= clk_reg (2) when cmtcks_cks_in = "00" else
                      clk_reg (4) when cmtcks_cks_in = "01" else
                      clk_reg (6) when cmtcks_cks_in = "10" else
                      clk_reg (8);

end rtl;
