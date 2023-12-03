library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iuldst_pac.all;

entity iustdqm is
    port (
        iustdqm_write_in : in    std_logic;
        iustdqm_type_in  : in    std_logic_vector( 1 downto 0);
        iustdqm_addr_in  : in    std_logic_vector( 1 downto 0);
        iustdqm_dqm_out  :   out std_logic_vector( 3 downto 0)
    );
end iustdqm;

architecture rtl of iustdqm is

    signal byte_dqm_sig : std_logic_vector( 3 downto 0);
    signal half_dqm_sig : std_logic_vector( 3 downto 0);
    signal word_dqm_sig : std_logic_vector( 3 downto 0);

begin

    with iustdqm_addr_in select
    byte_dqm_sig <= "1000" when "00",
                    "0100" when "01",
                    "0010" when "10",
                    "0001" when others;

    with iustdqm_addr_in select
    half_dqm_sig <= "1100" when "00",
                    "0011" when "10",
                    "0000" when others;

    with iustdqm_addr_in select
    word_dqm_sig <= "1111" when "00",
                    "0000" when others;

    with iustdqm_write_in & iustdqm_type_in select
    iustdqm_dqm_out <= byte_dqm_sig    when "1" & IULDST_MEM_TYPE_BYTE,
                       half_dqm_sig    when "1" & IULDST_MEM_TYPE_HALF,
                       word_dqm_sig    when "1" & IULDST_MEM_TYPE_WORD,
                       (others => '0') when others;

end rtl;
