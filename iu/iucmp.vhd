library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iucmp_pac.all;
use work.iucc_pac.all;

entity iucmp is
    port (
        iucmp_cs_in  : in    std_logic;
        iucmp_op_in  : in    std_logic_vector( 2 downto 0);
        iucmp_di1_in : in    std_logic_vector(31 downto 0);
        iucmp_di2_in : in    std_logic_vector(31 downto 0);
        iucmp_n_out  :   out std_logic;
        iucmp_z_out  :   out std_logic;
        iucmp_v_out  :   out std_logic;
        iucmp_c_out  :   out std_logic;
        iucmp_do_out :   out std_logic
    );
end iucmp;

architecture rtl of iucmp is

    signal di1_sig  : std_logic_vector(31 downto 0);
    signal di2_sig  : std_logic_vector(31 downto 0);
    signal rlt_sig  : std_logic_vector(31 downto 0);

    signal n_sig    : std_logic;
    signal z_sig    : std_logic;
    signal v_sig    : std_logic;
    signal c_sig    : std_logic;
    signal cond_sig : std_logic_vector(2 downto 0);

    signal beq_sig  : std_logic;
    signal blt_sig  : std_logic;
    signal ble_sig  : std_logic;
    signal bneq_sig : std_logic;
    signal bltu_sig : std_logic;
    signal bleu_sig : std_logic;

    signal do_sig   : std_logic;

begin

    cond_sig <= iucmp_op_in  and ( 2 downto 0 => iucmp_cs_in);
    di1_sig  <= iucmp_di1_in and (31 downto 0 => iucmp_cs_in);
    di2_sig  <= iucmp_di2_in and (31 downto 0 => iucmp_cs_in);
    rlt_sig  <= std_logic_vector(unsigned(di1_sig) - unsigned(di2_sig));

    IU_Condition_Code : iucc
    port map (
        iucc_di1_msb_in => di1_sig(31),
        iucc_di2_msb_in => di2_sig(31),
        iucc_rlt_in     => rlt_sig,
        iucc_n_out      => n_sig,
        iucc_z_out      => z_sig,
        iucc_v_out      => v_sig,
        iucc_c_out      => c_sig
    );

    beq_sig  <= '1' when (cond_sig = IUCMP_OP_CMPEQ ) and ( z_sig = '1'                      ) else '0';
    blt_sig  <= '1' when (cond_sig = IUCMP_OP_CMPLT ) and (          (n_sig xor v_sig)  = '1') else '0';
    ble_sig  <= '1' when (cond_sig = IUCMP_OP_CMPLE ) and ((z_sig or (n_sig xor v_sig)) = '1') else '0';

    bneq_sig <= '1' when (cond_sig = IUCMP_OP_CMPNEQ) and ( z_sig = '0'                      ) else '0';
    bltu_sig <= '1' when (cond_sig = IUCMP_OP_CMPLTU) and ( c_sig = '1'                      ) else '0';
    bleu_sig <= '1' when (cond_sig = IUCMP_OP_CMPLEU) and ((c_sig = '1') or (z_sig = '1')    ) else '0';

    do_sig <= beq_sig
           or blt_sig
           or ble_sig
           or bneq_sig
           or bltu_sig
           or bleu_sig;

    iucmp_n_out  <= n_sig  and iucmp_cs_in;
    iucmp_z_out  <= z_sig  and iucmp_cs_in;
    iucmp_v_out  <= v_sig  and iucmp_cs_in;
    iucmp_c_out  <= c_sig  and iucmp_cs_in;
    iucmp_do_out <= do_sig and iucmp_cs_in;

end rtl;
