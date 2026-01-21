-- NEANDER - TestBench ========================================================
-- ghdl -a *.vhdl ; ghdl -r tb_neander --wave=NEANDER_tb.ghw --stop-time=1000ns
library ieee;
use ieee.std_logic_1164.all;

entity TB_NEANDER is
end entity TB_NEANDER;

architecture EXEC of TB_NEANDER is
    constant CLK_PERIOD : time := 20 ns;

    component MAIN_NEANDER is
        port(
            CLK : in std_logic;
            RST : in std_logic
        );
    end component;

    signal CLK : std_logic := '0';
    signal RST : std_logic := '1';

begin
    CLK         <= NOT(CLK) after CLK_PERIOD / 2;
    U_NEANDER   : MAIN_NEANDER port map(CLK, RST);

    NEANDER : process
    begin
        -- reset inicial
        RST <= '0';
        wait for CLK_PERIOD / 2;
        RST <= '1';

        wait;

    end process NEANDER;

end architecture EXEC;