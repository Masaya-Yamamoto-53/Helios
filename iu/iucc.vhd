--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Condition Code
-- Description:
--   Determine the state of the following four flags
--   based on the subtraction result.
--
--   Negative flag: Indicates a negative result in computation.
--       Zero flag: Signals equality to zero in computation.
--   Overflow flag: Detects overflow in arithmetic operations.
--      Carry flag: Indicates carry or borrow in arithmetic.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iucc_pac.all;

entity iucc is
    port (
        iucc_di1_msb_in : in    std_logic;
        iucc_di2_msb_in : in    std_logic;
        iucc_rlt_in     : in    std_logic_vector(31 downto 0);
        iucc_n_out      :   out std_logic;
        iucc_z_out      :   out std_logic;
        iucc_v_out      :   out std_logic;
        iucc_c_out      :   out std_logic
    );
end iucc;

architecture rtl of iucc is

    signal di1_sig : std_logic;
    signal di2_sig : std_logic;
    signal rlt_sig : std_logic_vector(31 downto 0);

begin

    di1_sig  <= iucc_di1_msb_in;
    di2_sig  <= iucc_di2_msb_in;
    rlt_sig  <= iucc_rlt_in;

    -- Negative flag
    -- When the sign bit (MSB) is 1, it represents a negative value.
    iucc_n_out <= rlt_sig(31);

    -- Zero flag
    -- When the result of the operation is 0, it is zero.
    iucc_z_out <= '1' when rlt_sig = X"00000000" else '0';

    -- Overflow flag
    -- The following are examples illustrating overflow in the case of 8-bit data.
    -- 
    --      N                P                   P
    -- -128(1000 0000)  -  1(0000 0001) = -129(1 0111 1111)
    --      P                N                   N
    --  127(0111 1111)  - -1(1111 1111) = -128(  1000 0000)
    iucc_v_out <= ((    di1_sig    ) and (not  di2_sig) and (not rlt_sig(31)))
               or ((not di1_sig    ) and (     di2_sig) and (    rlt_sig(31)));

    -- Carry flag
    -- The following are examples illustrates carry(borrow) in the case of 8-bit data.
    --
    --      N                 N                N
    --   -2(1111 1110) -   -1(1111 1111) =  -1(1111 1111)
    --      P                 N                N
    --  127(0111 1111) - -128(1000 0000) = 255(1111 1111)
    --      P                 P                N
    --    0(0000 0000) -    1(0000 00001) = -1(1111 1111)
    iucc_c_out <= ((not di1_sig    ) and       di2_sig)
               or ((    rlt_sig(31)) and ((not di1_sig) or di2_sig));

end rtl;
