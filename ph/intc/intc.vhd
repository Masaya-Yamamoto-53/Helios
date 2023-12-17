library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.intc_pac.all;

entity intc is
    port (
        intc_clk_in  : in    std_logic;
        intc_rst_in  : in    std_logic;
        intc_inta_in : in    std_logic;
        intc_irq_in  : in    std_logic_vector(15 downto 0);
        intc_int_out :   out std_logic;
        intc_irl_out :   out std_logic_vector( 3 downto 0);

        intc_cs_in   : in    std_logic;
        intc_we_in   : in    std_logic;
        intc_addr_in : in    std_logic_vector( 1 downto 0);
        intc_di_in   : in    std_logic_vector(15 downto 0);
        intc_do_out  :   out std_logic_vector(15 downto 0)
    );
end intc;

architecture rtl of intc is

    signal irq_reg : std_logic_vector(15 downto 0);

    signal isr_reg : std_logic_vector(15 downto 0);
    signal ipr_sig : std_logic_vector(15 downto 0);
    signal ier_reg : std_logic_vector(15 downto 0);

    signal intc_do_sig   : std_logic_vector(15 downto 0);
    signal intc_int_sig  : std_logic_vector(15 downto 0);
    signal intc_irl_sig  : integer range 0 to 15;

    signal intc_we_sig   : std_logic;
    signal intc_addr_sig : std_logic_vector( 1 downto 0);
    signal intc_di_sig   : std_logic_vector(15 downto 0);

    constant INTC_ISR_ADDR : std_logic_vector(1 downto 0) := "00";
    constant INTC_IPR_ADDR : std_logic_vector(1 downto 0) := "01";
    constant INTC_IER_ADDR : std_logic_vector(1 downto 0) := "10";

begin

    intc_we_sig   <= intc_we_in   when intc_cs_in = '1' else '0';
    intc_addr_sig <= intc_addr_in when intc_cs_in = '1' else (others => '0');
    intc_di_sig   <= intc_di_in   when intc_cs_in = '1' else (others => '0');

    ipr_sig <= isr_reg and ier_reg;
    intc_do_sig <= isr_reg when intc_addr_sig = INTC_ISR_ADDR else
                   ipr_sig when intc_addr_sig = INTC_IPR_ADDR else
                   ier_reg when intc_addr_sig = INTC_IER_ADDR else
                   (others => '0');

    intc_do_out <= intc_do_sig when intc_cs_in = '1' else
                   (others => '0');

    Interrupt_Status_Register : process (
        intc_clk_in,
        intc_rst_in,
        intc_irq_in
    )
    begin
        if (intc_clk_in'event and intc_clk_in = '1') then
            if (intc_rst_in = '1') then
                irq_reg <= (others => '0');
                isr_reg <= (others => '0');
            else
                irq_reg <= intc_irq_in;

                for I in 0 to 15 loop
                    if    ((intc_inta_in  = '1')
                       and (intc_irl_sig  =  I )) then
                        isr_reg(I) <= '0';
                    elsif (((intc_irq_in(I) = '1')
                        and (irq_reg(I) = '0')
                        and (C_KIND_OF_INTR(I) = '1'))
                        or ((intc_irq_in(I) = '1')
                        and (C_KIND_OF_INTR(I) = '0'))) then
                        isr_reg(I) <= '1';
                    end if;
                end loop;
            end if;
        end if;
    end process Interrupt_Status_Register;

    Interrupt_Enable_Register : process (
        intc_clk_in,
        intc_rst_in,
        intc_irq_in
    )
    begin
        if (intc_clk_in'event and intc_clk_in = '1') then
            if (intc_rst_in = '1') then
                ier_reg <= (others => '0');
            else
                if ((intc_we_sig   = '1'          )
                and (intc_addr_sig = INTC_IER_ADDR)) then
                    ier_reg <= intc_di_sig;
                end if;
            end if;
        end if;
    end process Interrupt_Enable_Register;

    intc_int_out <= '1'when ((ipr_sig( 0) = '1')
                          or (ipr_sig( 1) = '1')
                          or (ipr_sig( 2) = '1')
                          or (ipr_sig( 3) = '1')
                          or (ipr_sig( 4) = '1')
                          or (ipr_sig( 5) = '1')
                          or (ipr_sig( 6) = '1')
                          or (ipr_sig( 7) = '1')
                          or (ipr_sig( 8) = '1')
                          or (ipr_sig( 9) = '1')
                          or (ipr_sig(10) = '1')
                          or (ipr_sig(11) = '1')
                          or (ipr_sig(12) = '1')
                          or (ipr_sig(13) = '1')
                          or (ipr_sig(14) = '1')
                          or (ipr_sig(15) = '1')) else
                    '0';

    intc_irl_sig <=  0 when ipr_sig( 0) = '1' else
                     1 when ipr_sig( 1) = '1' else
                     2 when ipr_sig( 2) = '1' else
                     3 when ipr_sig( 3) = '1' else
                     4 when ipr_sig( 4) = '1' else
                     5 when ipr_sig( 5) = '1' else
                     6 when ipr_sig( 6) = '1' else
                     7 when ipr_sig( 7) = '1' else
                     8 when ipr_sig( 8) = '1' else
                     9 when ipr_sig( 9) = '1' else
                    10 when ipr_sig(10) = '1' else
                    11 when ipr_sig(11) = '1' else
                    12 when ipr_sig(12) = '1' else
                    13 when ipr_sig(13) = '1' else
                    14 when ipr_sig(14) = '1' else
                    15 when ipr_sig(15) = '1' else
                     0;

    intc_irl_out <= std_logic_vector(to_unsigned(intc_irl_sig, 4));

end rtl;
