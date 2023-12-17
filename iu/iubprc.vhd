--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Branch Prediction Address Generator
-- Description:
--   The function sets the prediction bit to enable a specific address
--   when a branch instruction is selected,
--   and sign-extends a 19-bit displacement to a 32-bit instruction address.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iuctrl_pac.all;
use work.iubprc_pac.all;

entity iubprc is
    port (
        iubprc_op_in     : in    std_logic_vector( 1 downto 0);
        iubprc_p_in      : in    std_logic;
        iubprc_op2_in    : in    std_logic_vector( 1 downto 0);
        iubprc_disp19_in : in    std_logic_vector(18 downto 0);
        iubprc_token_out :   out std_logic;
        iubprc_addr_out  :   out std_logic_vector(29 downto 0)
    );
end iubprc;

architecture rtl of iubprc is

    signal cs_sig    : std_logic;
    signal token_sig : std_logic;

begin

    -- The compiler sets the prediction bit to 1,
    -- enabling the address when a branch instruction is selected.
    cs_sig <= '1' when ((iubprc_op_in  = IUCTRL_OP_BRPR)
                    and (iubprc_op2_in = IUCTRL_OP2_IBR)) else '0';

    token_sig <= iubprc_p_in and cs_sig;

    -- Sign-extend a 19-bit displacement to generate a 32-bit instruction address.
    iubprc_token_out <= token_sig;
    iubprc_addr_out  <= iubprc_sign_extend_disp19(iubprc_disp19_in) and (29 downto 0 => token_sig);

end rtl;
