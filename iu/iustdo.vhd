--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Store Data Output
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iuldst_pac.all;

entity iustdo is
    port (
        iustdo_write_in : in    std_logic;
        iustdo_type_in  : in    std_logic_vector( 1 downto 0);
        iustdo_addr_in  : in    std_logic_vector( 1 downto 0);
        iustdo_di_in    : in    std_logic_vector(31 downto 0);
        iustdo_do_out   :   out std_logic_vector(31 downto 0)
    );
end iustdo;

architecture rtl of iustdo is

    signal byte_0_do_sig : std_logic_vector(31 downto 0);
    signal byte_1_do_sig : std_logic_vector(31 downto 0);
    signal byte_2_do_sig : std_logic_vector(31 downto 0);
    signal byte_3_do_sig : std_logic_vector(31 downto 0);

    signal half_0_do_sig : std_logic_vector(31 downto 0);
    signal half_2_do_sig : std_logic_vector(31 downto 0);

    signal byte_do_sig   : std_logic_vector(31 downto 0);
    signal half_do_sig   : std_logic_vector(31 downto 0);
    signal word_do_sig   : std_logic_vector(31 downto 0);

begin

    byte_0_do_sig <=       iustdo_di_in( 7 downto 0) & X"000000";
    byte_1_do_sig <= X"00" & iustdo_di_in( 7 downto 0) & X"0000";
    byte_2_do_sig <= X"0000" & iustdo_di_in( 7 downto 0) & X"00";
    byte_3_do_sig <= X"000000" & iustdo_di_in( 7 downto 0);

    half_0_do_sig <= iustdo_di_in(15 downto 0) & X"0000";
    half_2_do_sig <= X"0000" & iustdo_di_in(15 downto 0);

    with iustdo_addr_in select
    byte_do_sig <= byte_0_do_sig   when "00",
                   byte_1_do_sig   when "01",
                   byte_2_do_sig   when "10",
                   byte_3_do_sig   when others;

    with iustdo_addr_in select
    half_do_sig <= half_0_do_sig   when "00",
                   half_2_do_sig   when "10",
                   (others => '0') when others;

    with iustdo_addr_in select
    word_do_sig <= iustdo_di_in    when "00",
                   (others => '0') when others;

    with iustdo_write_in & iustdo_type_in select
    iustdo_do_out <= byte_do_sig     when '1' & IULDST_MEM_TYPE_BYTE,
                     half_do_sig     when '1' & IULDST_MEM_TYPE_HALF,
                     word_do_sig     when '1' & IULDST_MEM_TYPE_WORD,
                     (others => '0') when others;

end rtl;
