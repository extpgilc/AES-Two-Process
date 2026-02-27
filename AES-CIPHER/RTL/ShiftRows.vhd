library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;

entity ShiftRows is
   port (
      input_data  : in  slv (127 downto 0);
      output_data : out slv (127 downto 0)
   );
end ShiftRows;

architecture rtl of ShiftRows is
	
begin
   output_data (8*16 - 1 downto 8*15) <= input_data (8*12 - 1 downto 8*11);
   output_data (8*15 - 1 downto 8*14) <= input_data (8*7  - 1 downto  8*6);
   output_data (8*14 - 1 downto 8*13) <= input_data (8*2  - 1 downto  8*1); 
   output_data (8*13 - 1 downto 8*12) <= input_data (8*13 - 1 downto 8*12);
   output_data (8*12 - 1 downto 8*11) <= input_data (8*8  - 1 downto  8*7);
   output_data (8*11 - 1 downto 8*10) <= input_data (8*3  - 1 downto  8*2); 
   output_data (8*10 - 1 downto  8*9) <= input_data (8*14 - 1 downto 8*13);
   output_data (8*9 - 1  downto  8*8) <= input_data (8*9  - 1 downto  8*8);
   output_data (8*8 - 1  downto  8*7) <= input_data (8*4  - 1 downto  8*3);
   output_data (8*7 - 1  downto  8*6) <= input_data (8*15 - 1 downto 8*14);
   output_data (8*6 - 1  downto  8*5) <= input_data (8*10 - 1 downto  8*9);
   output_data (8*5 - 1  downto  8*4) <= input_data (8*5  - 1 downto  8*4);
   output_data (8*4 - 1  downto  8*3) <= input_data (8*16 - 1 downto 8*15);
   output_data (8*3 - 1  downto  8*2) <= input_data (8*11 - 1 downto 8*10);
   output_data (8*2 - 1  downto  8*1) <= input_data (8*6  - 1 downto  8*5);
   output_data (8*1 - 1  downto  8*0) <= input_data (8*1  - 1 downto  8*0); 	
end architecture rtl;
