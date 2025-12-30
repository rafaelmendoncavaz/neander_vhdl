library ieee;
use ieee.std_logic_1164.all;

entity REG_1B_BASE is
    port(
        D       : in std_logic;
        CLK     : in std_logic;
        PR, CL  : in std_logic;
        NRW     : in std_logic;
        S       : out std_logic
    );
end entity;

architecture BEHAVIOR of REG_1B_BASE is
    component FFD is
        port(
            D       : in std_logic;
            CLK     : in std_logic;
            PR, CL  : in std_logic;
            Q, NQ   : out std_logic
        );
    end component;

    signal DATAIN, DATAOUT : std_logic;

    begin
        -- envio de dataout para saida s
        S <= DATAOUT;
        
        -- multiplexador
        -- nrw = 1 -> entrada principal de interface d
        -- nrw = 0 -> saida temporaria de dataout (mantem estado)
        DATAIN <= DATAOUT when NRW = '0' else D;

        -- instancia do reg
        U_REG   : ffd port map(DATAIN, CLK, PR, CL, DATAOUT);
    end architecture;