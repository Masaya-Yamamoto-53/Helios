----------------------------------------------------------------------------------
-- Create Date    :
-- Design Name    :
-- Module Name    : segdisp - RTL
-- Target Devices : OSL20541-IR
-- Description    : 
--
-- OSL20541-IR
--
--         DIG.1                  DIG.2
--    _______________        _______________
--   / \_____A_____/ \      / \_____A_____/ \
--   | ||\  / \  /|| |      | ||\  / \  /|| |
--   | || \ | | / || |      | || \ | | / || |
--   |F|\H \|J|/ K/|B|      |F|\H \|J|/ K/|B|
--   | | \ || || / | |      | | \ || || / | |
--   | |__\|| ||/__| |      | |__\|| ||/__| |
--   \ /    \ /    \ /      \ /    \ /    \ /
--   / \_G1_/ \_G2_/ \      / \_G1_/ \_G2_/ \
--   | |  /|| ||\  | |      | |  /|| ||\  | |
--   | | / || || \ | |      | | / || || \ | |
--   |E|/N /|M|\ L\|C|      |E|/N /|M|\ L\|C|
--   | || / | | \ || |      | || / | | \ || |
--   | ||/__\ /__\|| |      | ||/__\ /__\|| |
--   \_/_____D_____\_/ (DP) \_/_____D_____\_/ (DP)
--   
-- Dependencies   : 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.segdisp_pac.all;
use work.segdispcks_pac.all;

entity segdisp is
    port (
        segdisp_clk_in      : in    std_logic;
        segdisp_rst_in      : in    std_logic;
        segdisp_cs_in       : in    std_logic;
        segdisp_we_in       : in    std_logic;
        segdisp_addr_in     : in    std_logic_vector( 1 downto 0);
        segdisp_di_in       : in    std_logic_vector(15 downto 0);
        segdisp_do_out      :   out std_logic_vector(15 downto 0);
        segdisp_seg_do_out  :   out std_logic_vector(14 downto 0); -- |14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
                                                                   -- +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
                                                                   -- | A| B| C| D| E| F|G1|G2| H| J| K| L| M| N|DP| 

        segdisp_seg_sel_out :   out std_logic_vector( 1 downto 0)  -- 1bit: DIG.1, 0bit: DIG.2
    );
end segdisp;

architecture rtl of segdisp is

    signal segdisp_clk_sig   : std_logic; -- Internal Clock
    signal segdisp_clk_o_sig : std_logic; -- Internal Clock (Pre)

    signal sel_reg      : std_logic;                     -- Digit Selection Register
    signal disp_out_sig : std_logic_vector(14 downto 0); -- 14 Segment Display Output Signal

    -----------------------------------------------------------
    -- Segment Display Mode Register (SDMR)                  --
    -----------------------------------------------------------
    signal sdmr_sig     : std_logic_vector(15 downto 0);
    signal cks_reg      : std_logic_vector( 1 downto 0); -- 00: PΦ, 01: PΦ/4, 10: PΦ/16, 11: PΦ/32
    signal ac_reg       : std_logic;                     -- 0: Anode, 1: Cathode
    signal en_reg       : std_logic;                     -- 0: Device Disable, 1: Device Enable

    -----------------------------------------------------------
    -- Segment Display Compare Register (SDCR)               --
    -----------------------------------------------------------
    signal sdcr_sig     : std_logic_vector(15 downto 0);
    signal compare_reg  : std_logic_vector(15 downto 0); -- Compare Timer Register
    signal count_reg    : std_logic_vector(15 downto 0); -- Timer Counter Register

    -----------------------------------------------------------
    -- Segment Display Data Register (SDDR)                  --
    -----------------------------------------------------------
    signal sddr_sig     : std_logic_vector( 7 downto 0);
    signal data_reg     : std_logic_vector(15 downto 0); -- Data

