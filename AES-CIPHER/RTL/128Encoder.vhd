library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library surf;
use surf.StdRtlPkg.all;

entity 128Encoder is
   generic (
      TPD_G      : time := 1 ns);   -- Simulated propagation delay
   port (
      clk        : in  sl;
      srst       : in  sl;
      key        : in  slv (127 downto 0);
      plaintext  : in  slv (127 downto 0);
      ciphertext : out slv (127 downto 0);
      done       : out sl);
end entity 128Encoder;

architecture rtl of 128Encoder is
   -- Constants
   constant NR : integer := 10;   -- AES has 10 rounds for a key of size 128 bits
    
   -- Types
   type StateType is (
       IDLE_S,
       FIRST_STATE_ADD_S,
       KEY_EXPANSION_S,
       ADD_ROUND_KEY_S,
       SUB_BYTES_S,
       SHIFT_ROWS_S,
       MIX_COLUMNS_S,
       FINAL_STATE_S);
        
   type RegType is record
      number_round  : integer;
      machine_state : StateType;
      round_key     : slv (127 downto 0);
      state         : slv (127 downto 0);
   end record RegType;
   
   -- Register initialization
   constant REG_INIT_C : RegType := (
       number_round  => 0,
       machine_state => IDLE_S,
       round_key     => key,
       state         => plaintext);
   
   -- Register interface    
   signal r   : RegType := REG_INIT_C;
   signal rin : RegType;
   
   -- Signals to entities
   signal key_expansion_in  : slv (127 downto 0);
   signal key_expansion_out : slv (127 downto 0);
   signal sub_bytes_in      : slv (127 downto 0);
   signal sub_bytes_out     : slv (127 downto 0);
   signal shift_rows_in     : slv (127 downto 0);
   signal shift_rows_out    : slv (127 downto 0);
   signal mix_columns_in    : slv (127 downto 0);
   signal mix_columns_out   : slv (127 downto 0);

begin

   ------------------------------------------------------------------------------------------------
   -- Entity instances
   ------------------------------------------------------------------------------------------------
   KeyExpansionInst : entity aes.KeyExpansion
      port map (
         input_data  => key_expansion_in,
         output_data => key_expansion_out);   -- Output obtained is one of the 11 round keys
   
   SubBytesInst : entity aes.SubBytes
      port map (
         input_data  => sub_bytes_in,
         output_data => sub_bytes_out);
         
   ShiftRowsInst : entity aes.ShiftRows
      port map (
         input_data  => shift_rows_in,
         output_data => shift_rows_out);
         
   MixColumnsInst : entity aes.MixColumns
      port map (
         input_data  => mix_columns_in,
         output_data => mix_columns_out);

   ------------------------------------------------------------------------------------------------
   -- Combinational logic
   ------------------------------------------------------------------------------------------------
   comb : process (r, srst, key, plaintext)
      variable v: RegType;
   begin
      v := r;
      
      case (r.machine_state) is
         when FIRST_STATE_ADD_S =>
            v.state := r.state xor r.round_key;
            v.machine_state := KEY_EXPANSION_S;
            
         when KEY_EXPANSION_S =>
            key_expansion_in := r.round_key;
            v.round_key      := key_expansion_out;
            v.machine_state  := SUB_BYTES_S;
            
         when SUB_BYTES_S =>
            sub_bytes_in    := r.state;
            v.state         := sub_bytes_out;
            v.machine_state := SHIFT_ROWS_S;
         
         when SHIFT_ROWS_S =>
            shift_rows_in   := r.state;
            v.state         := shift_rows_out;
            if r.number_round = 10 then
               v.machine_state := ADD_ROUND_KEY_S;
            else
               v.machine_state := MIX_COLUMNS_S;
            end if;
         
         when MIX_COLUMNS_S =>
            mix_columns_in  := r.state;
            v.state         := mix_columns_out;
            v.machine_state := ADD_ROUND_KEY_S;
       
         when ADD_ROUND_KEY_S =>
            v.state         := r.state xor r.round_key;
            if r.number_round = 10 then   
               v.machine_state := FINAL_STATE_S;
            else
               v.machine_state := KEY_EXPANSION_S;
               v.number_round  := r.number_round + 1;
            end if;
            
         when FINAL_STATE_S =>
            ciphertext <= r.state;
            done       <= '1';
         
         when others =>
            v.machine_state := FIRST_STATE_ADD_S;
      end case;
      
      -- Synchronous Reset
      if (srst = '1') then
         v := REG_INIT_C;
      end if;
   
      -- Update Registers
      rin <= v;
   end process comb;
   
   
   ------------------------------------------------------------------------------------------------
   -- Sequential logic
   ------------------------------------------------------------------------------------------------
   seq : process (clk)
   begin
      if rising_edge (clk) then
         r <= rin after TPD_G;
      end if;
   end process seq;


end architecture rtl;
