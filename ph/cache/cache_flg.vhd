library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.cache_pac.all;

entity cache_flg is
    port (
        flg_clk_in   : in    std_logic;
        flg_we_in    : in    std_logic;
        flg_addr_in  : in    TYPE_LineWidth;
        flg_data_in  : in    std_logic;
        flg_data_out :   out std_logic
    );
end cache_flg;

architecture RTL of cache_flg is

signal cache_flg : TYPE_CacheFlg;

begin

    process (
        flg_clk_in,
        flg_we_in,
        flg_addr_in,
        flg_data_in,
        cache_flg
    )

    variable addr : integer;

    begin
        addr := conv_integer (flg_addr_in);

        flg_data_out <= cache_flg (addr);

        if (flg_clk_in'event and flg_clk_in = '1') then
            if (flg_we_in = '1') then
                cache_flg (addr) <= flg_data_in;
            end if;
        end if;
    end process;

end RTL;
