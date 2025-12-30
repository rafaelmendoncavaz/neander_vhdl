library ieee;
use ieee.std_logic_1164.all;

entity MAIN_ALU is
    port(
        RST             : in std_logic;
        CLK             : in std_logic;
        AC_NRW          : in std_logic;
        ALU_OP          : in std_logic_vector(2 downto 0);
        MEM_NRW         : in std_logic;
        ALU_FLAGS       : out std_logic_vector(1 downto 0);
        ALU_BUS         : inout std_logic_vector(7 downto 0)
    );
end entity MAIN_ALU;

architecture MATH of MAIN_ALU is
    -- REGISTRADOR AC
    component REG_8B is
        port(
        D       : in std_logic_vector(7 downto 0);
        CLK     : in std_logic;
        PR, CL  : in std_logic;
        NRW     : in std_logic;
        S       : out std_logic_vector(7 downto 0)
    );
    end component;

    -- REGISTRADOR FLAGS
    component REG_2B is
        port(
        D       : in std_logic_vector(1 downto 0);
        CLK     : in std_logic;
        PR, CL  : in std_logic;
        NRW     : in std_logic;
        S       : out std_logic_vector(1 downto 0)
    );
    end component;

    -- ULA INTERNA
    component INNER_ALU is
        port(
        X, Y    : in std_logic_vector(7 downto 0);
        ALU_OP  : in std_logic_vector(2 downto 0);
        FLAG_NZ : out std_logic_vector(1 downto 0);
        S       : out std_logic_vector(7 downto 0)
    );
    end component;

    -- Sinal Registrador AC -> ULA
    signal S_AC_2_ULA       : std_logic_vector(7 downto 0);
    -- Sinal ULA -> Registrador AC
    signal S_ULA_2_AC       : std_logic_vector(7 downto 0);
    -- Sinal ULA -> FLAGS_NZ
    signal S_ULA_2_FLAGS    : std_logic_vector(1 downto 0);
    
    begin
        -- Mapeamento das entradas e saídas do Registrador AC
        U_REG_AC    : REG_8B port map(
            S_ULA_2_AC, CLK, '1', RST, AC_NRW, S_AC_2_ULA
        );

        -- Mapeamento das entradas e saídas do Registrador FLAGS
        U_REG_FLAGS : REG_2B port map(
            S_ULA_2_FLAGS, CLK, '1', RST, AC_NRW, ALU_FLAGS
        );

        -- Mapeamento das entradas e saídas da ULA interna
        U_INNER_ALU : INNER_ALU port map(
            S_AC_2_ULA, ALU_BUS, ALU_OP, S_ULA_2_FLAGS, S_ULA_2_AC
        );

        -- Barramento de Dados e Instruções (MUX ESPECIAL)
        ALU_BUS <= S_AC_2_ULA when MEM_NRW = '1' else (others => 'Z');

end architecture MATH;