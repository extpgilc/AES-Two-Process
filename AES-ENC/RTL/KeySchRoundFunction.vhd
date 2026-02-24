library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;

entity KeySchRoundFunction is
   port (		
      subkey      : in  slv (127 downto 0);
      round_const : in  slv (7   downto 0);
      next_subkey : out slv (127 downto 0)		
   );
end KeySchRoundFunction;

architecture rtl of KeySchRoundFunction is

   signal substitued_sk  : slv (31 downto 0);
   signal shifted_sk     : slv (31 downto 0);
   signal w3, w2, w1, w0 : slv (31 downto 0);

begin

   gen_sboxes : for i in 12 to 15 generate
      sbox_inst : entity work.sbox
         port map(
            input_byte  => subkey((i + 1)*8 - 1 downto i*8),
            output_byte => substitued_sk((i + 1 - 12)*8 - 1 downto (i - 12)*8)
         );			
   end generate gen_sboxes;
	
   shifted_sk <= substitued_sk (7  downto 0) & substitued_sk (31 downto 8);
   w0 (31 downto 8) <= subkey  (31 downto 8) xor shifted_sk  (31 downto 8);
   w0 (7 downto  0) <= subkey  (7  downto 0) xor round_const xor shifted_sk (7 downto 0);
   w1 <= subkey (63  downto 32) xor w0;
   w2 <= subkey (95  downto 64) xor w1;
   w3 <= subkey (127 downto 96) xor w2;
   next_subkey <= w3 & w2 & w1 & w0;
		
end architecture rtl;