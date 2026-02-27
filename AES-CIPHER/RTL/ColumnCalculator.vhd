library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;

entity ColumnCalculator is
   port (
      input_data  : in  slv (31 downto 0);
      output_data : out slv (31 downto 0)
   );
end ColumnCalculator;

architecture rtl of ColumnCalculator is
   signal temp    : slv (7 downto 0);
   signal temp0   : slv (7 downto 0);
   signal temp1   : slv (7 downto 0);
   signal temp2   : slv (7 downto 0);
   signal temp3   : slv (7 downto 0);
   signal temp0x2 : slv (7 downto 0);
   signal temp1x2 : slv (7 downto 0);
   signal temp2x2 : slv (7 downto 0);
   signal temp3x2 : slv (7 downto 0);	
begin
   temp  <= input_data (31 downto 24) xor input_data (23 downto 16) xor input_data(15 downto 8) xor input_data(7 downto 0);
   temp0 <= input_data (7  downto  0) xor input_data (15 downto  8);
   temp1 <= input_data (15 downto  8) xor input_data (23 downto 16);
   temp2 <= input_data (23 downto 16) xor input_data (31 downto 24);
   temp3 <= input_data (31 downto 24) xor input_data (7  downto  0);
   GfmultBy2Inst0 : entity work.GfmultBy2
      port map (
         input_byte  => temp0,
         output_byte => temp0x2
      );
   GfmultBy2Inst1 : entity work.GfmultBy2
      port map (
         input_byte  => temp1,
         output_byte => temp1x2
      );
   GfmultBy2Inst2 : entity work.GfmultBy2
      port map (
         input_byte  => temp2,
         output_byte => temp2x2
      );
   GfmultBy2Inst3 : entity work.GfmultBy2
      port map (
         input_byte  => temp3,
         output_byte => temp3x2
      );
   output_data (7  downto  0) <= input_data (7  downto  0) xor temp0x2 xor temp;
   output_data (15 downto  8) <= input_data (15 downto  8) xor temp1x2 xor temp;
   output_data (23 downto 16) <= input_data (23 downto 16) xor temp2x2 xor temp;
   output_data (31 downto 24) <= input_data (31 downto 24) xor temp3x2 xor temp; 	
	
end architecture rtl;