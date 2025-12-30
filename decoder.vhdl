library ieee;
use ieee.std_logic_1164.all;

entity DECODER is
    port(
        INSTR_IN    : in std_logic_vector(7 downto 0);
        INSTR_OUT   : out std_logic_vector(10 downto 0)
    );
end entity DECODER;

architecture DECODE of DECODER is
    begin
        INSTR_OUT <=
        "10000000000" when INSTR_IN(7 downto 4) = "0000" else
        "01000000000" when INSTR_IN(7 downto 4) = "0001" else
        "00100000000" when INSTR_IN(7 downto 4) = "0010" else
        "00010000000" when INSTR_IN(7 downto 4) = "0011" else
        "00001000000" when INSTR_IN(7 downto 4) = "0100" else
        "00000100000" when INSTR_IN(7 downto 4) = "0101" else
        "00000010000" when INSTR_IN(7 downto 4) = "0110" else
        "00000001000" when INSTR_IN(7 downto 4) = "1000" else
        "00000000100" when INSTR_IN(7 downto 4) = "1001" else
        "00000000010" when INSTR_IN(7 downto 4) = "1010" else
        "00000000001" when INSTR_IN(7 downto 4) = "1111" else
        "ZZZZZZZZZZZ";
        
end architecture DECODE;