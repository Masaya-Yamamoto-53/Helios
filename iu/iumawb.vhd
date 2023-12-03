library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.iumawb_pac.all;

entity iumawb is
    port (
        iumawb_clk_in   : in    std_logic;
        iumawb_rst_in   : in    std_logic;
        iumawb_wen_in   : in    std_logic;
        iumawb_flash_in : in    std_Logic;
        iumawb_di_in    : in    st_iumawb_if;
        iumawb_do_out   :   out st_iumawb_if
    );
end iumawb;

architecture rtl of iumawb is

    signal iumawb_reg : st_iumawb_if := st_iumawb_if_INIT;

begin

    MAWB_Pipeline_Register_Rst : process (
        iumawb_clk_in,
        iumawb_rst_in,
        iumawb_wen_in,
        iumawb_flash_in,
        iumawb_di_in
    )
    begin
        if (iumawb_clk_in'event and iumawb_clk_in = '1') then
            if ((iumawb_rst_in   = '1')
             or (iumawb_flash_in = '1')) then
                iumawb_reg.rd_we <= st_iumawb_if_INIT.rd_we;
            else
                if (iumawb_wen_in = '0') then
                    iumawb_reg.rd_we <= iumawb_di_in.rd_we;
                end if;
            end if;
        end if;
    end process MAWB_Pipeline_Register_Rst;

    MAWB_Pipeline_Register_NonRst : process (
        iumawb_clk_in,
        iumawb_wen_in,
        iumawb_di_in
    )
    begin
        if (iumawb_clk_in'event and iumawb_clk_in = '1') then
            if (iumawb_wen_in = '0') then
                iumawb_reg.rd_sel  <= iumawb_di_in.rd_sel;
                iumawb_reg.rd_data <= iumawb_di_in.rd_data;
            end if;
        end if;
    end process MAWB_Pipeline_Register_NonRst;

    iumawb_do_out <= iumawb_reg;

end rtl;
