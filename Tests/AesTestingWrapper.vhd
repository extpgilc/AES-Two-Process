library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library aes;
use aes.AesGf2Pkg.all;


entity TestWrapper is    
   port (
      clk             : in  std_logic;
      srst            : in  std_logic;
      key_128         : in  std_logic_vector (127 downto 0);
      key_192         : in  std_logic_vector (191 downto 0);
      key_256         : in  std_logic_vector (255 downto 0);
      input_enc       : in  std_logic_vector (127 downto 0);
      input_dec_128   : in  std_logic_vector (127 downto 0);
      input_dec_192   : in  std_logic_vector (127 downto 0);
      input_dec_256   : in  std_logic_vector (127 downto 0);
      ciphertext_128  : out std_logic_vector (127 downto 0);
      plaintext_128   : out std_logic_vector (127 downto 0);
      ciphertext_192  : out std_logic_vector (127 downto 0);
      plaintext_192   : out std_logic_vector (127 downto 0);
      ciphertext_256  : out std_logic_vector (127 downto 0);
      plaintext_256   : out std_logic_vector (127 downto 0);
      start_enc_128   : in  std_logic;
      start_dec_128   : in  std_logic;
      start_enc_192   : in  std_logic;
      start_dec_192   : in  std_logic;
      start_enc_256   : in  std_logic;
      start_dec_256   : in  std_logic;
      clear_enc_128   : in  std_logic;
      clear_dec_128   : in  std_logic;
      clear_enc_192   : in  std_logic;
      clear_dec_192   : in  std_logic;
      clear_enc_256   : in  std_logic;
      clear_dec_256   : in  std_logic;
      done_enc_128    : out std_logic;
      done_dec_128    : out std_logic;
      done_enc_192    : out std_logic;
      done_dec_192    : out std_logic;
      done_enc_256    : out std_logic;
      done_dec_256    : out std_logic);
end entity TestWrapper;


architecture rtl of TestWrapper is


	
begin

   

   ------------------------------------------------------------------------------------------------
   -- Encoder entity
   ------------------------------------------------------------------------------------------------
   encoder_inst_256 : entity aes.Cipher
      generic map (
         -- TPD_G => TPD_G,
         NK    => 8 
      )
      port map (
         clk        => clk,
         srst       => srst,
         key        => key_256,
         plaintext  => input_enc,
         ciphertext => ciphertext_256,
         start      => start_enc_256,
         clear      => clear_enc_256,
         done       => done_enc_256);
         
   encoder_inst_192 : entity aes.Cipher
      generic map (
         -- TPD_G => TPD_G,
         NK    => 6 
      )
      port map (
         clk        => clk,
         srst       => srst,
         key        => key_192,
         plaintext  => input_enc,
         ciphertext => ciphertext_192,
         start      => start_enc_192,
         clear      => clear_enc_192,
         done       => done_enc_192);
      
   encoder_inst_128 : entity aes.Cipher
      generic map (
         -- TPD_G => TPD_G,
         NK    => 4 
      )
      port map (
         clk        => clk,
         srst       => srst,
         key        => key_128,
         plaintext  => input_enc,
         ciphertext => ciphertext_128,
         start      => start_enc_128,
         clear      => clear_enc_128,
         done       => done_enc_128);
         
         
   ------------------------------------------------------------------------------------------------
   -- Decoder entity
   ------------------------------------------------------------------------------------------------
   decoder_inst_256 : entity aes.Decipher
      generic map (
         -- TPD_G => TPD_G,
         NK    => 8  
      )
      port map (
         clk        => clk,
         srst       => srst,
         key        => key_256,
         ciphertext => input_dec_256,
         plaintext  => plaintext_256,
         start      => start_dec_256,
         clear      => clear_dec_256,
         done       => done_dec_256);
         
   decoder_inst_192 : entity aes.Decipher
      generic map (
         -- TPD_G => TPD_G,
         NK    => 6  
      )
      port map (
         clk        => clk,
         srst       => srst,
         key        => key_192,
         ciphertext => input_dec_192,
         plaintext  => plaintext_192,
         start      => start_dec_192,
         clear      => clear_dec_192,
         done       => done_dec_192);
         
   decoder_inst_128 : entity aes.Decipher
      generic map (
         -- TPD_G => TPD_G,
         NK    => 4  
      )
      port map (
         clk        => clk,
         srst       => srst,
         key        => key_128,
         ciphertext => input_dec_128,
         plaintext  => plaintext_128,
         start      => start_dec_128,
         clear      => clear_dec_128,
         done       => done_dec_128);
         
         
end architecture rtl;
