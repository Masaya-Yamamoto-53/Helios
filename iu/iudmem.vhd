library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iudmem is
    port (
        iudmem_cs_in   : in    std_logic;
        iudmem_clk_in  : in    std_logic;
        iudmem_we_in   : in    std_logic;
        iudmem_dqm_in  : in    std_logic_vector ( 3 downto 0);
        iudmem_addr_in : in    std_logic_vector ( 7 downto 0);
        iudmem_di_in   : in    std_logic_vector (31 downto 0);
        iudmem_do_out  :   out std_logic_vector (31 downto 0)
    );
end iudmem;

architecture rtl of iudmem is

    subtype dword_t is std_logic_vector ( 7 downto 0);
    type ram_t is array (0 to 255) of dword_t;

    signal ram0_reg : ram_t;
    signal ram1_reg : ram_t;
    signal ram2_reg : ram_t;
    signal ram3_reg : ram_t;

    signal iudmem_we_sig   : std_logic;
    signal iudmem_dqm_sig  : std_logic_vector ( 3 downto 0);
    signal iudmem_addr_sig : std_logic_vector ( 7 downto 0);
    signal iudmem_di_sig   : std_logic_vector (31 downto 0);

    signal do_sig : std_logic_vector (31 downto 0);

begin

    iudmem_we_sig   <= iudmem_we_in   and iudmem_cs_in;
    iudmem_dqm_sig  <= iudmem_dqm_in  and ( 3 downto 0 => iudmem_cs_in);
    iudmem_addr_sig <= iudmem_addr_in and ( 7 downto 0 => iudmem_cs_in);
    iudmem_di_sig   <= iudmem_di_in   and (31 downto 0 => iudmem_cs_in);

    process (
        iudmem_cs_in,
        iudmem_clk_in,
        iudmem_we_sig,
        iudmem_dqm_sig,
        iudmem_addr_sig,
        iudmem_di_sig
    )
    begin
        if (iudmem_clk_in'event and iudmem_clk_in = '1') then
            if (iudmem_we_sig = '1') then
                if (iudmem_dqm_sig(0) = '1') then
                    ram3_reg (to_integer(unsigned(iudmem_addr_sig))) <= iudmem_di_sig( 7 downto  0);
                end if;
                if (iudmem_dqm_sig(1) = '1') then
                    ram2_reg (to_integer(unsigned(iudmem_addr_sig))) <= iudmem_di_sig(15 downto  8);
                end if;
                if (iudmem_dqm_sig(2) = '1') then
                    ram1_reg (to_integer(unsigned(iudmem_addr_sig))) <= iudmem_di_sig(23 downto 16);
                end if;
                if (iudmem_dqm_sig(3) = '1') then
                    ram0_reg (to_integer(unsigned(iudmem_addr_sig))) <= iudmem_di_sig(31 downto 24);
                end if;
            end if;
        end if;
    end process;

    do_sig( 7 downto  0) <= ram3_reg(to_integer(unsigned(iudmem_addr_sig)));
    do_sig(15 downto  8) <= ram2_reg(to_integer(unsigned(iudmem_addr_sig)));
    do_sig(23 downto 16) <= ram1_reg(to_integer(unsigned(iudmem_addr_sig)));
    do_sig(31 downto 24) <= ram0_reg(to_integer(unsigned(iudmem_addr_sig)));

    iudmem_do_out <= do_sig and (31 downto 0 => iudmem_cs_in);

end rtl;
