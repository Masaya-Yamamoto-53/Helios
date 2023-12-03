library ieee;
use ieee.std_logic_1164.all;

use work.iu_pac.all;

package iufwu_pac is

    constant IUFWU_EX : integer := 0;
    constant IUFWU_MA : integer := 1;

    type st_iufwpre_if is
    record
        we   : std_logic;
        sel  : std_logic_vector( 4 downto  0);
    end record;
    constant st_iufwpre_if_INIT : st_iufwpre_if := (
        '0',
        (others => '0')
    );

    type st_iufwpast_if is
    record
        we   : std_logic;
        data : std_logic_vector(31 downto  0);
    end record;
    constant st_iufwpast_if_INIT : st_iufwpast_if := (
        '0',
        (others => '0')
    );

    component iufwpreu
        port (
            iufwpreu_rs1_sel_in : in    std_logic_vector( 4 downto 0);
            iufwpreu_rs2_sel_in : in    std_logic_vector( 4 downto 0);
            iufwpreu_rs3_sel_in : in    std_logic_vector( 4 downto 0);

            iufwpreu_ex_rd_in   : in    st_iufwpre_if;
            iufwpreu_ma_rd_in   : in    st_iufwpre_if;

            iufwpreu_rs1_fw_out :   out std_logic_vector( 3 downto 0);
            iufwpreu_rs2_fw_out :   out std_logic_vector( 3 downto 0);
            iufwpreu_rs3_fw_out :   out std_logic_vector( 3 downto 0)
        );
    end component;

    component iufwpastu
        port (
            iufwpastu_rs1_fw_in  : in    std_logic_vector( 3 downto 0);
            iufwpastu_rs1_di_in  : in    std_logic_vector(31 downto 0);

            iufwpastu_rs2_fw_in  : in    std_logic_vector( 3 downto 0);
            iufwpastu_rs2_di_in  : in    std_logic_vector(31 downto 0);

            iufwpastu_rs3_fw_in  : in    std_logic_vector( 3 downto 0);
            iufwpastu_rs3_di_in  : in    std_logic_vector(31 downto 0);

            iufwpastu_ma_rd_in   : in    st_iufwpast_if;
            iufwpastu_wb_rd_in   : in    st_iufwpast_if;

            iufwpastu_rs1_do_out :   out std_logic_vector(31 downto 0);
            iufwpastu_rs2_do_out :   out std_logic_vector(31 downto 0);
            iufwpastu_rs3_do_out :   out std_logic_vector(31 downto 0)
        );
    end component;

    component iufwpre
        port (
            iufwpre_sel_in   : in    std_logic_vector( 4 downto 0);
            iufwpre_ex_rd_in : in    st_iufwpre_if;
            iufwpre_ma_rd_in : in    st_iufwpre_if;
            iufwpre_fw_out   :   out std_logic_vector( 3 downto 0)
        );
    end component;

    component iufwpast
        port (
            iufwpast_fw_in      : in    std_logic_vector( 3 downto 0);
            iufwpast_ex_data_in : in    std_logic_vector(31 downto 0);
            iufwpast_ma_rd_in   : in    st_iufwpast_if;
            iufwpast_wb_rd_in   : in    st_iufwpast_if;
            iufwpast_data_out   :   out std_logic_vector(31 downto 0)
        );
    end component;

end iufwu_pac;

-- package body iufwu_pac is
-- end iufwu_pac;
