library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;

entity GfmultBy2 is
   port (
      input_byte  : in  slv (7 downto 0);
      output_byte : out slv (7 downto 0)
   );
end GfmultBy2;

architecture rtl of GfmultBy2 is
   signal shifted_byte    : slv (7 downto 0);
   signal conditional_xor : slv (7 downto 0);
begin
   shifted_byte    <= input_byte (6 downto 0) & "0";
   conditional_xor <= "000" & input_byte(7) & input_byte(7) & "0" & input_byte(7) & input_byte(7);
   output_byte     <= shifted_byte xor conditional_xor;
	
end architecture rtl;