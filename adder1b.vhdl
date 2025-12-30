library ieee;
use ieee.std_logic_1164.all;

entity ADDER_1B is
    port(
        X       : in std_logic;
        Y       : in std_logic;
        C_IN    : in std_logic; 
        C_OUT   : out std_logic;
        R       : out std_logic
    );
end ADDER_1B;

architecture BEHAVIOR of ADDER_1B is
begin
    R       <= (X XOR Y) XOR C_IN;
    C_OUT   <= (X AND C_IN) OR (Y AND C_IN) OR (X AND Y);
end BEHAVIOR;