library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library aes;
use aes.AesGf2Pkg.all;


entity TestWrapper is
   generic (
      TPD_G      : time := 1 ns);   -- Simulated propagation delay
      
   port (
      clk             : in  std_logic;
      rst_128         : in  std_logic;
      rst_192         : in  std_logic;
      rst_256         : in  std_logic;
      key_128         : in  std_logic_vector (127 downto 0);
      key_192         : in  std_logic_vector (191 downto 0);
      key_256         : in  std_logic_vector (255 downto 0);
      plaintext       : in  std_logic_vector (127 downto 0);
      ciphertext_128  : out std_logic_vector (127 downto 0);
      decodedtext_128 : out std_logic_vector (127 downto 0);
      ciphertext_192  : out std_logic_vector (127 downto 0);
      decodedtext_192 : out std_logic_vector (127 downto 0);
      ciphertext_256  : out std_logic_vector (127 downto 0);
      decodedtext_256 : out std_logic_vector (127 downto 0);
      done_128        : out std_logic;
      done_192        : out std_logic;
      done_256        : out std_logic);
end entity TestWrapper;


architecture rtl of TestWrapper is

   -- Signals for aes 128
   signal srst_enc_128 : std_logic;
   signal srst_dec_128 : std_logic;
   signal done_enc_128 : std_logic := '0';
   signal done_dec_128 : std_logic := '0';
   
   signal encoder_input_128  : std_logic_vector (127 downto 0);
   signal encoder_output_128 : std_logic_vector (127 downto 0);
   signal decoder_output_128 : std_logic_vector (127 downto 0);
   
   -- Signals for aes 192
   signal srst_enc_192 : std_logic;
   signal srst_dec_192 : std_logic;
   signal done_enc_192 : std_logic := '0';
   signal done_dec_192 : std_logic := '0';
   
   signal encoder_input_192  : std_logic_vector (127 downto 0);
   signal encoder_output_192 : std_logic_vector (127 downto 0);
   signal decoder_output_192 : std_logic_vector (127 downto 0);
   
   -- Signals for aes 256
   signal srst_enc_256 : std_logic;
   signal srst_dec_256 : std_logic;
   signal done_enc_256 : std_logic := '0';
   signal done_dec_256 : std_logic := '0';
   
   signal encoder_input_256  : std_logic_vector (127 downto 0);
   signal encoder_output_256 : std_logic_vector (127 downto 0);
   signal decoder_output_256 : std_logic_vector (127 downto 0);

begin

   -- Combinational signal assignation 128
   encoder_input_128 <= plaintext;
   ciphertext_128  <= encoder_output_128;
   decodedtext_128 <= decoder_output_128;
   
   srst_enc_128 <= rst_128;
   srst_dec_128 <= '0' when done_enc_128 = '1' else '1';
   
   done_128 <= done_dec_128;
   
   -- Combinational signal assignation 192
   encoder_input_192 <= plaintext;
   ciphertext_192  <= encoder_output_192;
   decodedtext_192 <= decoder_output_192;
   
   srst_enc_192 <= rst_192;
   srst_dec_192 <= '0' when done_enc_192 = '1' else '1';
   
   done_192 <= done_dec_192;
  
   -- Combinational signal assignation 256   
   encoder_input_256 <= plaintext;
   ciphertext_256  <= encoder_output_256;
   decodedtext_256 <= decoder_output_256;
   
   srst_enc_256 <= rst_256;
   srst_dec_256 <= '0' when done_enc_256 = '1' else '1';
   
   done_256 <= done_dec_256;
   

   ------------------------------------------------------------------------------------------------
   -- Encoder entity
   ------------------------------------------------------------------------------------------------
   encoder_inst_256 : entity aes.Cipher
      generic map (
         TPD_G => TPD_G,
         NK    => 8 
      )
      port map (
         clk        => clk,
         srst       => srst_enc_256,
         key        => key_256,
         plaintext  => encoder_input_256,
         ciphertext => encoder_output_256,
         done       => done_enc_256);
         
   encoder_inst_192 : entity aes.Cipher
      generic map (
         TPD_G => TPD_G,
         NK    => 6 
      )
      port map (
         clk        => clk,
         srst       => srst_enc_192,
         key        => key_192,
         plaintext  => encoder_input_192,
         ciphertext => encoder_output_192,
         done       => done_enc_192);
      
   encoder_inst_128 : entity aes.Cipher
      generic map (
         TPD_G => TPD_G,
         NK    => 4 
      )
      port map (
         clk        => clk,
         srst       => srst_enc_128,
         key        => key_128,
         plaintext  => encoder_input_128,
         ciphertext => encoder_output_128,
         done       => done_enc_128);
         
         
   ------------------------------------------------------------------------------------------------
   -- Decoder entity
   ------------------------------------------------------------------------------------------------
   decoder_inst_256 : entity aes.Decipher
      generic map (
         TPD_G => TPD_G,
         NK    => 8  
      )
      port map (
         clk        => clk,
         srst       => srst_dec_256,
         key        => key_256,
         ciphertext => encoder_output_256,
         plaintext  => decoder_output_256,
         done       => done_dec_256);
         
   decoder_inst_192 : entity aes.Decipher
      generic map (
         TPD_G => TPD_G,
         NK    => 6  
      )
      port map (
         clk        => clk,
         srst       => srst_dec_192,
         key        => key_192,
         ciphertext => encoder_output_192,
         plaintext  => decoder_output_192,
         done       => done_dec_192);
         
   decoder_inst_128 : entity aes.Decipher
      generic map (
         TPD_G => TPD_G,
         NK    => 4  
      )
      port map (
         clk        => clk,
         srst       => srst_dec_128,
         key        => key_128,
         ciphertext => encoder_output_128,
         plaintext  => decoder_output_128,
         done       => done_dec_128);
         
         
end architecture rtl;
