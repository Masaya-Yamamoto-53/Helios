library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.cache_pac.all;

entity cache_tag is
    port (
        tag_clk_in   : in    std_logic;
        tag_we_in    : in    std_logic;
        tag_addr_in  : in    TYPE_LineWidth;
        tag_data_in  : in    std_logic_vector (C_TAG_BIT-1 downto 0);
        tag_data_out :   out std_logic_vector (C_TAG_BIT-1 downto 0)
    );
end cache_tag;

architecture RTL of cache_tag is

signal cache_tag   : TYPE_CacheTag;

begin


    process (
        tag_clk_in,
        tag_we_in,
        tag_addr_in,
        tag_data_in,
        cache_tag
    )

    variable addr : integer;

    begin
        addr := conv_integer (tag_addr_in);

        tag_data_out <= cache_tag (addr);

        if (tag_clk_in'event and tag_clk_in = '1') then
            if (tag_we_in = '1') then
                cache_tag (addr) <= tag_data_in;
            end if;
        end if;
    end process;

end RTL;
