--------------------------------------------------------------------------------
-- Copyright (c) 2023 Masaya Yamamoto
-- Released under the MIT license.
-- see https://opensource.org/licenses/MIT (ENG)
-- see https://licenses.opensource.jp/MIT/MIT.html (JPN)
--
-- Design Name: IU Interruption Unit
-- Description:
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iuintr_pac.all;

entity iuintr is
    port (
        iuintr_clk_in        : in    std_logic;
        iuintr_rst_in        : in    std_logic;

        iuintr_dis_in        : in    std_logic;

        iuintr_excep_req_in  : in    std_logic_vector(15 downto 0);

        iuintr_rett_req_in   : in    std_logic;
        iuintr_rett_we_in    : in    std_logic;
        iuintr_rett_addr_in  : in    std_logic_vector(29 downto 0);

        iuintr_intr_in       : in    std_logic;
        iuintr_irl_in        : in    std_logic_vector( 3 downto 0);
        iuintr_pil_in        : in    std_logic_vector( 3 downto 0);

        iuintr_vec_we_out    :   out std_logic;
        iuintr_vec_addr_out  :   out std_logic_vector(29 downto 0);

        iuintr_intr_req_out  :   out std_logic;
        iuintr_intr_inst_out :   out std_logic_vector(31 downto 0);
        iuintr_intr_ack_out  :   out std_logic
    );
end iuintr;

architecture rtl of iuintr is

    -- exception address                             -- intruppt address
    -- "0" "0000" "00" -- Reset Signal               -- "1" "0000" "00"
    -- "0" "0001" "00"                               -- "1" "0001" "00"
    -- "0" "0010" "00"                               -- "1" "0010" "00"
    -- "0" "0011" "00"                               -- "1" "0011" "00"
    -- "0" "0100" "00"                               -- "1" "0100" "00"
    -- "0" "0101" "00" -- privileged_instruction     -- "1" "0101" "00"
    -- "0" "0110" "00" -- illegal instruction        -- "1" "0110" "00"
    -- "0" "0111" "00"                               -- "1" "0111" "00"
    -- "0" "1000" "00"                               -- "1" "1000" "00"
    -- "0" "1001" "00" -- mem address not aligned    -- "1" "1001" "00"
    -- "0" "1010" "00"                               -- "1" "1010" "00"
    -- "0" "1011" "00"                               -- "1" "1011" "00"
    -- "0" "1100" "00"                               -- "1" "1100" "00"
    -- "0" "1101" "00"                               -- "1" "1101" "00"
    -- "0" "1110" "00"                               -- "1" "1110" "00"
    -- "0" "1111" "00"                               -- "1" "1111" "00"

    signal intr_req_sig       : std_logic; -- Interrupt Request Signal
    signal excp_req_sig       : std_logic; -- Exception Request Signal
    signal rett_req_reg       : std_logic; -- RETT Instruction Request Signal

    signal intr_vec_we_sig    : std_logic;
    signal rett_vec_we_sig    : std_logic;

    signal intr_req_reg       : std_logic; -- Interrupt Request Register
    signal excp_req_reg       : std_logic; -- Exception Request Register

    signal intr_req_lvl_sig   : std_logic_vector( 3 downto 0); -- Interrupt Request Level (0000 - 1111)
    signal excp_req_lvl_sig   : std_logic_vector( 3 downto 0); -- Exception Request Level (0000 - 1111)
    signal excp_req_lvl_0_sig : std_logic_vector( 3 downto 0); -- Exception Request Level (0000 - 1111)
    signal excp_req_lvl_1_sig : std_logic_vector( 3 downto 0); -- Exception Request Level (0000 - 1111)
    signal excp_req_lvl_2_sig : std_logic_vector( 3 downto 0); -- Exception Request Level (0000 - 1111)
    signal excp_req_lvl_3_sig : std_logic_vector( 3 downto 0); -- Exception Request Level (0000 - 1111)

    signal irl_reg            : std_logic_vector( 3 downto 0); -- Interrupt Request Level Register
    signal erl_reg            : std_logic_vector( 3 downto 0); -- Exception Request Level Register

    signal excp_addr_sig      : std_logic_vector(29 downto 0);
    signal intr_addr_sig      : std_logic_vector(29 downto 0);
    signal rett_addr_sig      : std_logic_vector(29 downto 0);

    signal intr_vec_addr_reg  : std_logic_vector(29 downto 0); -- Interrupt Vector Address Register

    signal intr_inst_sig      : std_logic_vector( 2 downto 0);
    signal intr_stat_reg      : std_logic_vector( 2 downto 0); -- Interrupt Controller State Register
    signal intr_start_reg     : std_logic; -- Interrupt Start Signal
    signal intr_end_reg       : std_logic; -- Interrupt End Signal

    constant INTR_STAT_STR    : std_logic_vector( 2 downto 0) := "000";
    constant INTR_STAT_1      : std_logic_vector( 2 downto 0) := "001";
    constant INTR_STAT_2      : std_logic_vector( 2 downto 0) := "011";
    constant INTR_STAT_3      : std_logic_vector( 2 downto 0) := "111";
    constant INTR_STAT_4      : std_logic_vector( 2 downto 0) := "110";
    constant INTR_STAT_END    : std_logic_vector( 2 downto 0) := "100";

