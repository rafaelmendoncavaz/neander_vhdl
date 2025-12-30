library ieee;
use ieee.std_logic_1164.all;

entity INNER_ALU is
    port(
        X, Y    : in std_logic_vector(7 downto 0);
        ALU_OP  : in std_logic_vector(2 downto 0);
        FLAG_NZ : out std_logic_vector(1 downto 0);
        S       : out std_logic_vector(7 downto 0)
    );
end entity INNER_ALU;

architecture BEHAVIOR of INNER_ALU is
    -- Somador 8 bits
    component ADDER_8B is
        port(
            X       : in std_logic_vector(7 downto 0);
            Y       : in std_logic_vector(7 downto 0);
            C_IN    : in std_logic;
            C_OUT   : out std_logic;
            R       : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Sinais op. ULA
    signal S_LDA    : std_logic_vector(7 downto 0);
    signal S_ADD    : std_logic_vector(7 downto 0);
    signal S_OR     : std_logic_vector(7 downto 0);
    signal S_AND    : std_logic_vector(7 downto 0);
    signal S_NOT    : std_logic_vector(7 downto 0);
    signal S_RESULT : std_logic_vector(7 downto 0);
    signal S_COUT   : std_logic;

    begin
        -- Realização de todas as operações da ULA
        
        S_LDA       <= Y;

        U_ADD   : ADDER_8B port map(
            X       => X,
            Y       => Y,
            C_IN    => '0',
            C_OUT   => S_COUT,
            R       => S_ADD
        );
        
        GEN_OR  : for i in 0 to 7 generate
            S_OR(i) <= X(i) OR Y(i);
        end generate;
        
        GEN_AND : for i in 0 to 7 generate
            S_AND(i) <= X(i) AND Y(i);
        end generate;
        
        GEN_NOT : for i in 0 to 7 generate
            S_NOT(i) <= NOT X(i);
        end generate;
        
        -- MUX da ULA interna
        S_RESULT    <= S_LDA when ALU_OP = "000" else
                    S_ADD when ALU_OP = "001" else
                    S_OR  when ALU_OP = "010" else
                    S_AND when ALU_OP = "011" else
                    S_NOT when ALU_OP = "100" else
                    (others => 'Z');

        -- Saída redirecionada pelo MUX
        S           <= S_RESULT;

        -- Em Complemento de 2, MSB = 1, o numero é negativo
        FLAG_NZ(1)  <= S_RESULT(7);

        -- Checagem se o número é igual a zero
        FLAG_NZ(0)  <= '1' when S_RESULT = "00000000" else '0';

end architecture BEHAVIOR;