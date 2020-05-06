library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  

entity ALU is 
	port( clk: 	in std_logic;
			OPcode: in std_logic;
			En: 	in std_logic;
			A: 	in std_logic_vector(7 downto 0); 		-- Entrada de 8 bits
			B: 	in std_logic_vector(7 downto 0);			-- Entrada de 8 bits
			S: 	inout std_logic_vector(7 downto 0)		-- Salida 
	
	
	);
end ALU;

architecture Arq1 of ALU is 
begin
process(clk)
begin
	if En = '0' then 
		S <= (others => 'Z');				-- coloca la salida en alta impedancia
	elsif rising_edge(clk) then
		if OPcode = '1' then 
			S <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) + to_integer(unsigned(B)),8));
			
		else 
			S <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) - to_integer(unsigned(B)),8));
			
		end if;
			
	
	end if;

end process;

end Arq1;