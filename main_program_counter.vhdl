library ieee;
use ieee.std_logic_1164.all;

entity MAIN_PROGRAM_COUNTER is
    port(
        RST, CLK    : in std_logic;
        PC_BUS      : in std_logic_vector(7 downto 0);
        N_BUS_INC   : in std_logic;
        PC_NRW      : in std_logic;
        PC_OUT      : out std_logic_vector(7 downto 0)
    );
end entity MAIN_PROGRAM_COUNTER;

architecture COUNTER of MAIN_PROGRAM_COUNTER is
    -- Contador 8 bits
    component ADDER_8B is
        port(
            X       : in std_logic_vector(7 downto 0);
            Y       : in std_logic_vector(7 downto 0);
            C_IN    : in std_logic;
            C_OUT   : out std_logic;
            R       : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Registrador PC(RIP) 8 bits
    component REG_8B is
        port(
        D       : in std_logic_vector(7 downto 0);
        CLK     : in std_logic;
        PR, CL  : in std_logic;
        NRW     : in std_logic;
        S       : out std_logic_vector(7 downto 0)
    );
    end component;

    -- Sinais:
    -- S_ADD -> Resultador Somador
    signal S_ADD        : std_logic_vector(7 downto 0);
    -- S_MUX_2_PC -> Saida Mux -> Registrador PC
    signal S_MUX_2_PC   : std_logic_vector(7 downto 0);
    -- S_CURR_PC -> Saida valor atual Registrador PC
    signal S_CURR_PC    : std_logic_vector(7 downto 0);
    -- S_PC_2_MEM -> Valor recebido pelo Modulo Memória
    signal S_PC_2_MEM   : std_logic_vector(7 downto 0);
    -- Sinal Carry Out Somador
    signal S_COUT   : std_logic;

    begin
        -- Mapeamento Somador 8 bits
        U_ADD       : ADDER_8B port map("00000001", S_CURR_PC, '0', S_COUT, S_ADD);
        
        -- Mux que controla valor recebido pelo Registrador PC:
        -- 0 envia dados do Barramento
        -- 1 envia dados do Somador
        S_MUX_2_PC <= S_ADD when N_BUS_INC = '1' else PC_BUS;

        -- Mapeamento Registrador PC
        U_PC_RIP    : REG_8B port map(S_MUX_2_PC, CLK, '1', RST, PC_NRW, S_PC_2_MEM);
        
        -- Incremento de Endereço no Somador
        S_CURR_PC   <= S_PC_2_MEM;

        -- Saida "Address" para Memoria
        PC_OUT      <= S_PC_2_MEM;

end architecture COUNTER;