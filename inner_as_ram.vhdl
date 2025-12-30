-- neander asynchronous simple ram memory
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;

entity INNER_MEM is
	port(
		ADDR  	: in    std_logic_vector(7 downto 0);
		DATA  	: inout std_logic_vector(7 downto 0);
		NR_W 	: in    std_logic;
		RST 	: in    std_logic
	);
end entity INNER_MEM;

architecture BEHAVIOR of INNER_MEM is
	type ram_type is array (0 to 255) of std_logic_vector(7 downto 0);
	signal ram : ram_type;
	signal DATA_OUT : std_logic_vector(7 downto 0);
begin
	
	rampW : process(NR_W, RST, ADDR, DATA)
	type binary_file is file of character;
	file load_file : binary_file open read_mode is "neanderram-ex01.mem";
	variable char : character;
	begin
		if (RST = '0' and RST'event) then
			-- init ram
			read(load_file, char); -- 0x03 '.'
			read(load_file, char); -- 0x4E 'N'
			read(load_file, char); -- 0x44 'D'
			read(load_file, char); -- 0x52 'R'
			for i in 0 to 255 loop
				if not endfile(load_file) then
						read(load_file, char);
						ram(i) <= std_logic_vector(to_unsigned(character'pos(char),8));
						read(load_file, char);	-- 0x00 oriundo de alinhamento 16bits	
				end if; -- if not endfile(load_file) then
			end loop; -- for i in 0 to 255
        else
		    if (RST = '1' and NR_W = '1') then
			    -- Write
			    ram(to_integer(unsigned(ADDR))) <= DATA;
		    end if; -- RST == '1'
		end if; -- RST == '0'
	end process rampW;

	DATA <= DATA_OUT when (RST = '1' and NR_W = '0')
		  else (others => 'Z');

	rampR : process(NR_W, RST, ADDR, DATA)
	begin
		if (RST = '1' and NR_W = '0') then
				-- Read
				DATA_OUT <= ram(to_integer(unsigned(ADDR)));
		end if; -- RST = '1' and NR_W = '0'
	end process rampR;
end architecture BEHAVIOR;
