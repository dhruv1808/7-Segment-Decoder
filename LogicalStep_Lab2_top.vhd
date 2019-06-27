library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab2_top is port (
   clkin_50			: in	std_logic;
	pb					: in	std_logic_vector(3 downto 0);
 	sw   				: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds				: out std_logic_vector(7 downto 0); -- for displaying the switch content
   seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  	: out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  	: out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab2_top;

architecture SimpleCircuit of LogicalStep_Lab2_top is

-- Components Used ---
------------------------------------------------------------------- 
   component eight_2to1_mux port (
		hex_AB, sum : in	std_logic_vector(7 downto 0); 
		mux_select	: in	std_logic;				         -- Only needs 1 input for selection.
		num_out		: out std_logic_vector(7 downto 0)	-- The selected output bit
	);
	end component;
	
	component eight_adder port (
		hex_A, hex_B: in	std_logic_vector(7 downto 0);							
		sum_out		: out std_logic_vector(7 downto 0)
	);
	end component;
	
	component logic_processor port (
		hex_A, hex_B: in	std_logic_vector(3 downto 0);
		logic_select: in 	std_logic_vector(2 downto 0);-- "000", "001", "100", "010". pb[0..2]
		logic_out	: out std_logic_vector(3 downto 0)
	);
	end component;
		
	component SevenSegment port (
		hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
		sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
	); 
	end component;
		
	component segment7_mux port (
		clk		: in	std_logic := '0';
		DIN2		: in	std_logic_vector(6 downto 0);
		DIN1		: in	std_logic_vector(6 downto 0);
		DOUT		: out	std_logic_vector(6 downto 0);
		DIG2		: out	std_logic;
		DIG1		: out	std_logic
	);
	end component;
	
	component pb_validation port (
		pbs								: in std_logic_vector(3 downto 0);		-- Push buttons 3..0
		seg7_in_A, seg7_in_B	 		: in std_logic_vector(6 downto 0);
		led_in		 					: in std_logic_vector(7 downto 0);
		seg7_out_A, seg7_out_B	 	: out std_logic_vector(6 downto 0);
		led_out		 					: out std_logic_vector(7 downto 0)
	);
	end component;
	
-- Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--
	signal sum			: std_logic_vector(7 downto 0);
	signal hex_A		: std_logic_vector(3 downto 0);
	signal hex_B		: std_logic_vector(3 downto 0);

	signal hex_lout	: std_logic_vector(3 downto 0);
	
   signal hex_AB		: std_logic_vector(7 downto 0);
	signal hex_temp	: std_logic_vector(7 downto 0);
	
	signal hex_A_seg	: std_logic_vector(3 downto 0);
	signal hex_B_seg	: std_logic_vector(7 downto 4);
	signal seg7_A		: std_logic_vector(6 downto 0);
	signal seg7_B		: std_logic_vector(6 downto 0);
	
	signal leds_temp	: std_logic_vector(7 downto 0);
	signal seg7_A_out	: std_logic_vector(6 downto 0);
	signal seg7_B_out	: std_logic_vector(6 downto 0);
	
	
-- Here the circuit begins

begin	
		
	hex_A <= sw(3 downto 0); -- & used for concatenation
	hex_B <= sw(7 downto 4);
		
	INST1: eight_adder port map("0000" & hex_A, "0000" & hex_B, sum);
	
	hex_AB <= sw(7 downto 0);
	
	INST2: logic_processor port map(hex_A, hex_B, NOT(pb(2 downto 0)), hex_lout); -- ** May not work, not function may not apply to multiple bits
	
---------- 7-segment display code (raw concatenated output or adder output) -----------
	INST3: eight_2to1_mux port map(hex_AB, sum, NOT(pb(3)), hex_temp); 
	
	hex_A_seg <= hex_temp(3 downto 0);
	hex_B_seg <= hex_temp(7 downto 4);	
	
-- With hex_A and hex_B as inputs, generate the seven segment coding
	
	INST4: SevenSegment port map(hex_A_seg, seg7_A);
	INST5: SevenSegment port map(hex_B_seg, seg7_B);
	

-- NOTE: Since the lab states that an error must be outputted if two or more of ANY PB buttons are pressed, the inputs have been switched to accomodate this.
	INST6: eight_2to1_mux port map("0000" & hex_lout, sum, NOT(pb(3)), leds_temp);
	
-- Intercept output variables seg7_A, seg7_B and leds_temp and check against input buttons pressed.
	INST7: pb_validation port map(NOT(pb(3 downto 0)), seg7_A, seg7_B, leds_temp, seg7_A_out, seg7_B_out, leds); -- leds is directly outputted to this chip's pin.


-- Special mux function for the 7-segment displays.
	INST8: segment7_mux port map(clkin_50, seg7_A_out, seg7_B_out, seg7_data, seg7_char2, seg7_char1);	-- Inputs A and B for DIN2, DIN1 respectively.

end SimpleCircuit;


