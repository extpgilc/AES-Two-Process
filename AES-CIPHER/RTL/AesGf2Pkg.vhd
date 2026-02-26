library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library surf;
use surf.StdRtlPkg.all;

package AesGf2Pkg is

   -- Main operation functionns
   function addRoundKey (state : slv (127 downto 0); key : slv (127 downto 0)) return slv (127 downto 0);
   function subBytes    (state : slv (127 downto 0)) return slv (127 downto 0);
   function shiftRows   (state : slv (127 downto 0)) return slv (127 downto 0);
   function mixColumns  (state : slv (127 downto 0)) return slv (127 downto 0);

   -- Auxialiary functions
   function columnCalculator (column : slv (31 downto 0)) return slv (31 downto 0);
   function sBox             (byte   : slv (7  downto 0)) return slv (7  downto 0);

end AesGf2Pkg;

package body AesGf2Pkg is

   function mixColumns (
      state : slv (127 downto 0)) return slv (127 downto 0) is
      variable output_data : slv (127 downto 0);
   begin
      output_data (31  downto  0) := columnCalculator (state (31  downto  0));
      output_data (63  downto 32) := columnCalculator (state (63  downto 32));
      output_data (95  downto 64) := columnCalculator (state (95  downto 64));
      output_data (127 downto 96) := columnCalculator (state (127 downto 96));
      return output_data;
   end function mixColumns;

   function subBytes (
      state : slv (127 downto 0)) return slv (127 downto 0) is
      variable output_data : slv (127 downto 0);
   begin
      for i 0 to 15 loop
         output_data ((i + 1)*8 - 1 downto i*8) := 
            sBox (state((i + 1)*8 - 1 downto i*8));
      end loop;
      return output_data;
   end function subBytes;

   function shiftRows (
      state : slv (127 downto 0)) return slv (127 downto 0) is
      variable output_data : slv (127 downto 0); 
   begin
      output_data (8*16 - 1 downto 8*15) := state (8*12 - 1 downto 8*11);
      output_data (8*15 - 1 downto 8*14) := state (8*7  - 1 downto  8*6);
      output_data (8*14 - 1 downto 8*13) := state (8*2  - 1 downto  8*1); 
      output_data (8*13 - 1 downto 8*12) := state (8*13 - 1 downto 8*12);
      output_data (8*12 - 1 downto 8*11) := state (8*8  - 1 downto  8*7);
      output_data (8*11 - 1 downto 8*10) := state (8*3  - 1 downto  8*2); 
      output_data (8*10 - 1 downto  8*9) := state (8*14 - 1 downto 8*13);
      output_data (8*9 - 1  downto  8*8) := state (8*9  - 1 downto  8*8);
      output_data (8*8 - 1  downto  8*7) := state (8*4  - 1 downto  8*3);
      output_data (8*7 - 1  downto  8*6) := state (8*15 - 1 downto 8*14);
      output_data (8*6 - 1  downto  8*5) := state (8*10 - 1 downto  8*9);
      output_data (8*5 - 1  downto  8*4) := state (8*5  - 1 downto  8*4);
      output_data (8*4 - 1  downto  8*3) := state (8*16 - 1 downto 8*15);
      output_data (8*3 - 1  downto  8*2) := state (8*11 - 1 downto 8*10);
      output_data (8*2 - 1  downto  8*1) := state (8*6  - 1 downto  8*5);
      output_data (8*1 - 1  downto  8*0) := state (8*1  - 1 downto  8*0); 
      return output_data;
   end function shiftRows;

   function addRoundKey (
      state : slv (127 downto 0);
      key   : slv (127 downto 0)) return slv (127 downto 0) is
   begin
      return state xor key;
   end function addRoundKey;


end package body AesGf2Pkg;
