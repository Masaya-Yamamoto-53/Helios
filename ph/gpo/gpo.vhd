library ieee;
use ieee.std_logic_1164.all;

use work.gpo_pac.all;

entity gpo is
    generic (
        WIDTH : integer := 1
    );
    port (
        gpo_cs_in  : in    std_logic;
        gpo_clk_in : in    std_logic;
        gpo_rst_in : in    std_logic;
        gpo_we_in  : in    std_logic;
        gpo_di_in  : in    std_logic_vector(WIDTH-1 downto 0);
        gpo_do_out :   out std_logic_vector(WIDTH-1 downto 0)
    );
end gpo;

architecture rtl of gpo is

    -- GPO: General Purpose Output Register
    signal gpo_reg : std_logic_vector(WIDTH-1 downto 0);

begin

    GPO_Register : process (
        gpo_cs_in,
        gpo_clk_in,
        gpo_rst_in,
        gpo_we_in,
        gpo_di_in
    ) begin
        if (gpo_clk_in'event and gpo_clk_in = '1') then
            if (gpo_rst_in = '1') then
                gpo_reg <= (others => '0');
            elsif (gpo_we_in = '1' and gpo_cs_in = '1') then
                gpo_reg <= gpo_di_in;
            end if;
        end if;
    end process;

    gpo_do_out <= gpo_reg;

end rtl;
