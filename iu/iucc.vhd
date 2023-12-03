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

    iucc_n_out <= rlt_sig(31);
    iucc_z_out <= '1' when rlt_sig = X"00000000" else '0';
    iucc_v_out <= ((    di1_sig    ) and (not  di2_sig) and (not rlt_sig(31)))
               or ((not di1_sig    ) and (     di2_sig) and (    rlt_sig(31)));
    iucc_c_out <= ((not di1_sig    ) and       di2_sig)
               or ((    rlt_sig(31)) and ((not di1_sig) or di2_sig));

end rtl;
