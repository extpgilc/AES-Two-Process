library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library aes;
use aes.AesGf2Pkg.all;

entity Decoder is
   generic (
      TPD_G      : time := 1 ns);   -- Simulated propagation delay
   port (
      clk        : in  std_logic;
      srst       : in  std_logic;
      key        : in  std_logic_vector (255 downto 0);
      ciphertext : in  std_logic_vector (127 downto 0);
      plaintext  : out std_logic_vector (127 downto 0);
      done       : out std_logic);
end entity Decoder;

architecture rtl of Decoder is
-- Constants
   constant NR : integer := 14;   -- AES has 14 rounds for a key of size 256 bits
    
   -- Types
   type StateType is (
      IDLE_S,
      KEY_SCHEDULE_S,
      FIRST_STATE_ADD_S,
      INV_SHIFT_ROWS_S,
      INV_SUB_BYTES_S,
      ADD_ROUND_KEY_S,
      INV_MIX_COLUMNS_S,
      FINAL_STATE_S);
        
   type RegType is record
      number_round  : integer;
      machine_state : StateType;
      state         : std_logic_vector (127 downto 0);
      keychain      : key_array256;
   end record RegType;
   
   
   -- Register initialization
   constant REG_INIT_C : RegType := (
       number_round  => NR,
       machine_state => IDLE_S,
       state         => (others => '0'),
       keychain      => (others => (others => '0')));
      
   
   -- Register interface    
   signal r   : RegType := REG_INIT_C;
   signal rin : RegType;
   
   
begin

   ------------------------------------------------------------------------------------------------
   -- Combinational logic
   ------------------------------------------------------------------------------------------------
   comb : process (r, srst, key, ciphertext)
      variable v: RegType;
   begin
      v := r;
      
      case (r.machine_state) is
         when IDLE_S =>
            v.state         := ciphertext;
            v.machine_state := KEY_SCHEDULE_S;
            done            <= '0';
         
         when KEY_SCHEDULE_S =>
            v.keychain      := keyScheduler256 (key);
            v.machine_state := FIRST_STATE_ADD_S;
         
         when FIRST_STATE_ADD_S =>
            v.state         := addRoundKey (r.state, r.keychain (r.number_round));
            v.number_round  := r.number_round - 1;
            v.machine_state := INV_SHIFT_ROWS_S;
         
         when INV_SHIFT_ROWS_S =>
            v.state         := invShiftRows (r.state);
            v.machine_state := INV_SUB_BYTES_S;
         
         when INV_SUB_BYTES_S =>
            v.state         := invSubBytes (r.state);
            v.machine_state := ADD_ROUND_KEY_S;
         
         when ADD_ROUND_KEY_S =>
            v.state := addRoundKey (r.state, r.keychain (r.number_round));
            if r.number_round = 0 then
               v.machine_state := FINAL_STATE_S;
            else
               v.number_round  := r.number_round - 1;
               v.machine_state := INV_MIX_COLUMNS_S;
            end if;
         
         when INV_MIX_COLUMNS_S =>
            v.state         := invMixColumns (r.state);
            v.machine_state := INV_SHIFT_ROWS_S;
         
         when FINAL_STATE_S =>
            plaintext <= r.state;
            done      <= '1';
      
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
