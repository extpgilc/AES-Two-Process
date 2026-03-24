# test_aes_cipher.py
import logging
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge



def to_hex128(value: int) -> str:
    """Formato bonito para logging."""
    return f"0x{value:032X}"

async def run_one_iteration(dut, key_128_int, key_192_int, key_256_int, plaintext_int, ciphertext_int_128, ciphertext_int_192, ciphertext_int_256, iteration):
    """Ejecuta una iteración del flujo AES completo."""

    cocotb.log.info(f"\n========== ITERACIÓN {iteration} ==========")

    # 1) Start a 0
    dut.start_enc_128.value = 0
    dut.start_enc_192.value = 0
    dut.start_enc_256.value = 0
    dut.start_dec_128.value = 0
    dut.start_dec_192.value = 0
    dut.start_dec_256.value = 0
    await RisingEdge(dut.clk)

    # 2) Cargar entradas
    dut.key_128.value = key_128_int
    dut.key_192.value = key_192_int
    dut.key_256.value = key_256_int
    dut.input_enc.value = plaintext_int
    dut.input_dec_128.value = ciphertext_int_128
    dut.input_dec_192.value = ciphertext_int_192
    dut.input_dec_256.value = ciphertext_int_256
    dut.clear_enc_128.value = 1
    dut.clear_enc_192.value = 1
    dut.clear_enc_256.value = 1
    dut.clear_dec_128.value = 1
    dut.clear_dec_192.value = 1
    dut.clear_dec_256.value = 1
    await RisingEdge(dut.clk)
    dut.clear_enc_128.value = 0
    dut.clear_enc_192.value = 0
    dut.clear_enc_256.value = 0
    dut.clear_dec_128.value = 0
    dut.clear_dec_192.value = 0
    dut.clear_dec_256.value = 0

    # cocotb.log.info(f"[{iteration}] KEY 128    = {to_hex128(key_128_int)}")
    # cocotb.log.info(f"[{iteration}] KEY 192    = {to_hex128(key_192_int)}")
    # cocotb.log.info(f"[{iteration}] KEY 256    = {to_hex128(key_256_int)}")
    cocotb.log.info(f"[{iteration}] PLAINTEXT      = {to_hex128(plaintext_int)}")

    # 3) Permitir start
    dut.start_enc_128.value = 1
    dut.start_enc_192.value = 1
    dut.start_enc_256.value = 1
    dut.start_dec_128.value = 1
    dut.start_dec_192.value = 1
    dut.start_dec_256.value = 1
    await RisingEdge(dut.clk)


    # 4.1) Esperar done_enc_128 = '1'
    while dut.done_enc_128.value != 1:
        await RisingEdge(dut.clk)
        
    # 4.2) Esperar done_enc_192 = '1'
    while dut.done_enc_192.value != 1:
        await RisingEdge(dut.clk)
        
    # 4.3) Esperar done_enc_256 = '1'
    while dut.done_enc_256.value != 1:
        await RisingEdge(dut.clk)
        
    # 4.4) Esperar done_dec_128 = '1'
    while dut.done_dec_128.value != 1:
        await RisingEdge(dut.clk)
        
    # 4.5) Esperar done_dec_192 = '1'
    while dut.done_dec_192.value != 1:
        await RisingEdge(dut.clk)
        
    # 4.6) Esperar done_dec_256 = '1'
    while dut.done_dec_256.value != 1:
        await RisingEdge(dut.clk)

    # 5.1) Loggear resultados aes 128
    cipher_128_int = int(dut.ciphertext_128.value)
    deciphered_128_int = int(dut.plaintext_128.value)
    
    cocotb.log.info(f"[{iteration}] CIPHERTEXT 128 = {to_hex128(cipher_128_int)}")
    cocotb.log.info(f"[{iteration}] DECIPHERED 128 = {to_hex128(deciphered_128_int)}")
    
    # 5.2) Loggear resultados aes 192
    cipher_192_int = int(dut.ciphertext_192.value)
    deciphered_192_int = int(dut.plaintext_192.value)
    
    cocotb.log.info(f"[{iteration}] CIPHERTEXT 192 = {to_hex128(cipher_192_int)}")
    cocotb.log.info(f"[{iteration}] DECIPHERED 192 = {to_hex128(deciphered_192_int)}")
    
    # 5.3) Loggear resultados aes 256
    cipher_256_int = int(dut.ciphertext_256.value)
    deciphered_256_int = int(dut.plaintext_256.value)

    cocotb.log.info(f"[{iteration}] CIPHERTEXT 256 = {to_hex128(cipher_256_int)}")
    cocotb.log.info(f"[{iteration}] DECIPHERED 256 = {to_hex128(deciphered_256_int)}")

    # 6.1) Verificación aes 128
    if deciphered_128_int != plaintext_int or cipher_128_int != ciphertext_int_128:
        raise AssertionError(
            f"Iteration {iteration}: deciphered != plaintext for key size 128"
        )

    # 6.2) Verificación aes 192
    if deciphered_192_int != plaintext_int or cipher_192_int != ciphertext_int_192:
         raise AssertionError(
            f"Iteration {iteration}: deciphered != plaintext for key size 192"
        )

    # 6.3) Verificación aes 256
    if deciphered_256_int != plaintext_int or cipher_256_int != ciphertext_int_256:
        raise AssertionError(
            f"Iteration {iteration}: deciphered != plaintext for key size 256"
        )

    # 7) Final message
    cocotb.log.info(f"[{iteration}] RESULT OK (all 3 deciphered outputs == plaintext)")


