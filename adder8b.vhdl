library ieee;
use ieee.std_logic_1164.all;

entity ADDER_8B is
    port(
        X       : in std_logic_vector(7 downto 0);
        Y       : in std_logic_vector(7 downto 0);
        C_IN    : in std_logic;
        C_OUT   : out std_logic;
        R       : out std_logic_vector(7 downto 0)
    );
end ADDER_8B;

architecture BEHAVIOR of ADDER_8B is
    component ADDER_1B is
        port(
            X       : in std_logic;
            Y       : in std_logic;
            C_IN    : in std_logic; 
            C_OUT   : out std_logic;
            R       : out std_logic
        );
    end component;

    signal CARRY : std_logic_vector(7 downto 0);

    begin
        ADD0    : ADDER_1B port map(
            X(0), Y(0), C_IN, CARRY(0), R(0)
        );

        GEN_ADDERS  : for i in 1 to 7 generate
            ADDi    : ADDER_1B port map(
                X(i), Y(i), CARRY(i - 1), CARRY(i), R(i)
            );
        end generate GEN_ADDERS;

        C_OUT   <= CARRY(7);
        
end architecture BEHAVIOR;