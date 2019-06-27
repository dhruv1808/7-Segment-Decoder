library ieee;
use ieee.std_logic_1164.all;


entity logic_processor is
port (
	hex_A, hex_B: in	std_logic_vector(3 downto 0);
	logic_select: in 	std_logic_vector(2 downto 0);-- "000", "001", "100", "010". pb[0..2]
	logic_out	: out std_logic_vector(3 downto 0)
);

end logic_processor;

-- when more than 1 button pressed pb[0..2] ERROR

architecture processor_logic of logic_processor is

-- Define temporary vars
signal and_AB: std_logic_vector(3 downto 0);
signal or_AB: std_logic_vector(3 downto 0);
signal xor_AB: std_logic_vector(3 downto 0);

begin

-- Set values for temp vars
and_AB <= hex_A AND hex_B;
or_AB <= hex_A OR hex_B;
xor_AB <= hex_A XOR hex_B;

-- Select correct calculation to output:
-- NOTE: This gate does not worry about cases that aren't covered.
with logic_select select
	logic_out <= and_AB when "001",
				    or_AB when "010",
					 xor_AB when "100",
					 "0000" when others;	-- When any other button combination occurs, only output 0000. 
end processor_logic;
