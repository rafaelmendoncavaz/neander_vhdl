library ieee;
use ieee.std_logic_1164.all;

entity FFJK is
    port(
        J, K    : in std_logic;
        CLK     : in std_logic;
        PR, CL  : in std_logic;
        Q, NQ   : out std_logic 
    );
end FFJK;

architecture BEHAVIOR of FFJK is
    signal s_SNJ, s_SNK         : std_logic;
    signal s_SNS, s_SNR         : std_logic;
    signal s_ELO_S, s_ELO_R     : std_logic;
    signal s_SNS2, s_SNR2       : std_logic;
    signal s_ELO_Q, s_ELO_nQ    : std_logic;
    signal s_NCLK               : std_logic;

begin
    s_SNJ       <= NOT(J AND CLK AND s_ELO_nQ);
    s_SNK       <= NOT(K AND CLK and s_ELO_Q);

    s_SNS       <= NOT(PR AND s_SNJ AND s_ELO_R);
    s_SNR       <= NOT(CL and s_SNK AND s_ELO_S);

    s_ELO_S     <= s_SNS;
    s_ELO_R     <= s_SNR;

    s_NCLK      <= NOT(CLK);

    s_SNS2      <= NOT(s_NCLK AND s_SNS);
    s_SNR2      <= NOT(s_NCLK AND s_SNR);

    s_ELO_Q     <= NOT(PR AND s_SNS2 AND s_ELO_nQ);
    s_ELO_nQ    <= NOT(CL AND s_SNR2 AND s_ELO_Q);

    Q           <= s_ELO_Q;
    NQ          <= s_ELO_nQ;

end architecture BEHAVIOR;