library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;


entity AddRoundKey is
   port (
      input1 : in  slv (127 downto 0);
      input2 : in  slv (127 downto 0);
      output : out slv (127 downto 0)
   );
end AddRoundKey;

architecture rtl of AddRoundKey is
	
begin
   output <= input1 xor input2;		
end architecture rtl;