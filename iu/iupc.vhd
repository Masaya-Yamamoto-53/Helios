library ieee;
use ieee.std_logic_1164.all;

entity iupc is
    port (
        iupc_clk_in  : in    std_logic;
        iupc_rst_in  : in    std_logic;
        iupc_wen_in  : in    std_logic;
        iupc_di_in   : in    std_logic_vector(29 downto 0);
        iupc_do_out  :   out std_logic_vector(29 downto 0)
    );
end iupc;

architecture rtl of iupc is

    signal pc_reg : std_logic_vector(29 downto 0) := (others => '0');

begin

    IU_Program_Counter : process (
        iupc_clk_in,
        iupc_rst_in,
        iupc_wen_in,
        iupc_di_in
    )
    begin
        if (iupc_clk_in'event and iupc_clk_in = '1') then
            if (iupc_rst_in = '1') then
                pc_reg <= (others => '0');
            elsif (iupc_wen_in = '0') then
                pc_reg <= iupc_di_in;
            end if;
        end if;
    end process IU_Program_Counter;

    iupc_do_out <= pc_reg;

end rtl;
