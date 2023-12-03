library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iusft_pac.all;

entity iusft is
    port (
        iusft_cs_in    : in    std_logic;
        iusft_op_in    : in    std_logic_vector( 2 downto 0);
        iusft_di_in    : in    std_logic_vector(31 downto 0);
        iusft_shcnt_in : in    std_logic_vector( 4 downto 0);
        iusft_do_out   :   out std_logic_vector(31 downto 0)
    );
end iusft;

architecture rtl of iusft is
    type sft_t is array (0 to 31) of std_logic_vector(31 downto 0);
    signal sl_sig : sft_t;

    signal op_sig        : std_logic_vector( 2 downto 0);
    signal shcnt_sig     : integer := 31;
    signal shcnt_ext_sig : integer := 31;
    signal revers_sig    : std_logic;

    signal di_sig        : std_logic_vector(31 downto 0);
    signal di_sl_sig     : std_logic_vector(31 downto 0);
    signal di_sr_sig     : std_logic_vector(31 downto 0);
    signal di_byte_sig   : std_logic_vector(31 downto 0);
    signal di_half_sig   : std_logic_vector(31 downto 0);
    signal di_sft_sig    : std_logic_vector(31 downto 0);

    signal sign_sig      : std_logic_vector(30 downto 0);
    signal result_sig    : std_logic_vector(31 downto 0);

begin

    op_sig    <= iusft_op_in and ( 2 downto 0 => iusft_cs_in);
    di_sig    <= iusft_di_in and (31 downto 0 => iusft_cs_in);
    shcnt_sig <= to_integer(unsigned(iusft_shcnt_in and ( 4 downto 0 => iusft_cs_in)));

    with op_sig select
    revers_sig <= '0' when IUSFT_OP_SLL,
                  '1' when others;

    with op_sig select
    shcnt_ext_sig <= 24        when IUSFT_OP_SEXTB,
                     16        when IUSFT_OP_SEXTH,
                     shcnt_sig when others;

    di_sl_sig   <= di_sig;
    di_sr_sig   <= iusft_revers_signals(di_sig);
    di_byte_sig <= X"000000" & di_sr_sig (31 downto 24);
    di_half_sig <= X"0000"   & di_sr_sig (31 downto 16);

    with op_sig select
    di_sft_sig <= di_sl_sig       when IUSFT_OP_SLL,
                  di_sr_sig       when IUSFT_OP_SRL,
                  di_sr_sig       when IUSFT_OP_SRA,
                  di_byte_sig     when IUSFT_OP_SEXTB,
                  di_half_sig     when IUSFT_OP_SEXTH,
                  (others => '0') when others;

    with op_sig select
    sign_sig <= (others => di_sig(31)) when IUSFT_OP_SRA,
                (others => di_sig( 7)) when IUSFT_OP_SEXTB,
                (others => di_sig(15)) when IUSFT_OP_SEXTH,
                (others => '0')        when others;

    sl_sig( 0) <= di_sft_sig(31 downto 0);
    sl_sig( 1) <= di_sft_sig(30 downto 0) & sign_sig( 0 downto 0);
    sl_sig( 2) <= di_sft_sig(29 downto 0) & sign_sig( 1 downto 0);
    sl_sig( 3) <= di_sft_sig(28 downto 0) & sign_sig( 2 downto 0);
    sl_sig( 4) <= di_sft_sig(27 downto 0) & sign_sig( 3 downto 0);
    sl_sig( 5) <= di_sft_sig(26 downto 0) & sign_sig( 4 downto 0);
    sl_sig( 6) <= di_sft_sig(25 downto 0) & sign_sig( 5 downto 0);
    sl_sig( 7) <= di_sft_sig(24 downto 0) & sign_sig( 6 downto 0);
    sl_sig( 8) <= di_sft_sig(23 downto 0) & sign_sig( 7 downto 0);
    sl_sig( 9) <= di_sft_sig(22 downto 0) & sign_sig( 8 downto 0);
    sl_sig(10) <= di_sft_sig(21 downto 0) & sign_sig( 9 downto 0);
    sl_sig(11) <= di_sft_sig(20 downto 0) & sign_sig(10 downto 0);
    sl_sig(12) <= di_sft_sig(19 downto 0) & sign_sig(11 downto 0);
    sl_sig(13) <= di_sft_sig(18 downto 0) & sign_sig(12 downto 0);
    sl_sig(14) <= di_sft_sig(17 downto 0) & sign_sig(13 downto 0);
    sl_sig(15) <= di_sft_sig(16 downto 0) & sign_sig(14 downto 0);
    sl_sig(16) <= di_sft_sig(15 downto 0) & sign_sig(15 downto 0);
    sl_sig(17) <= di_sft_sig(14 downto 0) & sign_sig(16 downto 0);
    sl_sig(18) <= di_sft_sig(13 downto 0) & sign_sig(17 downto 0);
    sl_sig(19) <= di_sft_sig(12 downto 0) & sign_sig(18 downto 0);
    sl_sig(20) <= di_sft_sig(11 downto 0) & sign_sig(19 downto 0);
    sl_sig(21) <= di_sft_sig(10 downto 0) & sign_sig(20 downto 0);
    sl_sig(22) <= di_sft_sig( 9 downto 0) & sign_sig(21 downto 0);
    sl_sig(23) <= di_sft_sig( 8 downto 0) & sign_sig(22 downto 0);
    sl_sig(24) <= di_sft_sig( 7 downto 0) & sign_sig(23 downto 0);
    sl_sig(25) <= di_sft_sig( 6 downto 0) & sign_sig(24 downto 0);
    sl_sig(26) <= di_sft_sig( 5 downto 0) & sign_sig(25 downto 0);
    sl_sig(27) <= di_sft_sig( 4 downto 0) & sign_sig(26 downto 0);
    sl_sig(28) <= di_sft_sig( 3 downto 0) & sign_sig(27 downto 0);
    sl_sig(29) <= di_sft_sig( 2 downto 0) & sign_sig(28 downto 0);
    sl_sig(30) <= di_sft_sig( 1 downto 0) & sign_sig(29 downto 0);
    sl_sig(31) <= di_sft_sig( 0 downto 0) & sign_sig(30 downto 0);

    result_sig   <= sl_sig(shcnt_ext_sig);
    iusft_do_out <= iusft_revers_signals(result_sig) when revers_sig = '1' else
                                         result_sig;

end rtl;