@cocotb.test()
async def aes_encrypt_decrypt_test(dut):
    """Test completo: 4 ejemplos con una key para cada longitud de clave y 4 plaintext distintos."""

    cocotb.log.info("=== INICIO TEST AES ===")
    
    # Reset a '0'
    dut.srst.value = 0

    # Crear reloj (10 ns)
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # La misma KEY para las 3 iteraciones
    KEY_128 = 0x2b7e151628aed2a6abf7158809cf4f3c
    KEY_192 = 0x8e73b0f7da0e6452c810f32b809079e562f8ead2522c6b7b
    KEY_256 = 0x603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4
    
    cocotb.log.info(f" KEY 128 = {to_hex128(KEY_128)}")
    cocotb.log.info(f" KEY 192 = {to_hex128(KEY_192)}")
    cocotb.log.info(f" KEY 256 = {to_hex128(KEY_256)}")

    # Tres plaintexts distintos
    PLAINTEXTS = [
        0x6bc1bee22e409f96e93d7e117393172a,
        0xae2d8a571e03ac9c9eb76fac45af8e51,
        0x30c81c46a35ce411e5fbc1191a0a52ef,
        0xf69f2445df4f9b17ad2b417be66c3710,
    ]
    
    CIPHERTEXTS_128 = [
        0x3ad77bb40d7a3660a89ecaf32466ef97,
        0xf5d3d58503b9699de785895a96fdbaaf,
        0x43b1cd7f598ece23881b00e3ed030688,
        0x7b0c785e27e8ad3f8223207104725dd4,
    ]
    
    CIPHERTEXTS_192 = [
        0xbd334f1d6e45f25ff712a214571fa5cc,
        0x974104846d0ad3ad7734ecb3ecee4eef,
        0xef7afd2270e2e60adce0ba2face6444e,
        0x9a4b41ba738d6c72fb16691603c18e0e,
    ]
    
    CIPHERTEXTS_256 = [
        0xf3eed1bdb5d2a03c064b5a7e3db181f8,
        0x591ccb10d410ed26dc5ba74a31362870,
        0xb6ed21b99ca6f4f9f153e7b1beafed1d,
        0x23304b7a39f9f3ff067d8d8f9e24ecc7,
    ]
    

    # Ejecutamos 4 iteraciones
    for i, pt in enumerate(PLAINTEXTS, start=1):
        await run_one_iteration(dut, KEY_128, KEY_192, KEY_256, pt, CIPHERTEXTS_128[i - 1], CIPHERTEXTS_192[i - 1], CIPHERTEXTS_256[i - 1], i)

    cocotb.log.info("=== TEST AES COMPLETADO ===")

