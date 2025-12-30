library ieee;
use ieee.std_logic_1164.all;

entity COUNTER is
    port(
        CLK     : in std_logic;
        PR, CL  : in std_logic;
        CYCLE   : out std_logic_vector(2 downto 0)
    );
end entity COUNTER;

architecture COUNTING of COUNTER is
    component FFJK is
        port(
            J, K    : in std_logic;
            CLK     : in std_logic;
            PR, CL  : in std_logic;
            Q, NQ   : out std_logic 
        );
    end component;

    component COUNTER_UC is
        port(
            Q       : in std_logic_vector(2 downto 0);
            J, K    : out std_logic_vector(2 downto 0)
        );
    end component;

    signal SJ, SK   : std_logic_vector(2 downto 0);
    signal SQ, SNQ  : std_logic_vector(2 downto 0);

    begin
        U_CTR_UC    : COUNTER_UC port map(SQ, SJ, SK); 

        U_FFJK0     : FFJK port map(SJ(0), SK(0), CLK, PR, CL, SQ(0), SNQ(0));
        U_FFJK1     : FFJK port map(SJ(1), SK(1), CLK, PR, CL, SQ(1), SNQ(1));
        U_FFJK2     : FFJK port map(SJ(2), SK(2), CLK, PR, CL, SQ(2), SNQ(2));

        CYCLE   <= SQ;

end architecture COUNTING;