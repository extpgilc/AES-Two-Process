# test_aes_cipher.py
import logging
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge



def to_hex128(value: int) -> str:
    """Formato bonito para logging."""
    return f"0x{value:032X}"

async def run_one_iteration(dut, key_128_int, key_192_int, key_256_int, plaintext_int, iteration):
    """Ejecuta una iteración del flujo AES completo."""

    cocotb.log.info(f"\n========== ITERACIÓN {iteration} ==========")

    # 1) Reset alto
    dut.rst_128.value = 1
    dut.rst_192.value = 1
    dut.rst_256.value = 1
    await RisingEdge(dut.clk)

    # 2) Cargar entradas
    dut.key_128.value = key_128_int
    dut.key_192.value = key_192_int
    dut.key_256.value = key_256_int
    dut.plaintext.value = plaintext_int
    await RisingEdge(dut.clk)

    # cocotb.log.info(f"[{iteration}] KEY 128    = {to_hex128(key_128_int)}")
    # cocotb.log.info(f"[{iteration}] KEY 192    = {to_hex128(key_192_int)}")
    # cocotb.log.info(f"[{iteration}] KEY 256    = {to_hex128(key_256_int)}")
    cocotb.log.info(f"[{iteration}] PLAINTEXT      = {to_hex128(plaintext_int)}")

    # 3) Quitar reset
    dut.rst_128.value = 0
    dut.rst_192.value = 0
    dut.rst_256.value = 0
    await RisingEdge(dut.clk)

    # 4.1) Esperar done_128 = '1'
    while dut.done_128.value != 1:
        await RisingEdge(dut.clk)
        
    # 4.2) Esperar done_192 = '1'
    while dut.done_192.value != 1:
        await RisingEdge(dut.clk)
        
    # 4.3) Esperar done_256 = '1'
    while dut.done_256.value != 1:
        await RisingEdge(dut.clk)

    # 5.1) Loggear resultados aes 128
    cipher_128_int = int(dut.ciphertext_128.value)
    decoded_128_int = int(dut.decodedtext_128.value)
    
    cocotb.log.info(f"[{iteration}] CIPHERTEXT 128 = {to_hex128(cipher_128_int)}")
    cocotb.log.info(f"[{iteration}] DECODED 128    = {to_hex128(decoded_128_int)}")
    
    # 5.2) Loggear resultados aes 192
    cipher_192_int = int(dut.ciphertext_192.value)
    decoded_192_int = int(dut.decodedtext_192.value)
    
    cocotb.log.info(f"[{iteration}] CIPHERTEXT 192 = {to_hex128(cipher_192_int)}")
    cocotb.log.info(f"[{iteration}] DECODED 192    = {to_hex128(decoded_192_int)}")
    
    # 5.3) Loggear resultados aes 256
    cipher_256_int = int(dut.ciphertext_256.value)
    decoded_256_int = int(dut.decodedtext_256.value)

    cocotb.log.info(f"[{iteration}] CIPHERTEXT 256 = {to_hex128(cipher_256_int)}")
    cocotb.log.info(f"[{iteration}] DECODED 256    = {to_hex128(decoded_256_int)}")

    # 6.1) Verificación aes 128
    if decoded_128_int != plaintext_int:
        raise AssertionError(
            f"Iteration {iteration}: decoded != plaintext for key size 128"
        )

    # 6.2) Verificación aes 192
    if decoded_192_int != plaintext_int:
        raise AssertionError(
            f"Iteration {iteration}: decoded != plaintext for key size 192"
        )

    # 6.3) Verificación aes 256
    if decoded_256_int != plaintext_int:
        raise AssertionError(
            f"Iteration {iteration}: decoded != plaintext for key size 256"
        )

    # 7) Final message
    cocotb.log.info(f"[{iteration}] RESULT OK (all 3 decoded outputs == plaintext)")


@cocotb.test()
async def aes_encrypt_decrypt_test(dut):
    """Test completo: 4 ejemplos con una key para cada longitud de clave y 4 plaintext distintos."""

    cocotb.log.info("=== INICIO TEST AES ===")

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

    # Ejecutamos 4 iteraciones
    for i, pt in enumerate(PLAINTEXTS, start=1):
        await run_one_iteration(dut, KEY_128, KEY_192, KEY_256, pt, i)

    cocotb.log.info("=== TEST AES COMPLETADO ===")

