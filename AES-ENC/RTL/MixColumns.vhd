library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;


entity MixColumns is
   port (
      input_data  : in  slv (127 downto 0);
      output_data : out slv (127 downto 0)
   );
end MixColumns;

architecture rtl of MixColumns is
	
begin
   MixColumnsInst0 : entity work.ColumnCalculator
      port map(
         input_data  => input_data (31 downto 0),
         output_data => output_data(31 downto 0)
      );
   MixColumnsInst1 : entity work.ColumnCalculator
      port map(
         input_data  => input_data (63 downto 32),
         output_data => output_data(63 downto 32)
      );		
   MixColumnsInst2 : entity work.ColumnCalculator
      port map(
         input_data  => input_data  (95 downto 64),
         output_data => output_data (95 downto 64)
      );
   MixColumnsInst3 : entity work.ColumnCalculator
      port map(
         input_data  => input_data  (127 downto 96),
         output_data => output_data (127 downto 96)
      );	
end architecture rtl;