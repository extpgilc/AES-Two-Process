library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;

entity EncController is
   generic (
      TPD_G : time := 1 ns);
   port (
      clk            : in  sl;
      rst            : in  sl;
      rconst         : out slv (7 downto 0);
      is_final_round : out sl;
      done           : out sl);
end EncController;

architecture rtl of EncController is
	
   -- Type definition
   type RegType is record
      input          : slv (7 downto 0);
	  output         : slv (7 downto 0);
   end record RegType;

   -- Constant definition
   constant REG_INIT_C : RegType := (
     input  => (others => '0'),
	 output => (others => '0'));
   
   signal feedback : slv (7 downto 0);
   
   signal r   : RegType := REG_INIT_C;
   signal rin : RegType;
	
begin

   GfmultBy2Inst : entity work.GfmultBy2
      port map(
         input_byte  => r.output,
         output_byte => feedback
      );
	  
   rconst         <= r.output;
   is_final_round <= '1' when r.output = x"36" else '0';
   done           <= '1' when r.output = x"6c" else '0';
	  
   comb : process(r, rst)
      variable v : RegType;
   begin
      v := r;
      
	  if rst = '0' then
	     v.input := x"01";
      else
	     v.input := feedback;
      end if;
	  
	  v.output := r.input;
	  
	  rin <= v;
   end process comb;
   
   sync : process(clk)
   begin
      if(rising_edge(clk)) then
         r <= rin after TPD_G;
      end if;
   end process sync;
	
end architecture rtl;