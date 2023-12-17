library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cmtcks_pac.all;
use work.cmt_pac.all;

entity cmt is
    port (
        cmt_cs_in   : in    std_logic;
        cmt_clk_in  : in    std_logic;
        cmt_rst_in  : in    std_logic;
        cmt_we_in   : in    std_logic;
        cmt_addr_in : in    std_logic_vector( 1 downto 0);
        cmt_di_in   : in    std_logic_vector(15 downto 0);
        cmt_do_out  :   out std_logic_vector(15 downto 0);
        cmt_cmi_out :   out std_logic
    );
end cmt;

architecture rtl of cmt is

    signal cmtcks_clk_sig : std_logic;
    signal clko_reg    : std_logic;
    signal compare_reg : std_logic;

    -- bit0 : Start Timer
    -- 0: Stop. 1: Start
    signal str_reg   : std_logic;
    -- bit3 : Compare Match Interrupt Enable
    -- 0: Disable, 1: Enable
    signal cmie_reg  : std_logic;
    -- bit1 - bit0 : Clock Select
    -- 0: 1/8, 1: 1/32, 2: 1/128, 3: 1/512
    signal cks_reg   : std_logic_vector ( 1 downto 0);
    -- bit0 : Compare Flag
    signal cmf_reg   : std_logic;
    -- bit15 - bit0 : Counter
    signal cnt_reg   : std_logic_vector (15 downto 0);
    -- bit15 - bit0 : Comaper Counter
    signal const_reg : std_logic_vector (15 downto 0);

    signal cmt_we_sig   : std_logic;
    signal cmt_addr_sig : std_logic_vector ( 1 downto 0);
    signal cmt_di_sig   : std_logic_vector (15 downto 0);

begin

    cmt_we_sig   <= cmt_we_in   and cmt_cs_in;
    cmt_addr_sig <= cmt_addr_in and ( 1 downto 0 => cmt_cs_in);
    cmt_di_sig   <= cmt_di_in   and (15 downto 0 => cmt_cs_in);

    CMT_Clock_Select : cmtcks
    port map (
        cmtcks_cs_in   => str_reg,
        cmtcks_clk_in  => cmt_clk_in,
        cmtcks_rst_in  => cmt_rst_in,
        cmtcks_cks_in  => cks_reg,
        cmtcks_clk_out => cmtcks_clk_sig
    );

    process (
        cmt_cs_in,
        cmt_clk_in,
        cmt_rst_in
    )
    begin
        if (cmt_clk_in'event and cmt_clk_in = '1') then
            if (cmt_rst_in = '1') then
                compare_reg  <= '0';
                cnt_reg      <= (others => '0');
                clko_reg     <= cmtcks_clk_sig;
            else
                if (str_reg = '1') then
                    if ((cmtcks_clk_sig = '1')
                    and (clko_reg       = '0')) then
                        if (cnt_reg = const_reg) then
                            compare_reg <= '1';
                            cnt_reg     <= (others => '0');
                        else
                            compare_reg <= '0';
                            cnt_reg     <= std_logic_vector(unsigned(cnt_reg) + 1);
                        end if;
                    else
                        compare_reg <= '0';
                    end if;
                    clko_reg <= cmtcks_clk_sig;
                end if;
            end if;
        end if;
    end process;

    process (
        cmt_cs_in,
        cmt_clk_in,
        cmt_rst_in,
        cmt_we_sig,
        cmt_addr_sig,
        cmt_di_sig
    )
    begin
        if (cmt_clk_in'event and cmt_clk_in = '1') then
            if (cmt_rst_in = '1') then
                str_reg   <= '0';
                cmie_reg  <= '0';
                cks_reg   <= (others => '0');
                cmf_reg   <= '0';
                const_reg <= (others => '0');
            else
                if ((cmt_cs_in   = '1' )
                and (cmt_we_sig  = '1' )) then
                    if (cmt_addr_sig = "00") then
                        str_reg   <= cmt_di_sig (0);
                    end if;
                    if (cmt_addr_sig = "01") then
                        cmie_reg  <= cmt_di_sig (2);
                        cks_reg   <= cmt_di_sig (1 downto 0);
                    end if;
                    if (cmt_addr_sig = "10") then
                        cmf_reg   <= cmt_di_sig (0);
                    end if;
                    if (cmt_addr_sig = "11") then
                        const_reg <= cmt_di_sig;
                    end if;
                end if;

                if (compare_reg = '1') then
                    cmf_reg   <= compare_reg;
                end if;
            end if;
        end if;
    end process;

    with cmt_addr_sig select
    cmt_do_out  <= X"000" & "000" & str_reg             when "00",
                   X"000" & "0"   & cmie_reg & cks_reg  when "01",
                   X"000" & "000" & cmf_reg             when "10",
                   const_reg                            when others;

    cmt_cmi_out <= cmf_reg and cmie_reg;

end rtl;
