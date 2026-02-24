library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;

entity SubByte is
   port (
      input_data  : in  slv (127 downto 0);
      output_data : out slv (127 downto 0)
   );
end SubByte;

architecture rtl of SubByte is
	
begin
   gen : for i in 0 to 15 generate
      SboxInst : entity work.Sbox
         port map(
            input_byte  => input_data  ((i + 1)*8 - 1 downto i*8),
            output_byte => output_data ((i + 1)*8 - 1 downto i*8)
         );		
   end generate gen;
	
end architecture rtl;