begin

    -----------------------------------------------------------
    -- Segment Display Clock Selector                        --
    -----------------------------------------------------------
    Segment_Display_Clock_Selector : segdispcks
    port map (
        segdispcks_cs_in   => en_reg,
        segdispcks_clk_in  => segdisp_clk_in,
        segdispcks_rst_in  => segdisp_rst_in,
        segdispcks_cks_in  => cks_reg,
        segdispcks_clk_out => segdisp_clk_sig
    );

    -----------------------------------------------------------
    -- Segment Display Mode Register (SDMR)                  --
    -----------------------------------------------------------
    sdmr_sig <= X"000" & en_reg & ac_reg & cks_reg;

    Segment_Display_Mode_Register : process (
        segdisp_clk_in,
        segdisp_rst_in,
        segdisp_cs_in,
        segdisp_we_in,
        segdisp_addr_in,
        segdisp_di_in
    )
    begin
        if (segdisp_clk_in'event and segdisp_clk_in = '1') then
            if (segdisp_rst_in = '1') then
                cks_reg <= (others => '0');
                ac_reg  <= '0';
                en_reg  <= '0';
            else
                if ((segdisp_cs_in   = '1')
                and (segdisp_we_in   = '1')
                and (segdisp_addr_in = "00")) then
                    cks_reg <= segdisp_di_in(1 downto 0);
                    ac_reg  <= segdisp_di_in(2);
                    en_reg  <= segdisp_di_in(3);
                end if;
            end if;
        end if;
    end process Segment_Display_Mode_Register;

    -----------------------------------------------------------
    -- Segment Display Compare Register (SDCR)               --
    -----------------------------------------------------------
    sdcr_sig <= compare_reg;

    Segment_Display_Compare_Register : process (
        segdisp_clk_in,
        segdisp_rst_in,
        segdisp_cs_in,
        segdisp_we_in,
        segdisp_addr_in,
        segdisp_di_in
    ) begin
        if (segdisp_clk_in'event and segdisp_clk_in = '1') then
            if (segdisp_rst_in = '1') then
                compare_reg   <= (others => '0');
            else
                if ((segdisp_cs_in   = '1')
                and (segdisp_we_in   = '1')
                and (segdisp_addr_in = "01")) then
                    compare_reg <= segdisp_di_in(15 downto 0);
                end if;
            end if;
        end if;
    end process Segment_Display_Compare_Register;

    -----------------------------------------------------------
    -- Segment Display Data Register (SDDR)                  --
    -----------------------------------------------------------
    sddr_sig <= data_reg(15 downto 8) when sel_reg = '1' else
                data_reg( 7 downto 0);

    Segment_Display_Data_Register : process (
        segdisp_clk_in,
        segdisp_rst_in,
        segdisp_cs_in,
        segdisp_we_in,
        segdisp_addr_in,
        segdisp_di_in
    ) begin
        if (segdisp_clk_in'event and segdisp_clk_in = '1') then
            if (segdisp_rst_in = '1') then
                data_reg <= (others => '0');
            else
                if ((segdisp_cs_in   = '1')
                and (segdisp_we_in   = '1')
                and (segdisp_addr_in = "10")) then
                    data_reg <= segdisp_di_in(15 downto 0);
                end if;
            end if;
        end if;
    end process Segment_Display_Data_Register;

    -----------------------------------------------------------
    -- Segment Display Counter Register                      --
    -----------------------------------------------------------
    Segment_Display_Counter_Register : process (
        segdisp_clk_in,
        segdisp_rst_in,
        compare_reg,
        count_reg
    ) begin
        if (segdisp_clk_in'event and segdisp_clk_in = '1') then
            if ((segdisp_rst_in = '1')
             or (en_reg = '0'          )) then
                count_reg <= (others => '0');
                sel_reg   <= '0';
            elsif (segdisp_clk_sig = '1' and segdisp_clk_o_sig = '0') then
                if (count_reg = compare_reg) then
                    count_reg <= (others => '0');
                    sel_reg   <= not sel_reg;
                else
                    count_reg <= std_logic_vector(unsigned(count_reg) + 1);
                    sel_reg   <= sel_reg;
                end if;
            end if;
            segdisp_clk_o_sig <= segdisp_clk_sig;
        end if;
    end process Segment_Display_Counter_Register;

    -----------------------------------------------------------
    -- Segment Display Decoder                               --
    -----------------------------------------------------------
    Segment_Display_Decoder : process (
        sddr_sig
    ) begin
        case sddr_sig is                          -- ABCDEFGGHJKLMND
                                                  --       12      P
            when         X"30"   => disp_out_sig <= "000000111101101"; -- 0
            when         X"31"   => disp_out_sig <= "100111111111111"; -- 1
            when         X"32"   => disp_out_sig <= "001001001111111"; -- 2
            when         X"33"   => disp_out_sig <= "000011001111111"; -- 3
            when         X"34"   => disp_out_sig <= "100110001111111"; -- 4
            when         X"35"   => disp_out_sig <= "010010001111111"; -- 5
            when         X"36"   => disp_out_sig <= "010000001111111"; -- 6
            when         X"37"   => disp_out_sig <= "000111111111111"; -- 7
            when         X"38"   => disp_out_sig <= "000000001111111"; -- 8
            when         X"39"   => disp_out_sig <= "000010001111111"; -- 9
            when X"41" | X"61"   => disp_out_sig <= "000100001111111"; -- A
            when X"42" | X"62"   => disp_out_sig <= "000011101011011"; -- B
            when X"43" | X"63"   => disp_out_sig <= "011000111111111"; -- C
            when X"44" | X"64"   => disp_out_sig <= "000011111011011"; -- D
            when X"45" | X"65"   => disp_out_sig <= "011000001111111"; -- E
            when X"46" | X"66"   => disp_out_sig <= "011100001111111"; -- F
            when X"47" | X"67"   => disp_out_sig <= "010000101111111"; -- G
            when X"48" | X"68"   => disp_out_sig <= "100100001111111"; -- H
            when X"49" | X"69"   => disp_out_sig <= "011011111011011"; -- I
            when X"4a" | X"6a"   => disp_out_sig <= "100001111111111"; -- J
            when X"4b" | X"6b"   => disp_out_sig <= "111100011100111"; -- K
            when X"4c" | X"6c"   => disp_out_sig <= "111000111111111"; -- L
            when X"4d" | X"6d"   => disp_out_sig <= "100100110101111"; -- M
            when X"4e" | X"6e"   => disp_out_sig <= "100100110110111"; -- N
            when X"4f" | X"6f"   => disp_out_sig <= "000000111111111"; -- O
            when X"50" | X"70"   => disp_out_sig <= "001100001111111"; -- P
            when X"51" | X"71"   => disp_out_sig <= "000000111110111"; -- Q
            when X"52" | X"72"   => disp_out_sig <= "001100001110111"; -- R
            when X"53" | X"73"   => disp_out_sig <= "010010001111111"; -- S
            when X"54" | X"74"   => disp_out_sig <= "011111111011011"; -- T
            when X"55" | X"75"   => disp_out_sig <= "100000111111111"; -- U
            when X"56" | X"76"   => disp_out_sig <= "111100111101101"; -- V
            when X"57" | X"77"   => disp_out_sig <= "100100111010101"; -- W
            when X"58" | X"78"   => disp_out_sig <= "111111110100101"; -- X
            when X"59" | X"79"   => disp_out_sig <= "111111110101011"; -- Y
            when X"5a" | X"7a"   => disp_out_sig <= "011011111101101"; -- Z
            when others          => disp_out_sig <= "111111001111111"; -- "--"
        end case;
    end process Segment_Display_Decoder;

    segdisp_do_out      <= sdmr_sig when segdisp_addr_in = "00" else
                           sdcr_sig when segdisp_addr_in = "01" else
                           data_reg;

    segdisp_seg_do_out  <=     disp_out_sig when ac_reg = '0' else
                           not disp_out_sig;

    segdisp_seg_sel_out <= sel_reg & (not sel_reg);

end rtl;
