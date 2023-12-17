library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.cache_pac.all;

entity cache_hit is
    port (
        ch_tag_in  : in    std_logic_vector (C_TAG_BIT-1 downto 0);
        ch_addr_in : in    std_logic_vector (C_TAG_MSB downto C_TAG_LSB);
        ch_v_in    : in    std_logic;
        ch_hit_out :   out std_logic
    );
end cache_hit;

architecture RTL of cache_hit is

begin

    ch_hit_out <= '1' when ((ch_v_in   = '1'       )
                        and (ch_tag_in = ch_addr_in)) else
                  '0';

end RTL;
