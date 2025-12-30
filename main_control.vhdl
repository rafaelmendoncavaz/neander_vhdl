library ieee;
use ieee.std_logic_1164.all;

entity MAIN_CONTROLLER is
    port(
        RST, CLK    : in std_logic;
        CONTROL_BUS : in std_logic_vector(7 downto 0);
        RI_NRW      : in std_logic;
        FLAGS_NZ    : in std_logic_vector(1 downto 0);
        CTRL_BUS    : out std_logic_vector(10 downto 0)
    );
end entity MAIN_CONTROLLER;

architecture CONTROL of MAIN_CONTROLLER is
    -- REG RI
    component REG_8B is
        port(
            D       : in std_logic_vector(7 downto 0);
            CLK     : in std_logic;
            PR, CL  : in std_logic;
            NRW     : in std_logic;
            S       : out std_logic_vector(7 downto 0)
        );
    end component;

    -- DECODIFICADOR
    component DECODER is
        port(
            INSTR_IN    : in std_logic_vector(7 downto 0);
            INSTR_OUT   : out std_logic_vector(10 downto 0)
        );
    end component;

    -- CONTROLADOR INTERNO/CICLO DE INSTR.
    component INNER_CONTROLLER is
        port(
            INSTRUCTION : in std_logic_vector(10 downto 0);
            CLK         : in std_logic;
            PR, CL      : in std_logic;
            FLAGS_NZ    : in std_logic_vector(1 downto 0);
            INSTR_BUS   : out std_logic_vector(10 downto 0)
        );
    end component;

    -- Sinal Registrador RI -> Decodificador
    signal S_REG_2_DEC  : std_logic_vector(7 downto 0);
    -- Sinal Decodificador -> Unidade de Controle
    signal S_DEC_2_UC   : std_logic_vector(10 downto 0);
    -- Sinal Unidade de Controle -> Barramento de Controle
    signal UC_2_BUS     : std_logic_vector(10 downto 0);

    begin
        -- Mapeamento Registrador RI
        U_REG_RI    : REG_8B port map(CONTROL_BUS, CLK, '1', RST, RI_NRW, S_REG_2_DEC);

        -- Mapeamento Decodificador
        U_DECODER   : DECODER port map(S_REG_2_DEC, S_DEC_2_UC);

        -- Mapeamento Unidade de Controle Interna
        U_INNER_UC  : INNER_CONTROLLER port map(S_DEC_2_UC, CLK, '1', RST, FLAGS_NZ, UC_2_BUS);

        -- Saida para Barramento de Controle
        CTRL_BUS <= UC_2_BUS;

end architecture CONTROL;