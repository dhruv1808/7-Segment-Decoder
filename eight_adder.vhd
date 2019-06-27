library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	-- For unsigned function.

entity eight_adder is
port (
	hex_A, hex_B: in	std_logic_vector(7 downto 0);							
	sum_out		: out std_logic_vector(7 downto 0)
);
end entity eight_adder;


architecture adder_logic of eight_adder is 

begin

-- Add input bits, casting to unsigned first then casting the sum back to std_logic_vector

	sum_out <= std_logic_vector(unsigned(hex_A) + unsigned(hex_B));	-- Gate logic	
	
end adder_logic;

