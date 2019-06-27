library ieee;
use ieee.std_logic_1164.all;

entity pb_validation is
port (
	pbs								: in std_logic_vector(3 downto 0);		-- Push buttons 3..0
	seg7_in_A, seg7_in_B	 		: in std_logic_vector(6 downto 0);
	led_in		 					: in std_logic_vector(7 downto 0);
	seg7_out_A, seg7_out_B	 	: out std_logic_vector(6 downto 0);
	led_out		 					: out std_logic_vector(7 downto 0)
);
end pb_validation;

architecture validation_logic of pb_validation is

-- Temporary variable declarations.
signal is_valid 	: std_logic;


begin

with pbs select
	is_valid <= '1' when "1000",
					'1' when "0100",
					'1' when "0010",
					'1' when "0001",
					'1' when "0000",
					'0' when others;
					
					
with is_valid select
	seg7_out_A <= seg7_in_A when '1',
					  "1111111" when others;
					  
with is_valid select
	seg7_out_B <= seg7_in_B when '1',
					  "1111111" when others;
					  
with is_valid select
	led_out <= led_in when '1',
				  "11111111" when others;
					
end validation_logic;