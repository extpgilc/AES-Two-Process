library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library aes;
use aes.AesGf2Pkg.all;

entity Encoder is
   generic (
      TPD_G      : time := 1 ns);   -- Simulated propagation delay
   port (
      clk        : in  std_logic;
      srst       : in  std_logic;
      key        : in  std_logic_vector (255 downto 0);
      plaintext  : in  std_logic_vector (127 downto 0);
      ciphertext : out std_logic_vector (127 downto 0);
      done       : out std_logic);
end entity Encoder;

architecture rtl of Encoder is
   -- Constants
   constant NR : integer := 14;   -- AES has 14 rounds for a key of size 256 bits
    
   -- Types
   type StateType is (
       IDLE_S,
       KEY_SCHEDULE_S,
       FIRST_STATE_ADD_S,
       ADD_ROUND_KEY_S,
       SUB_BYTES_S,
       SHIFT_ROWS_S,
       MIX_COLUMNS_S,
       FINAL_STATE_S);
        
   type RegType is record
      number_round  : integer;
      machine_state : StateType;
      state         : std_logic_vector (127 downto 0);
   end record RegType;
   
   
   -- Register initialization
   constant REG_INIT_C : RegType := (
       number_round  => 0,
       machine_state => IDLE_S,
       state         => (others => '0'));
      
   
   -- Register interface    
   signal r   : RegType := REG_INIT_C;
   signal rin : RegType;
   
   -- Keychain
   signal keychain : key_array256;
   

begin

   ------------------------------------------------------------------------------------------------
   -- Combinational logic
   ------------------------------------------------------------------------------------------------
   comb : process (r, srst, key, plaintext)
      variable v: RegType;
   begin
      v := r;
      
      case (r.machine_state) is
         when IDLE_S =>
            v.state         := plaintext;
            v.machine_state := KEY_SCHEDULE_S;
            done            <= '0';
         
         when KEY_SCHEDULE_S =>
            -- function KeyExpansion
            keychain         <= keyScheduler256 (key);
            v.machine_state  := FIRST_STATE_ADD_S;
         
         when FIRST_STATE_ADD_S =>
            -- function AddRoundKey
            v.state         := addRoundKey (r.state, keychain (0));
            v.number_round  := r.number_round + 1;
            v.machine_state := SUB_BYTES_S;
            
         when SUB_BYTES_S =>
            -- function SubBytes
            v.state         := subBytes (r.state);
            v.machine_state := SHIFT_ROWS_S;
         
         when SHIFT_ROWS_S =>
            -- function ShiftRows
            v.state := shiftRows (r.state);
            if r.number_round = NR then
               v.machine_state := ADD_ROUND_KEY_S;
            else 
               v.machine_state := MIX_COLUMNS_S;
            end if;
            
         when MIX_COLUMNS_S =>
            -- function MixColumns
            v.state         := mixColumns (r.state);
            v.machine_state := ADD_ROUND_KEY_S;
       
         when ADD_ROUND_KEY_S =>
            -- function AddRoundKey
            v.state := addRoundKey (r.state, keychain(r.number_round));
            if r.number_round = NR then
               v.machine_state := FINAL_STATE_S;
            else
               v.machine_state := SUB_BYTES_S;
               v.number_round  := r.number_round + 1;
            end if;
            
         when FINAL_STATE_S =>
            ciphertext <= r.state;
            done       <= '1';
         
         when others =>
            v.machine_state := IDLE_S;
      end case;
      
      -- Synchronous Reset
      if (srst = '1') then
         v := REG_INIT_C;
      end if;
   
      -- Update Registers
      rin   <= v;
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
