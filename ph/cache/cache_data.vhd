library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.cache_pac.all;

entity cache_data is
    port (
        cache_clk_in   : in    std_logic;
        cache_we_in    : in    std_logic;
        cache_dqmn_in  : in    std_logic_vector ( 3 downto 0);
        cache_addr_in  : in    TYPE_DataWidth;
        cache_data_in  : in    std_logic_vector (31 downto 0);
        cache_data_out :   out std_logic_vector (31 downto 0)
    );
end cache_data;

architecture RTL of cache_data is

signal cache_data_0 : type_cache_data;
signal cache_data_1 : type_cache_data;
signal cache_data_2 : type_cache_data;
signal cache_data_3 : type_cache_data;

begin

    process (
        cache_clk_in
    )
    variable addr : integer;
    begin

        addr := conv_integer (cache_addr_in);

        cache_data_out (31 downto 24) <= cache_data_0 (addr);
        cache_data_out (23 downto 16) <= cache_data_1 (addr);
        cache_data_out (15 downto  8) <= cache_data_2 (addr);
        cache_data_out ( 7 downto  0) <= cache_data_3 (addr);

        if (cache_clk_in'event and cache_clk_in = '1') then
            if (cache_we_in = '1') then
                if (cache_dqmn_in (3) = '0') then
                    cache_data_0 (addr) <= cache_data_in (31 downto 24);
                end if;
                if (cache_dqmn_in (2) = '0') then
                    cache_data_1 (addr) <= cache_data_in (23 downto 16);
                end if;
                if (cache_dqmn_in (1) = '0') then
                    cache_data_2 (addr) <= cache_data_in (15 downto  8);
                end if;
                if (cache_dqmn_in (0) = '0') then
                    cache_data_3 (addr) <= cache_data_in ( 7 downto  0);
                end if;
            end if;
        end if;
    end process;

end RTL;
