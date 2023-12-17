library ieee;
use ieee.std_logic_1164.all;

use work.gpi_pac.all;

entity gpi is
    generic (
        WIDTH : integer := 1
    );
    port (
        gpi_clk_in : in    std_logic;
        gpi_rst_in : in    std_logic;
        gpi_di_in  : in    std_logic_vector(WIDTH-1 downto 0);
        gpi_do_out :   out std_logic_vector(WIDTH-1 downto 0)
    );
end gpi;

architecture rtl of gpi is

    -- GPI: General Purpose Input Register
    signal gpi_reg : std_logic_vector(WIDTH-1 downto 0);

begin

    GPI_Register : process (
        gpi_clk_in,
        gpi_rst_in,
        gpi_di_in
    ) begin
        if (gpi_clk_in'event and gpi_clk_in = '1') then
            if (gpi_rst_in = '1') then
                gpi_reg <= (others => '0');
            else
                gpi_reg <= gpi_di_in;
            end if;
        end if;
    end process;

    gpi_do_out <= gpi_reg;

end rtl;
