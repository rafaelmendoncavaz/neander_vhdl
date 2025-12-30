library ieee;
use ieee.std_logic_1164.all;

entity MAIN_MEM is
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
end entity MAIN_MEM;

architecture STORAGE of MAIN_MEM is
    -- Registrador 8 Bits (REM, RDM)
    component REG_8B is
        port(
            D       : in std_logic_vector(7 downto 0);
            CLK     : in std_logic;
            PR, CL  : in std_logic;
            NRW     : in std_logic;
            S       : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Memoria
    component INNER_MEM is
        port(
		ADDR  	: in    std_logic_vector(7 downto 0);
		DATA  	: inout std_logic_vector(7 downto 0);
		NR_W 	: in    std_logic;
		RST 	: in    std_logic
	);
    end component INNER_MEM;

    -- Sinais: 
    -- MUX -> Registrador Endereço
    signal S_MUX_2_REM  : std_logic_vector(7 downto 0) := (others => 'Z');
    -- Registrador Endereço -> Memória
    signal S_REM_2_MEM  : std_logic_vector(7 downto 0) := (others => 'Z');
    -- Memória -> Registrador Dados
    signal S_MEM_2_RDM  : std_logic_vector(7 downto 0) := (others => 'Z');
    -- Registrador Dados -> Barramento de Interface
    signal S_RDM_2_BUS  : std_logic_vector(7 downto 0) := (others => 'Z');
    

    begin
        -- REM recebe sinal do barramento se Barr/PC = 0, senão, recebe sinal do módulo PC
        S_MUX_2_REM <= END_BUS when N_BUS_PC = '0' else END_PC;

        -- Mapeamento Registrador Endereço (REM MAR)
        U_REG_REM : REG_8B port map(S_MUX_2_REM, CLK, '1', RST, REM_NRW, S_REM_2_MEM);

        -- Mapeamento Memoria RAM Interna
        U_INNER_MEM : INNER_MEM port map(S_REM_2_MEM, S_MEM_2_RDM, MEM_NRW, RST);

        -- Mapeamento Registrador Dados (RDM MBR)
        U_REG_RDM : REG_8B port map(S_MEM_2_RDM, CLK, '1', RST, RDM_NRW, S_RDM_2_BUS);

        -- Trap Killer (MUX Especial)
        -- READ: memória → RDM
        MEM_BUS <= S_RDM_2_BUS when MEM_NRW = '0' else (others => 'Z');
        -- WRITE: RDM → barramento → memória
        S_MEM_2_RDM <= MEM_BUS when MEM_NRW = '1' else (others => 'Z');

end architecture STORAGE;