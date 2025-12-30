library ieee;
use ieee.std_logic_1164.all;

entity REG_2B is
    port(
        D       : in std_logic_vector(1 downto 0);
        CLK     : in std_logic;
        PR, CL  : in std_logic;
        NRW     : in std_logic;
        S       : out std_logic_vector(1 downto 0)
    );
end entity;

architecture BEHAVIOR of REG_2B is
    component REG_1B_BASE is
        port(
            D       : in std_logic;
            CLK     : in std_logic;
            PR, CL  : in std_logic;
            NRW     : in std_logic;
            S       : out std_logic
        );
    end component;

    begin
        gen_regs : for i in 0 to 1 generate
            U_REG : REG_1B_BASE port map(
                D   => D(i),
                CLK => CLK, 
                PR  => PR, 
                CL  => CL, 
                NRW => NRW,
                S   => S(i)
                );
        end generate gen_regs;
        
end architecture BEHAVIOR;