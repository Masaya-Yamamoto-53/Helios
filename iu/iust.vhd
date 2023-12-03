library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

use work.iuldst_pac.all;
use work.iustdqm_pac.all;
use work.iustdo_pac.all;

entity iust is
    port (
        iust_write_in : in    std_logic;
        iust_type_in  : in    std_logic_vector( 1 downto 0);
        iust_addr_in  : in    std_logic_vector( 1 downto 0);
        iust_di_in    : in    std_logic_vector(31 downto 0);
        iust_dqm_out  :   out std_logic_vector( 3 downto 0);
        iust_do_out   :   out std_logic_vector(31 downto 0)
    );
end iust;

architecture rtl of iust is

    signal addr_sig : std_logic_vector( 1 downto 0);
    signal di_sig   : std_logic_vector(31 downto 0);
    signal type_sig : std_logic_vector( 1 downto 0);

begin

    addr_sig <= iust_addr_in and ( 1 downto 0 => iust_write_in);
    di_sig   <= iust_di_in   and (31 downto 0 => iust_write_in);
    type_sig <= iust_type_in and ( 1 downto 0 => iust_write_in);

    IU_Store_DQM : iustdqm
    port map (
        iustdqm_write_in => iust_write_in,
        iustdqm_type_in  => type_sig,
        iustdqm_addr_in  => addr_sig,
        iustdqm_dqm_out  => iust_dqm_out
    );

    IU_Store_Data : iustdo
    port map (
        iustdo_write_in => iust_write_in,
        iustdo_type_in  => type_sig,
        iustdo_addr_in  => addr_sig,
        iustdo_di_in    => di_sig,
        iustdo_do_out   => iust_do_out
    );

end rtl;
