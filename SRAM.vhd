library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;			-- Libreria para realizar conversiones entre otras operaciones

entity SRAM is 
	port(	Address: in 	std_logic_vector(7 downto 0);
			S: 	inout std_logic_vector (7 downto 0);
			clk: 		in std_logic;
			--En: 		in std_logic;	-- Activo en bajo
			RAM_Out:		in std_logic	-- RAM_Out = 1 habilita lectura (Sincrono) y RAM_Out = 0 habilita escritura (Sincrono)
	);
end entity;

architecture Arq1 of SRAM is 
type RAM_t is array((2**8)-1 downto 0) of std_logic_vector(7 downto 0);-- Se declara tipo de dato tipo array bidimencional (256x8) o 256 bytes
signal RAM_S: RAM_t;				-- Declaro señal con tipo RAM_t
attribute ram_init_file: string;
attribute ram_init_file of RAM_S: signal is "SRAM.mif"; -- lee el fichero de inicialización
begin
						
process(clk)							-- Proceso sensible a clk
begin
	if rising_edge(clk) then 
		--if RAM_Out = '0' then 		-- Si esta habilitado y el modo escritura esta activado...
			--RAM_S(to_integer(unsigned(Address))) <= S;-- Lee lo que haya en S(siendo entrada) y lo guarda en la memoria RAM
		if (RAM_Out = '1') then -- Si esta habilitado y el modo lectura esta activado...
			S <= RAM_S(to_integer(unsigned(Address)));-- Lee el dato ubicado en Address de RAM_S y lo coloca en S
		else 
			S <= (others => 'Z');	-- Si no se cumple esa condición se coloca en estado de alta impedancia
		end if;
	end if;

end process;
end Arq1;
