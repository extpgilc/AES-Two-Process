library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library aes;
use aes.AesGf2Pkg.all;


entity TestWrapper is
   generic (
      TPD_G      : time := 1 ns);   -- Simulated propagation delay
   port (
      clk         : in  std_logic;
      rst         : in  std_logic;
      key         : in  std_logic_vector (127 downto 0);
      plaintext   : in  std_logic_vector (127 downto 0);
      ciphertext  : out std_logic_vector (127 downto 0);
      decodedtext : out std_logic_vector (127 downto 0);
      done        : out std_logic);
end entity TestWrapper;


architecture rtl of TestWrapper is

   signal srst_enc : std_logic;
   signal srst_dec : std_logic;
   signal done_enc : std_logic := '0';
   signal done_dec : std_logic := '0';
   
   signal encoder_input  : std_logic_vector (127 downto 0);
   signal encoder_output : std_logic_vector (127 downto 0);
   signal decoder_output : std_logic_vector (127 downto 0);

begin

   -- Combinational signal assignation
   encoder_input <= plaintext;
   ciphertext  <= encoder_output;
   decodedtext <= decoder_output;
   
   srst_enc <= rst;
   srst_dec <= '0' when done_enc = '1' else '1';
   
   done <= done_dec;

   ------------------------------------------------------------------------------------------------
   -- Encoder entity
   ------------------------------------------------------------------------------------------------
   encoder_inst : entity aes.Encoder
      generic map (
         TPD_G => TPD_G 
      )
      port map (
         clk        => clk,
         srst       => srst_enc,
         key        => key,
         plaintext  => encoder_input,
         ciphertext => encoder_output,
         done       => done_enc);
         
         
   ------------------------------------------------------------------------------------------------
   -- Decoder entity
   ------------------------------------------------------------------------------------------------
   decoder_inst : entity aes.Decoder
      generic map (
         TPD_G => TPD_G 
      )
      port map (
         clk        => clk,
         srst       => srst_dec,
         key        => key,
         ciphertext => encoder_output,
         plaintext  => decoder_output,
         done       => done_dec);
         
         
end architecture rtl;