begin

    intr_req_sig <= iuintr_intr_in;
    excp_req_sig <= iuintr_excep_req_in( 0) or iuintr_excep_req_in( 1)
                 or iuintr_excep_req_in( 2) or iuintr_excep_req_in( 3)
                 or iuintr_excep_req_in( 4) or iuintr_excep_req_in( 5)
                 or iuintr_excep_req_in( 6) or iuintr_excep_req_in( 7)
                 or iuintr_excep_req_in( 8) or iuintr_excep_req_in( 9)
                 or iuintr_excep_req_in(10) or iuintr_excep_req_in(11)
                 or iuintr_excep_req_in(12) or iuintr_excep_req_in(13)
                 or iuintr_excep_req_in(14) or iuintr_excep_req_in(15);

    intr_req_lvl_sig <= iuintr_irl_in;
    excp_req_lvl_sig <= excp_req_lvl_0_sig when ((iuintr_excep_req_in( 0) = '1')
                                              or (iuintr_excep_req_in( 1) = '1')
                                              or (iuintr_excep_req_in( 2) = '1')
                                              or (iuintr_excep_req_in( 3) = '1')) else
                        excp_req_lvl_1_sig when ((iuintr_excep_req_in( 4) = '1')
                                              or (iuintr_excep_req_in( 5) = '1')
                                              or (iuintr_excep_req_in( 6) = '1')
                                              or (iuintr_excep_req_in( 7) = '1')) else
                        excp_req_lvl_2_sig when ((iuintr_excep_req_in( 8) = '1')
                                              or (iuintr_excep_req_in( 9) = '1')
                                              or (iuintr_excep_req_in(10) = '1')
                                              or (iuintr_excep_req_in(11) = '1')) else
                        excp_req_lvl_3_sig;

    excp_req_lvl_0_sig <= "0000" when iuintr_excep_req_in( 0) = '1' else
                          "0001" when iuintr_excep_req_in( 1) = '1' else
                          "0010" when iuintr_excep_req_in( 2) = '1' else
                          "0011";

    excp_req_lvl_1_sig <= "0100" when iuintr_excep_req_in( 4) = '1' else
                          "0101" when iuintr_excep_req_in( 5) = '1' else
                          "0110" when iuintr_excep_req_in( 6) = '1' else
                          "0111";

    excp_req_lvl_2_sig <= "1000" when iuintr_excep_req_in( 8) = '1' else
                          "1001" when iuintr_excep_req_in( 9) = '1' else
                          "1010" when iuintr_excep_req_in(10) = '1' else
                          "1011";

    excp_req_lvl_3_sig <= "1100" when iuintr_excep_req_in(12) = '1' else
                          "1101" when iuintr_excep_req_in(13) = '1' else
                          "1110" when iuintr_excep_req_in(14) = '1' else
                          "1111";

    IU_Exception_Request_Level_Register : process (
        iuintr_clk_in,
        iuintr_rst_in,
        excp_req_reg,
        excp_req_sig,
        excp_req_lvl_sig
    )
    begin
        if (iuintr_clk_in'event and iuintr_clk_in = '1') then
            if (iuintr_rst_in = '1') then
                erl_reg <= (others => '0');
            else
                if ((excp_req_reg = '0')
                and (excp_req_sig = '1')) then
                    erl_reg <= excp_req_lvl_sig;
                end if;
            end if;
        end if;
    end process IU_Exception_Request_Level_Register;

    IU_Interrupt_Request_Level_Register : process (
        iuintr_clk_in,
        iuintr_rst_in,
        iuintr_dis_in,
        iuintr_pil_in,
        intr_req_reg,
        intr_req_sig,
        intr_req_lvl_sig
    )
    begin
        if (iuintr_clk_in'event and iuintr_clk_in = '1') then
            if ( iuintr_rst_in = '1') then
                irl_reg <= (others => '0');
            else
                if ((intr_req_reg  = '0')
                and (intr_req_sig  = '1')
                and (iuintr_dis_in = '0')
                and (iuintr_pil_in = "1111" or iuintr_pil_in > intr_req_lvl_sig)) then
                    irl_reg <= intr_req_lvl_sig;
                end if;
            end if;
        end if;
    end process IU_Interrupt_Request_Level_Register;

    IU_Interrupt_Request_Controller : process (
        iuintr_clk_in,
        iuintr_rst_in,
        iuintr_rett_req_in,
        intr_req_sig,
        excp_req_sig
    )
    begin
        if (iuintr_clk_in'event and iuintr_clk_in = '1') then
            if (iuintr_rst_in = '1') then
                intr_start_reg <= '0';
                intr_end_reg   <= '0';
                rett_req_reg   <= '0';
                excp_req_reg   <= '0';
                intr_req_reg   <= '0';
            else
                if    (intr_end_reg = '1') then
                    intr_start_reg <= '0';
                    intr_end_reg   <= '0';
                    intr_req_reg   <= '0';
                    excp_req_reg   <= '0';
                    rett_req_reg   <= '0';
                -- RETT Instruction
                elsif ((intr_req_reg       = '0')
                   and (iuintr_rett_req_in = '1')) then
                    intr_start_reg <= '1';
                    intr_end_reg   <= '0';
                    intr_req_reg   <= '1';
                    excp_req_reg   <= '0';
                    rett_req_reg   <= '1';
                -- Exception
                elsif ((excp_req_reg = '0')
                   and (excp_req_sig = '1')) then
                    intr_start_reg <= '1';
                    intr_end_reg   <= '0';
                    intr_req_reg   <= '1';
                    excp_req_reg   <= '1';
                    rett_req_reg   <= '0';
                -- Interrupt
                elsif ((intr_req_reg  = '0')
                   and (intr_req_sig  = '1')
                   and (iuintr_dis_in = '0')
                   and (iuintr_pil_in = "1111" or iuintr_pil_in > intr_req_lvl_sig)) then
                    intr_start_reg <= '1';
                    intr_end_reg   <= '0';
                    intr_req_reg   <= '1';
                    excp_req_reg   <= '0';
                    rett_req_reg   <= '0';
                else
                    intr_start_reg <= '0';
                    if (intr_stat_reg = INTR_STAT_4) then
                        intr_end_reg   <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process IU_Interrupt_Request_Controller;

    intr_vec_we_sig <= intr_start_reg and (not rett_req_reg);
    rett_vec_we_sig <= iuintr_rett_we_in;

    excp_addr_sig <= X"00000" & "000" & "0" & erl_reg & "00";
    intr_addr_sig <= X"00000" & "000" & "1" & irl_reg & "00";
    rett_addr_sig <= iuintr_rett_addr_in;

    IU_Interrupt_Interrupt_Vector_Table : process (
        iuintr_clk_in,
        iuintr_rst_in,
        excp_addr_sig,
        intr_addr_sig
    )
    begin
        if (iuintr_clk_in'event and iuintr_clk_in = '1') then
            if    (intr_vec_we_sig = '1') then
                if (excp_req_reg  = '1') then
                    intr_vec_addr_reg <= excp_addr_sig;
                else
                    intr_vec_addr_reg <= intr_addr_sig;
                end if;
            elsif (rett_vec_we_sig = '1') then
                    intr_vec_addr_reg <= rett_addr_sig;
            end if;
        end if;
    end process IU_Interrupt_Interrupt_Vector_Table;

    IU_Interrupt_Instruction_State_Counter : process (
        iuintr_clk_in,
        iuintr_rst_in,
        intr_req_reg,
        intr_stat_reg
    )
    begin

        --       : interrupt (external)         |       : rett       ld  %pc,  %sp, +4
        -- <000> : start                        | <000> : start
        -- <001> : "0" & "00" add %sp,  %sp, -8 | <001> : "0" & "00" ld  %psr, %sp, +0
        -- <011> : "0" & "01" st  %psr, %sp, +0 | <011> : "0" & "01" add %sp,  %sp, +8
        -- <111> : "0" & "10" st  %pc,  %sp, +4 | <111> : "0" & "10" nop
        -- <110> : "0" & "11" di                | <110> : "0" & "11" nop
        -- <100> : end                          | <100> : end

        if (iuintr_clk_in'event and iuintr_clk_in = '1') then
            if (intr_req_reg = '0') then
                intr_stat_reg <= INTR_STAT_STR;
            else
                case intr_stat_reg is
                    when INTR_STAT_STR => intr_stat_reg <= INTR_STAT_1;
                    when INTR_STAT_1   => intr_stat_reg <= INTR_STAT_2;
                    when INTR_STAT_2   => intr_stat_reg <= INTR_STAT_3;
                    when INTR_STAT_3   => intr_stat_reg <= INTR_STAT_4;
                    when INTR_STAT_4   => intr_stat_reg <= INTR_STAT_END;
                    when INTR_STAT_END => intr_stat_reg <= INTR_STAT_STR;
                    when others        => intr_stat_reg <= INTR_STAT_STR;
                end case;
            end if;
        end if;
    end process IU_Interrupt_Instruction_State_Counter;

    with intr_stat_reg select
    intr_inst_sig <= "000" when INTR_STAT_STR,
                     "001" when INTR_STAT_1,
                     "010" when INTR_STAT_2,
                     "011" when INTR_STAT_3,
                     "100" when INTR_STAT_4,
                     "101" when INTR_STAT_END,
                     "000" when others;

    iuintr_vec_we_out    <= intr_end_reg;
    iuintr_vec_addr_out  <= intr_vec_addr_reg;

    iuintr_intr_req_out  <= intr_req_reg;
    iuintr_intr_ack_out  <= intr_end_reg and rett_req_reg;

    -- !  8  |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
    -- +-----+-----+-----+-----+-----+-----+-----+-----+-----+
    -- |          irl          | excp| rett|       inst      |
    iuintr_intr_inst_out <= X"00000" & "000" &
                            irl_reg & excp_req_reg & rett_req_reg & intr_inst_sig;

end rtl;
