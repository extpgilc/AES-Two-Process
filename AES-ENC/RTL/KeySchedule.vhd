library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;

entity KeySchedule is
   generic (
      TPD_G : time := 1 ns);  -- Simulated propagation delay
   port (
      clk         : in  sl;
      rst         : in  sl;
      key         : in  slv (127 downto 0);
      round_const : in  slv (7   downto 0);
      round_key   : out slv (127 downto 0)
   );
end KeySchedule;

architecture rtl of KeySchedule is

   -- Type definition
   type RegType is record
      input  : slv (127 downto 0);
	  output : slv (127 downto 0);
   end record RegType;

   -- Constant definition
   constant REG_INIT_C : RegType := (
     input  => (others => '0'),
	 output => (others => '0'));
   
   -- Signal definitions
   signal r   : RegType := REG_INIT_C;
   signal rin : RegType;

   signal feedback : slv (127 downto 0);
   
begin

   KeySchRoundFunctionInst : entity work.KeySchRoundFunction
      port map (
	     subkey      => r.output,
		 round_const => round_const,
		 next_subkey => feedback);
   
   -- Se asigna valor a la salida del bloque
   round_key <= r.output;

   -- Combinational logic
   comb : process(r, rst, key, feedback, round_const)
      variable v : RegType;
   begin
      v := r;
	  
	  if rst = '0' then
	     v.input := key;
      else 
	     v.input := feedback;
	  end if;
	  
	  v.output := r.input;
	  
	  rin <= v;
   end process comb;
   
   -- Secuential logic
   sync : process(clk)
   begin
      if(rising_edge(clk)) then
	     r <= rin after TPD_G;
      end if;
   end process sync;
   
end architecture rtl;