library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is 
port(	clk:			in std_logic;		-- Señal de reloj de la computadora
		Datain_en: 	in std_logic;		-- Señal para habilitar la escritura en contador
		PC_en: 		in std_logic;		-- Señal para habilitar contador
		PC_out:		in std_logic;		-- Señal para habilitar salida al bus
		S:				inout std_logic_vector(7 downto 0) -- Salida o entrada de datos
);
end PC;

architecture Arq1 of PC is 
signal clk_C: integer range 0 to 255 := 0;
signal S_A: std_logic_vector(7 downto 0);
begin
process(clk)
begin
	if rising_edge(clk) then 
		if   PC_out = '1' and PC_en = '0' then 							-- Si se da un flanco positivo y esta habilitada la salida...
		S <= std_logic_vector(to_unsigned(clk_C,8));					-- coloco a la salida el valor del contador
		S_A <= std_logic_vector(to_unsigned(clk_C,8));
		elsif PC_en = '1' and PC_out = '0' then 
			if clk_C = 255 then 
				clk_C <= 0;														-- Reinicio contador
			else 
				clk_C <= clk_c +1;											-- Incremento contador
			end if;
	
		elsif Datain_en = '1' and PC_out = '0' then
			clk_C <= to_integer(unsigned(S));							-- Coloca el valor de la entrada al contador
		else 
		S <= (others => 'Z');												-- Coloca la salida en alta impedancia
		end if;
	end if;							
		
end process;
end Arq1;