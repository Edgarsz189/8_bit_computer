-- Autor: Edgar Sáenz Zubía

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Logic_Control is 
		port(		clk: 		in std_logic;
					Opcode:	in std_logic_vector(3 downto 0); 
					--Signal_Control: out std_logic_vector (14 downto 0);
					
					-- Señales de control del Registro A:
					Reg_A_Out: 	out std_logic;
					Reg_A_In:	out std_logic;
					-- Señales de control del Registro B:
					Reg_B_Out: 	out std_logic;
					Reg_B_In:	out std_logic;
					-- Señales de control del contador de programa:
					PC_En: 	out std_logic;
					PC_out:	out std_logic;
					PC_In: 	out std_logic;
					-- Señales de control de la ALU:
					Operation: out std_logic;
					ALU_out: out std_logic;
					Carry:	out std_logic;
					-- Señales de control del registro de direcciones:
					Mem_Adr_In: out std_logic;
					-- Señales de control de la RAM:
					RAM_Out: 	out std_logic;
					RAM_En: 	out std_logic;
					-- Señales de control del registro de instrucciones:
					Inst_Reg_Out: out std_logic;
					Inst_Reg_In: out std_logic;
					-- Señales de control del registro de Salida:
					Out_Reg: out std_logic
		);
end Logic_Control;

architecture Arq1 of Logic_Control is 
type State_t is (fetch_0, fetch_1, fetch_2, fetch_3, Decode);
signal State: State_t;
signal Count: integer range 0 to 5 := 0;
begin
process(clk)
begin
	if rising_edge(clk) then 
		case State is 
			when fetch_0 => 				-- Fetch cycle:
				PC_En 		<= '0';		-- Habilita el contador (Contador +1)
				PC_out 		<= '1';		-- Coloca el contenido del contador en el bus
				Operation 	<= '1';		-- Define si la ALU sumara (Operation = 1) o Restara (Operation = 0)
				Reg_A_In    <= '0'; 		-- señal para cargar un valor del bus al registro A
				Reg_B_In    <= '0'; 		-- señal para cargar un valor del bus al registro B
				RAM_Out 		<= '0';    	-- Si esta en 1 saca su valor hacia el bus, con 0 escribimos en la RAM
				RAM_En 	 	<= '0';    	-- Habilita la escritura y/o lectura de la RAM
				Out_Reg 		<= '0';
				Mem_Adr_In 	<= '0';		-- habilita la escritura al registro de direcciones 
				State <= fetch_1; 		-- Cambia de estado
			when fetch_1 => 				-- Fetch cycle:
				PC_En 		<= '0';		-- Habilita el contador (Contador +1)
				Mem_Adr_In 	<= '1';		-- habilita la escritura al registro de direcciones 
				State <= fetch_2; 		-- Cambia de estado
			when fetch_2 => 				-- Fetch cycle:
			   PC_En 		<= '1';		-- Habilita el contador (Contador +1)
				PC_out 		<= '0';		-- Coloca el contenido del contador en el bus
				Mem_Adr_In 	<= '0';		-- habilita la escritura al registro de direcciones 
				RAM_Out 		<= '1';		-- Si esta en 1 saca su valor hacia el bus, con 0 escribimos en la RAM
				RAM_En 		<= '1';		-- Habilita la escritura y/o lectura de la RAM
				State <= fetch_3; 		-- Cambia de estado
			when fetch_3 => 				-- Fetch cycle:
				PC_En 		<= '0';
				Inst_Reg_In <= '1';		-- Escribe en el registro de instruciones
				State <= Decode; 		-- Cambia de estado
			when Decode => 			-- Fetch cycle:
				case Opcode is 
					when "0000" => -- Opcode para cargar un valor en el registro A
						
						if Count = 0 then
						 RAM_Out 		<= '0';    -- Si esta en 1 saca su valor hacia el bus, con 0 escribimos en la RAM
						 RAM_En 	 		<= '0';    -- Habilita la escritura y/o lectura de la RAM
						 Inst_Reg_In 	<= '0';
						 Inst_Reg_Out 	<= '1';  	-- Coloca la dirección de memoria en el bus (4 LSB de la instrucción)
						 Count    		<= Count + 1;	--
						 elsif Count = 1 then 
						 Mem_Adr_In  	<= '1';		-- Escribe en el registro de direcciones
						 Count    <= Count + 1;		--
						 elsif Count = 2 then  
						 RAM_Out     	<= '1';		-- El contenido de la memoria RAM en la dirección especificada se coloca en el bus
						 RAM_En 	   	<= '1';		-- Habilita la escritura y/o lectura de la RAM
						 Inst_Reg_Out  <= '0';  	-- 
						 Mem_Adr_In    <= '0';
						 Count    <= Count + 1;
						 elsif Count = 3 then  
						 Reg_A_In      <= '1'; 	-- señal para cargar un valor del bus al registro A
						 Count <= 0;			-- Reinicia Count
						 State <= fetch_0; 	-- Regresa para comenzar una nueva ejecución
						
						end if;	 
					when "0001" => -- Opcode para sumar Variable + Registro B y almacenar en registro A
						 if Count = 0 then
						 RAM_Out 		<= '0';    -- Si esta en 1 saca su valor hacia el bus, con 0 escribimos en la RAM
						 RAM_En 	 		<= '0';    -- Habilita la escritura y/o lectura de la RAM
						 Inst_Reg_In 	<= '0';
						 Inst_Reg_Out 	<= '1';  	-- Coloca la dirección de memoria en el bus (4 LSB de la instrucción)
						 Count    		<= Count + 1;	--
						 elsif Count = 1 then 
						 Mem_Adr_In  	<= '1';		-- Escribe en el registro de direcciones
						 Count    <= Count + 1;		--
						 elsif Count = 2 then  
						 RAM_Out     	<= '1';		-- El contenido de la memoria RAM en la dirección especificada se coloca en el bus
						 RAM_En 	   	<= '1';		-- Habilita la escritura y/o lectura de la RAM
						 Inst_Reg_Out  <= '0';  	-- 
						 Mem_Adr_In    <= '0';
						 Count    <= Count + 1;
						 elsif Count = 3 then  
						 Reg_B_In      <= '1'; 	-- señal para cargar un valor del bus al registro B
						 Count <= 0;				-- Reinicia Count
						 State <= fetch_0; 		-- Regresa para comenzar una nueva ejecución
						 end if;
					when "0010" => 			-- Opcode para activar salida
						 RAM_Out  <= '0';		-- Si esta en 1 saca su valor hacia el bus, con 0 escribimos en la RAM
						 RAM_En  <= '0';		-- Habilita la escritura y/o lectura de la RAM
						 Inst_Reg_In <= '0';		-- Escribe en el registro de instruciones
						 PC_En   <= '0';		-- Habilita el contador (Contador +1)
						 Reg_A_Out  <= '1';
						 Out_Reg <= '1';
						 State <= fetch_0; 	-- Regresa para comenzar una nueva ejecución
						 
					when "0011" => 
					when "0100" => 
					when "0101" => 
					when "0110" => 
					when "0111" => 
					when "1000" => 
					when others => null;	
				end case;
			
		end case;
	end if;
end process;

end Arq1;