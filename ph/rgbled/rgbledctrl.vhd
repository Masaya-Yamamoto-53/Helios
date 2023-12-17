library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rgbledctrl is
    generic (
        -- PWM Resolution
        C_GEN_PW_EXP : integer := 8
    );
    port (
        rgbledctrl_clk_in    : in    std_logic;

        rgbledctrl_st_reg_in : in    std_logic;

        rgbledctrl_r_reg_in  : in    std_logic_vector(C_GEN_PW_EXP-1 downto 0);
        rgbledctrl_g_reg_in  : in    std_logic_vector(C_GEN_PW_EXP-1 downto 0);
        rgbledctrl_b_reg_in  : in    std_logic_vector(C_GEN_PW_EXP-1 downto 0);

        rgbledctrl_r_out     :   out std_logic;
        rgbledctrl_g_out     :   out std_logic;
        rgbledctrl_b_out     :   out std_logic
    );
end rgbledctrl;

architecture rtl of rgbledctrl is

    signal count_reg    : std_logic_vector(C_GEN_PW_EXP downto 0) := (C_GEN_PW_EXP downto 1 => '1') & '0';
    signal rgbledctrl_r_reg : std_logic := '0'; -- for rgbledctrl_r_out
    signal rgbledctrl_g_reg : std_logic := '0'; -- for rgbledctrl_g_out
    signal rgbledctrl_b_reg : std_logic := '0'; -- for rgbledctrl_b_out

    -- Threshold Limit Value Signals
    signal red_hi_tlv_sig : std_logic_vector(C_GEN_PW_EXP downto 0);
    signal red_lo_tlv_sig : std_logic_vector(C_GEN_PW_EXP downto 0);
    signal grn_hi_tlv_sig : std_logic_vector(C_GEN_PW_EXP downto 0);
    signal grn_lo_tlv_sig : std_logic_vector(C_GEN_PW_EXP downto 0);
    signal blu_hi_tlv_sig : std_logic_vector(C_GEN_PW_EXP downto 0);
    signal blu_lo_tlv_sig : std_logic_vector(C_GEN_PW_EXP downto 0);

    -- Start Register
    signal st_reg : std_logic := '0';

    -- RGB LED On-Duty Width Registers
    signal r_reg  : std_logic_vector(C_GEN_PW_EXP-1 downto 0) := (others => '0');
    signal g_reg  : std_logic_vector(C_GEN_PW_EXP-1 downto 0) := (others => '0');
    signal b_reg  : std_logic_vector(C_GEN_PW_EXP-1 downto 0) := (others => '0');

begin

    Ph_PWM_Register : process (
        rgbledctrl_clk_in
    ) begin
        if (rgbledctrl_clk_in'event and rgbledctrl_clk_in = '1') then
            if (count_reg = (C_GEN_PW_EXP downto 0 => '0')) then
                st_reg  <= rgbledctrl_st_reg_in;
                r_reg   <= rgbledctrl_r_reg_in;
                g_reg   <= rgbledctrl_g_reg_in;
                b_reg   <= rgbledctrl_b_reg_in;
            end if;
        end if;
    end process;

    Ph_PWM_Counter : process (
        rgbledctrl_clk_in
    ) begin
        if (rgbledctrl_clk_in'event and rgbledctrl_clk_in = '1') then
            if (st_reg = '0') then
                count_reg <= (C_GEN_PW_EXP downto 0 => '0');
            else
                count_reg <= std_logic_vector(unsigned(count_reg) + 1);
            end if;
        end if;
    end process;

    red_hi_tlv_sig <= std_logic_vector(to_unsigned(1+2**(C_GEN_PW_EXP+1)-1,   (C_GEN_PW_EXP+1)));
    red_lo_tlv_sig <= std_logic_vector(to_unsigned(1+2**(C_GEN_PW_EXP+1)-1,   (C_GEN_PW_EXP+1)) + unsigned(r_reg));

    grn_hi_tlv_sig <= std_logic_vector(to_unsigned(1+2**(C_GEN_PW_EXP+1)/4-1, (C_GEN_PW_EXP+1)));
    grn_lo_tlv_sig <= std_logic_vector(to_unsigned(1+2**(C_GEN_PW_EXP+1)/4-1, (C_GEN_PW_EXP+1)) + unsigned(g_reg));

    blu_hi_tlv_sig <= std_logic_vector(to_unsigned(1+2**(C_GEN_PW_EXP+1)/2-1, (C_GEN_PW_EXP+1)));
    blu_lo_tlv_sig <= std_logic_vector(to_unsigned(1+2**(C_GEN_PW_EXP+1)/2-1, (C_GEN_PW_EXP+1)) + unsigned(b_reg));

    Ph_PWM_Shifting : process (
        rgbledctrl_clk_in
    ) begin
        if (rgbledctrl_clk_in'event and rgbledctrl_clk_in = '1') then
            if (st_reg = '0') then
                rgbledctrl_r_reg <= '0';
                rgbledctrl_g_reg <= '0';
                rgbledctrl_b_reg <= '0';
            else
                -- Red LED Signal
                if    (count_reg = red_lo_tlv_sig) then
                    rgbledctrl_r_reg <= '0';
                elsif (count_reg = red_hi_tlv_sig) then
                    rgbledctrl_r_reg <= '1';
                end if;

                -- Grn LED Signal
                if    (count_reg = grn_lo_tlv_sig) then
                    rgbledctrl_g_reg <= '0';
                elsif (count_reg = grn_hi_tlv_sig) then
                    rgbledctrl_g_reg <= '1';
                end if;

                -- Blu LED Signal
                if    (count_reg = blu_lo_tlv_sig) then
                    rgbledctrl_b_reg <= '0';
                elsif (count_reg = blu_hi_tlv_sig) then
                    rgbledctrl_b_reg <= '1';
                end if;
            end if;
        end if;
    end process;

    rgbledctrl_r_out <= rgbledctrl_r_reg;
    rgbledctrl_g_out <= rgbledctrl_g_reg;
    rgbledctrl_b_out <= rgbledctrl_b_reg;

end rtl;
