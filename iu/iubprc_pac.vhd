--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Branch Prediction Address Generator
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package iubprc_pac is

    component iubprc
        port (
            iubprc_op_in     : in    std_logic_vector( 1 downto 0);
            iubprc_p_in      : in    std_logic;
            iubprc_op2_in    : in    std_logic_vector( 1 downto 0);
            iubprc_disp19_in : in    std_logic_vector(18 downto 0);
            iubprc_token_out :   out std_logic;
            iubprc_addr_out  :   out std_logic_vector(29 downto 0)
        );
    end component;

    -- Sign extension for 19-bits displacement
    function iubprc_sign_extend_disp19 (
        signal addr : std_logic_vector(18 downto 0)
    ) return std_logic_vector;

end iubprc_pac;

package body iubprc_pac is

    -- Function to sign-extend a 19-bit displacement
    function iubprc_sign_extend_disp19 (
        signal addr : std_logic_vector(18 downto 0)
    ) return std_logic_vector is
    begin
        return addr(18) & addr(18) & addr(18) & addr(18) &
               addr(18) & addr(18) & addr(18) & addr(18) &
               addr(18) & addr(18) & addr(18) & addr;
    end iubprc_sign_extend_disp19;

end iubprc_pac;
