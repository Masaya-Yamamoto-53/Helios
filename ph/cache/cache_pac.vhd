library ieee;
use ieee.std_logic_1164.all;

package cache_pac is

constant C_UNUSED_BIT : integer := 2;
constant C_DATA_BIT   : integer := 3; --[FIXED]
constant C_LINE_BIT   : integer := 5;
constant C_TAG_BIT    : integer := (32-C_UNUSED_BIT-C_DATA_BIT-C_LINE_BIT);

-- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
-- +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
-- |                               TAG                               |     LINE     |  DATA  |  /  |
-- +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

constant C_DATA_LSB : integer := C_UNUSED_BIT;
constant C_DATA_MSB : integer := (C_DATA_BIT + C_DATA_LSB) - 1;
constant C_LINE_LSB : integer := C_DATA_MSB + 1;
constant C_LINE_MSB : integer := (C_LINE_BIT + C_LINE_LSB) - 1;
constant C_TAG_LSB  : integer := C_LINE_MSB + 1;
constant C_TAG_MSB  : integer := (C_TAG_BIT + C_TAG_LSB) - 1;

--constant CTRL_ADDR_MSB : integer := 25;

subtype TYPE_DataWidth is std_logic_vector ((C_LINE_BIT + C_DATA_BIT)-1 downto 0);
subtype TYPE_LineWidth is std_logic_vector (C_LINE_MSB downto C_LINE_LSB);
subtype TYPE_LRUWidth  is std_logic;

type TYPE_CacheTag   is array (0 to (2**C_LINE_BIT)-1)
                     of std_logic_vector (C_TAG_BIT-1 downto 0);

type TYPE_CacheLRU   is array (0 to (2**C_LINE_BIT)-1)
                     of TYPE_LRUWidth;

type TYPE_CacheFlg   is array (0 to (2**C_LINE_BIT)-1)
                     of std_logic;

type TYPE_CACHE_DATA is array (0 to (((2**C_LINE_BIT)*(2**C_DATA_BIT))-1))
                     of std_logic_vector ( 7 downto 0);

end cache_pac;
