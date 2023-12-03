library ieee;
use ieee.std_logic_1164.all;

use work.iu_pac.all;

package iuexma_pac is

    type st_iuexma_if is
    record
        mul_cs    : std_logic;

        rd_we     : std_logic;
        rd_sel    : std_logic_vector( 4 downto 0);
        rd_data   : std_logic_vector(31 downto 0);

        psr_read  : std_logic;
        s_we      : std_logic;
        et_we     : std_logic;
        pil_we    : std_logic;

        intr_req  : std_logic;

        branch    : std_logic;
        pc        : std_logic_vector(29 downto 0);
        rett      : std_logic;

        mem_read  : std_logic;
        mem_write : std_logic;
        mem_sign  : std_logic;
        mem_type  : std_logic_vector( 1 downto 0);
        mem_data  : std_logic_vector(31 downto 0);

        inst_a    : std_logic;
    end record;
    constant st_iuexma_if_INIT : st_iuexma_if := (
        '0',               -- mul_cs
        '0',               -- rd_we
        (others => '0'),   -- rd_sel
        (others => '0'),   -- rd_data
        '0',               -- psr_read
        '0',               -- s_we
        '0',               -- et_we
        '0',               -- pil_we
        '0',               -- intr_req
        '0',               -- branch
        (others => '0'),   -- pc
        '0',               -- rett
        '0',               -- mem_read
        '0',               -- mem_write
        '0',               -- mem_sign
        (others => '0'),   -- mem_type
        (others => '0'),   -- mem_data
        '0'                -- inst_a
    );

    component iuexma
        port (
            iuexma_clk_in   : in    std_logic;
            iuexma_rst_in   : in    std_logic;
            iuexma_wen_in   : in    std_logic;
            iuexma_flash_in : in    std_logic;
            iuexma_di_in    : in    st_iuexma_if;
            iuexma_do_out   :   out st_iuexma_if
        );
    end component;

end iuexma_pac;

-- package body iuexma_pac is
-- end iuexma_pac;
