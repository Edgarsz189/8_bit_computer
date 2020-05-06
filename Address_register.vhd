library ieee;
use ieee.std_logic_1164.all;

entity Address_register is 
	port( clk: 	in std_logic;
			Mem_Adr_In:	in std_logic;
			Data: in std_logic_vector(7 downto 0);		-- Entrada de 8 bits
			S:		out std_logic_vector(7 downto 0)		-- Salida de 8 bits
			
	);
end Address_register;

architecture Arq1 of Address_register is 
signal S_A: std_logic_vector(7 downto 0) := "00000000";
begin
process(clk)
begin
	if rising_edge(clk) then 
		if Mem_Adr_In = '1' then 
			S <= Data; 								-- Coloco en el registro S_A lo que haya en el bus
			S_A <= Data;
		else 	
			S <= S_A and "00001111";
		end if;
	end if;
end process;
-- Asignación de señales:
--S <= S_A;									--Asigno S_A a S
end Arq1;