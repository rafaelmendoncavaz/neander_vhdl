library ieee;
use ieee.std_logic_1164.all;

entity CU_AND is
    port(
        CYCLE   : in std_logic_vector(2 downto 0);
        O_PUT   : out std_logic_vector(10 downto 0)
    );
end entity;

architecture AND_OP of CU_AND is
    begin
        -- NOT(BUS)/INC
        O_PUT(10)           <= '1';
        -- NOT(BUS)/PC
        O_PUT(9)            <= NOT CYCLE(2) OR CYCLE(1) OR NOT CYCLE(0);
        -- ULA_OP
        O_PUT(8 downto 6)   <= "011";
        -- PC_NOT(READ)/WRITE
        O_PUT(5)            <= NOT CYCLE(1) AND (CYCLE(2) XOR CYCLE(0));
        -- AC_NOT(READ)/WRITE
        O_PUT(4)            <= CYCLE(2) AND CYCLE (1) AND CYCLE(0);
        -- MEM_NOT(READ)/WRITE
        O_PUT(3)            <= '0';
        -- REM_NOT(READ)/WRITE
        O_PUT(2)            <= (NOT CYCLE(1) AND (CYCLE(2) XNOR CYCLE(0))) OR (NOT CYCLE(2) AND CYCLE(1) AND CYCLE(0));
        -- RDM_NOT(READ)/WRITE
        O_PUT(1)            <= (CYCLE(2) AND NOT CYCLE(0)) OR (NOT CYCLE(2) AND NOT CYCLE(1) AND CYCLE(0));
        -- RI_NOT(READ)/WRITE
        O_PUT(0)            <= NOT CYCLE(2) AND CYCLE(1) AND NOT CYCLE(0);

end architecture AND_OP;