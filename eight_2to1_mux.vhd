library ieee;
use ieee.std_logic_1164.all;


entity eight_2to1_mux is
port (
	hex_AB, sum : in	std_logic_vector(7 downto 0);
	mux_select	: in	std_logic;							-- Only needs 1 input for selection.
	num_out		: out std_logic_vector(7 downto 0)	-- The selected output bit
);

end entity eight_2to1_mux;


architecture mux_logic of eight_2to1_mux is 

begin

-- Multiplexing of 2 8-bit input buses (either the combination of 2 hex numbers or the sum of the numbers)
with mux_select select
	num_out <= hex_AB when '0',
				  sum when '1';
	
end mux_logic;

--DOUT <= sum WHEN (PB(3) = '1') ELSE hex_AB;