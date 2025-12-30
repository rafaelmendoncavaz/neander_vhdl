library ieee;
use ieee.std_logic_1164.all;

entity COUNTER_UC is
    port(
        Q       : in std_logic_vector(2 downto 0);
        J, K    : out std_logic_vector(2 downto 0)
    );
end entity COUNTER_UC;

architecture CYCLES of COUNTER_UC is
    begin
        J(0) <= '1';
        K(0) <= '1';

        J(1) <= Q(0);
        K(1) <= Q(0);
        
        J(2) <= Q(1) AND Q(0);
        K(2) <= Q(1) AND Q(0);
        
end architecture CYCLES;