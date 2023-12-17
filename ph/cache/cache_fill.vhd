library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.cache_pac.all;

entity cache_fill is
    port (
        cf_v_in     : in    std_logic;
        cf_u_in     : in    std_logic;
        cf_fill_out :   out std_logic
    );
end cache_fill;

architecture RTL of cache_fill is

begin

    cf_fill_out <= '0' when ((cf_v_in = '1')
                         and (cf_u_in = '1')) else -- Write Back Request
                   '1';

end RTL;
