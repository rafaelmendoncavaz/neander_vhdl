library ieee;
use ieee.std_logic_1164.all;

entity INNER_CONTROLLER is
    port(
        INSTRUCTION : in std_logic_vector(10 downto 0);
        CLK         : in std_logic;
        PR, CL      : in std_logic;
        FLAGS_NZ    : in std_logic_vector(1 downto 0);
        INSTR_BUS   : out std_logic_vector(10 downto 0)
    );
end entity INNER_CONTROLLER;

architecture INSTR_CONTROLLER of INNER_CONTROLLER is
    -- Contador sincrono 3 bits
    component COUNTER is
        port(
            CLK     : in std_logic;
            PR, CL  : in std_logic;
            CYCLE   : out std_logic_vector(2 downto 0)
        );
    end component;

    -- Instruc. LDA
    component CU_LDA is
        port(
            CYCLE   : in std_logic_vector(2 downto 0);
            O_PUT   : out std_logic_vector(10 downto 0)
        );
    end component CU_LDA;

    -- Instruc. STA
    component CU_STA is
        port(
            CYCLE   : in std_logic_vector(2 downto 0);
            O_PUT   : out std_logic_vector(10 downto 0)
        );
    end component CU_STA;

    -- Instruc. NOP
    component CU_NOP is
        port(
            CYCLE   : in std_logic_vector(2 downto 0);
            O_PUT   : out std_logic_vector(10 downto 0)
        );
    end component CU_NOP;
    
    -- Instruc. HLT
    component CU_HLT is
        port(
            CYCLE   : in std_logic_vector(2 downto 0);
            O_PUT   : out std_logic_vector(10 downto 0)
        );
    end component CU_HLT;

    -- Instruc. NOT
    component CU_NOT is
        port(
            CYCLE   : in std_logic_vector(2 downto 0);
            O_PUT   : out std_logic_vector(10 downto 0)
        );
    end component CU_NOT;

    -- Instruc. ADD
    component CU_ADD is
        port(
            CYCLE   : in std_logic_vector(2 downto 0);
            O_PUT   : out std_logic_vector(10 downto 0)
        );
    end component CU_ADD;

    -- Instruc. OR
    component CU_OR is
        port(
            CYCLE   : in std_logic_vector(2 downto 0);
            O_PUT   : out std_logic_vector(10 downto 0)
        );
    end component CU_OR;

    -- Instruc. AND
    component CU_AND is
        port(
            CYCLE   : in std_logic_vector(2 downto 0);
            O_PUT   : out std_logic_vector(10 downto 0)
        );
    end component CU_AND;

    -- Instruc. JMP
    component CU_JMP is
        port(
            CYCLE   : in std_logic_vector(2 downto 0);
            O_PUT   : out std_logic_vector(10 downto 0)
        );
    end component CU_JMP;

    -- Instruc. JN
    component CU_JN is
        port(
            CYCLE   : in std_logic_vector(2 downto 0);
            FLAGS   : in std_logic_vector(1 downto 0);
            O_PUT   : out std_logic_vector(10 downto 0)
        );
    end component CU_JN;

    -- Instruc. JZ
    component CU_JZ is
        port(
            CYCLE   : in std_logic_vector(2 downto 0);
            FLAGS   : in std_logic_vector(1 downto 0);
            O_PUT   : out std_logic_vector(10 downto 0)
        );
    end component CU_JZ;

    -- Sinal de Contagem do Ciclo
    signal S_CYCLE  : std_logic_vector(2 downto 0);

    -- Sinais de Saida das Instr.
    signal S_NOP    : std_logic_vector(10 downto 0);
    signal S_STA    : std_logic_vector(10 downto 0);
    signal S_LDA    : std_logic_vector(10 downto 0);
    signal S_ADD    : std_logic_vector(10 downto 0);
    signal S_OR     : std_logic_vector(10 downto 0);
    signal S_AND    : std_logic_vector(10 downto 0);
    signal S_NOT    : std_logic_vector(10 downto 0);
    signal S_JMP    : std_logic_vector(10 downto 0);
    signal S_JN     : std_logic_vector(10 downto 0);
    signal S_JZ     : std_logic_vector(10 downto 0);
    signal S_HLT    : std_logic_vector(10 downto 0);

    begin
        -- Mapeamento Contador
        U_COUNTER   : COUNTER port map(CLK, '1', CL, S_CYCLE); 

        -- Mapeamento LDA
        U_LDA       : CU_LDA port map(S_CYCLE, S_LDA);
        -- Mapeamento STA
        U_STA       : CU_STA port map(S_CYCLE, S_STA);
        -- Mapeamento NOP
        U_NOP       : CU_NOP port map(S_CYCLE, S_NOP);
        -- Mapeamento HLT
        U_HLT       : CU_HLT port map(S_CYCLE, S_HLT);
        -- Mapeamento NOT
        U_NOT       : CU_NOT port map(S_CYCLE, S_NOT);
        -- Mapeamento ADD
        U_ADD       : CU_ADD port map(S_CYCLE, S_ADD);
        -- Mapeamento OR
        U_OR        : CU_OR port map(S_CYCLE, S_OR);
        -- Mapeamento AND
        U_AND       : CU_AND port map(S_CYCLE, S_AND);
        -- Mapeamento JMP
        U_JMP       : CU_JMP port map(S_CYCLE, S_JMP);
        -- Mapeamento JN
        U_JN        : CU_JN port map(S_CYCLE, FLAGS_NZ, S_JN);
        -- Mapeamento JZ
        U_JZ        : CU_JZ port map(S_CYCLE, FLAGS_NZ, S_JZ);

        -- MUX 11x11z (Seletor de Instr.)
        INSTR_BUS   <=
            S_NOP when INSTRUCTION = "10000000000" else
            S_STA when INSTRUCTION = "01000000000" else
            S_LDA when INSTRUCTION = "00100000000" else
            S_ADD when INSTRUCTION = "00010000000" else
            S_OR  when INSTRUCTION = "00001000000" else
            S_AND when INSTRUCTION = "00000100000" else
            S_NOT when INSTRUCTION = "00000010000" else
            S_JMP when INSTRUCTION = "00000001000" else
            S_JN  when INSTRUCTION = "00000000100" else
            S_JZ  when INSTRUCTION = "00000000010" else
            S_HLT when INSTRUCTION = "00000000001" else
            (others => 'Z');

end architecture INSTR_CONTROLLER;