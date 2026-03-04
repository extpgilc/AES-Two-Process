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
      key        : in  std_logic_vector (127 downto 0);
      ciphertext : in  std_logic_vector (127 downto 0);
      plaintext  : out std_logic_vector (127 downto 0);
      done       : out std_logic);
end entity Decoder;

architecture rtl of Encoder is
-- Constants
   constant NR : integer := 10;   -- AES has 10 rounds for a key of size 128 bits
    
   -- Types
   type StateType is (
       );
        
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
   
   
begin

   ------------------------------------------------------------------------------------------------
   -- Combinational logic
   ------------------------------------------------------------------------------------------------
   comb : process (r, srst, key, plaintext)
      variable v: RegType;
   begin
      v := r;
      
      case (r.machine_state) is
      
         when others =>
            done            <= '0';
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
