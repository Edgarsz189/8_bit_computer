library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instruction_Register is
		port (		clk: 			in std_logic;
						--Reset:		in std_logic;
						Inst_Reg_Out: 	in std_logic;				-- Señal para leer del registro
						Inst_Reg_In: 	in std_logic;				-- Señal para escribir en el registro
						S: 			inout std_logic_vector(7 downto 0) := (others => 'Z');
						S1: 			out std_logic_vector (3 downto 0)
		);
end Instruction_Register;

architecture Arq1 of Instruction_Register is
signal S_A: std_logic_vector(7 downto 0)  := (others => '0');						-- Registro donde se guardara la información
signal S_B: std_logic_vector(7 downto 0)  := ("00001111");
--signal S_B: std_logic_vector(7 downto 0);
begin
process(clk)
begin
		if rising_edge(clk) then 
			if Inst_Reg_In = '1' and Inst_Reg_Out = '0' then 
				S_A <= S;												-- Lee el bus de datos y lo coloca en S_A; 
			   S1 <= S(7 downto 4);				-- Coloca el Los MSB en el bus
			elsif Inst_Reg_In = '0' and Inst_Reg_Out = '1' then 
				
				S <= S_A and S_B ;							-- Coloca el Los LSB en el bus 
				
			else 
				S <= (others => 'Z');								-- Coloca la salida en alta impedancia
			end if;
		end if;	
end process;

end Arq1;
