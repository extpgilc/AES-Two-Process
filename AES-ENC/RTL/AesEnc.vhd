library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library surf;
use surf.StdRtlPkg.all;


entity AesEnc is
   generic (
   
      TPD_G   : time   := 1 ns);   -- Simulated propagation delay
   port (
       clk         : in  sl;
	   rst         : in  sl;
	   key         : in  slv (127 downto 0);
	   plaintext   : in  slv (127 downto 0);
	   ciphertext  : out slv (127 downto 0);
	   done        : out sl	
   );
end entity AesEnc;

architecture rtl of AesEnc is

   -----------------------------------------------------------------------------
   -- Constants
   -----------------------------------------------------------------------------
   
   -----------------------------------------------------------------------------
   -- Types
   -----------------------------------------------------------------------------

   -----------------------------------------------------------------------------
   -- Signals
   -----------------------------------------------------------------------------
   -- Register interface
   -- signal r   : RegType := REG_INIT_C;
   -- signal rin : RegType;
   
   begin
   
   -----------------------------------------------------------------------------
   -- Instances
   -----------------------------------------------------------------------------   

   comb : process()
      -- variables
   begin
      -- combinational logic
   end process comb;
   
   
   
   reg : process(clk)
   begin
      -- registered logic
   end process reg;
   
   
   end architecture rtl;