library ieee;
use ieee.std_logic_1164.all;

entity MAIN_NEANDER is
    port(
        RST : in std_logic;
        CLK : in std_logic
    );
end entity MAIN_NEANDER;

architecture INTERFACE of MAIN_NEANDER is
    -- ULA
    component MAIN_ALU is
        port(
        RST             : in std_logic;
        CLK             : in std_logic;
        AC_NRW          : in std_logic;
        ALU_OP          : in std_logic_vector(2 downto 0);
        MEM_NRW         : in std_logic;
        ALU_FLAGS       : out std_logic_vector(1 downto 0);
        ALU_BUS         : inout std_logic_vector(7 downto 0)
    );
    end component MAIN_ALU;

    -- Memoria
    component MAIN_MEM is
        port(
        RST, CLK        : in std_logic;
        N_BUS_PC        : in std_logic;
        REM_NRW         : in std_logic;
        MEM_NRW         : in std_logic;
        RDM_NRW         : in std_logic;
        END_PC          : in std_logic_vector(7 downto 0);
        END_BUS         : in std_logic_vector(7 downto 0);
        MEM_BUS         : inout std_logic_vector(7 downto 0)
    );
    end component MAIN_MEM;

    -- Contador de Programa
    component MAIN_PROGRAM_COUNTER is
        port(
        RST, CLK    : in std_logic;
        PC_BUS      : in std_logic_vector(7 downto 0);
        N_BUS_INC   : in std_logic;
        PC_NRW      : in std_logic;
        PC_OUT      : out std_logic_vector(7 downto 0)
    );
    end component MAIN_PROGRAM_COUNTER;

    -- Controle de Instruções
    component MAIN_CONTROLLER is
        port(
            RST, CLK    : in std_logic;
            CONTROL_BUS : in std_logic_vector(7 downto 0);
            RI_NRW      : in std_logic;
            FLAGS_NZ    : in std_logic_vector(1 downto 0);
            CTRL_BUS    : out std_logic_vector(10 downto 0)
        );
    end component;

    -- Sinal Universal de Barramento
    signal S_INTERFACE_BUS    : std_logic_vector(7 downto 0);

    -- Sinais de saida da UC (Barramento de Controle)
    signal S_N_BUS_INC        : std_logic;
    signal S_N_BUS_PC         : std_logic;
    signal S_ALU_OP           : std_logic_vector(2 downto 0);
    signal S_PC_NRW           : std_logic;
    signal S_AC_NRW           : std_logic;
    signal S_MEM_NRW          : std_logic;
    signal S_REM_NRW          : std_logic;
    signal S_RDM_NRW          : std_logic;
    signal S_RI_NRW           : std_logic;

    -- Sinal de entrada PC -> MEM
    signal S_END_PC           : std_logic_vector(7 downto 0);

    -- Sinal de flag ALU -> UC
    signal S_ALU_FLAGS        : std_logic_vector(1 downto 0);

    -- Sinal de Barramento de Controle UC -> SYS
    signal S_CTRL_BUS         : std_logic_vector(10 downto 0);

    begin
        -- Mapeamento da Interação PC -> MEM
        U_PC_2_MEM      : MAIN_PROGRAM_COUNTER port map(RST, CLK, S_INTERFACE_BUS, S_N_BUS_INC, S_PC_NRW, S_END_PC);

        -- Mapeamento da Interação PC/ALU -> UC
        U_PC_ALU_2_SYS  : MAIN_CONTROLLER port map(RST, CLK, S_INTERFACE_BUS, S_RI_NRW, S_ALU_FLAGS, S_CTRL_BUS);

        -- Mapeamento da Interação MEM -> ULA
        U_MEM_2_ALU     : MAIN_MEM port map(RST, CLK, S_N_BUS_PC, S_REM_NRW, S_MEM_NRW, S_RDM_NRW, S_END_PC, S_INTERFACE_BUS, S_INTERFACE_BUS);

        -- Mapeamento da Interação ULA -> MEM
        U_ALU_2_MEM     : MAIN_ALU port map(RST, CLK, S_AC_NRW, S_ALU_OP, S_MEM_NRW, S_ALU_FLAGS, S_INTERFACE_BUS);

        -- Distribuição dos sinais do Barramento de Controle
        S_N_BUS_INC <= S_CTRL_BUS(10);
        S_N_BUS_PC  <= S_CTRL_BUS(9);
        S_ALU_OP    <= S_CTRL_BUS(8 downto 6);
        S_PC_NRW    <= S_CTRL_BUS(5);
        S_AC_NRW    <= S_CTRL_BUS(4);
        S_MEM_NRW   <= S_CTRL_BUS(3);
        S_REM_NRW   <= S_CTRL_BUS(2);
        S_RDM_NRW   <= S_CTRL_BUS(1);
        S_RI_NRW    <= S_CTRL_BUS(0);

end architecture INTERFACE;