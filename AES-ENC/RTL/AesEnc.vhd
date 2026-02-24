library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library surf;
use surf.StdRtlPkg.all;

entity AesEnc is
   generic (
      TPD_G      : time := 1 ns);   -- Simulated propagation delay
   port (
      clk        : in  sl;
	  rst        : in  sl;
	  key        : in  slv (127 downto 0);
	  plaintext  : in  slv (127 downto 0);
	  ciphertext : out slv (127 downto 0);
	  done       : out sl);
end entity AesEnc;

architecture rtl of AesEnc is
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
   
   signal subbox_input     : slv (127 downto 0);
   signal subbox_output    : slv (127 downto 0);
   signal shiftrows_output : slv (127 downto 0);
   signal mixcol_output    : slv (127 downto 0);
   signal feedback         : slv (127 downto 0);
   signal round_key        : slv (127 downto 0);
   signal round_const      : slv (7   downto 0);
   signal sel              : sl;
   
   begin
   
   -----------------------------------------------------------------------------
   -- add round key
   -----------------------------------------------------------------------------   
   AddRoundKeyInst : entity work.AddRoundKey
      port map (
	     input1 => r.output,
		 input2 => round_key,
		 output => subbox_input);
		 
   -----------------------------------------------------------------------------
   -- substitute byte
   -----------------------------------------------------------------------------   
   SubByteInst : entity work.SubByte
      port map (
	     input_data  => subbox_input,
		 output_data => subbox_output);

   -----------------------------------------------------------------------------
   -- shift rows
   -----------------------------------------------------------------------------   
   ShiftRowsInst : entity work.ShiftRows
      port map (
	     input  => subbox_output,
	     output => shiftrows_output);

   -----------------------------------------------------------------------------
   -- mix columns
   -----------------------------------------------------------------------------   		 
   MixColumnsInst : entity work.MixColumnsInst
      port map (
	     input_data  => shiftrows_output,
	     output_data => mixcol_output);

   -----------------------------------------------------------------------------
   -- feedback
   ----------------------------------------------------------------------------- 
   feedback <= mixcol_output when sel = '0' else shiftrows_output;
		 
   -----------------------------------------------------------------------------
   -- controller
   -----------------------------------------------------------------------------   
   EncControllerInst : entity work.EncController
      port map (
	     clk            => clk,
         rst            => rst,
         rconst         => round_const,
         is_final_round => sel,
         done           => done);

   -----------------------------------------------------------------------------
   -- key scheduler
   -----------------------------------------------------------------------------   
   KeyScheduleInst : entity work.KeySchedule
      port map (
	     clk         => clk,
         rst         => rst,
         key         => key,
         round_const => round_const,
         round_key   => round_key);

   -----------------------------------------------------------------------------
   -- system output
   -----------------------------------------------------------------------------
   ciphertext <= subbox_input;	
   

   -----------------------------------------------------------------------------
   -- COMBINATIONAL LOGIC
   -----------------------------------------------------------------------------   
   comb : process()
      variable v : RegType;
   begin
      v := r;

      if rst = '0' then
         v.input := plaintext;
      else
         v.input := feedback;
      end if;
	  
	  v.output := r.input;
	  
	  rin <= v;
   end process comb;
   
   -----------------------------------------------------------------------------
   -- SECUENTIAL LOGIC
   -----------------------------------------------------------------------------   
   sync : process(clk)
   begin
      if rising_edge(clk) then
         r <= rin after TPD_G;
      end if;
   end process sync;
   
   
   end architecture rtl;