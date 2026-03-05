# test_aes_cipher.py
import logging
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge



def to_hex128(value: int) -> str:
    """Formato bonito para logging."""
    return f"0x{value:032X}"

async def run_one_iteration(dut, key_int, plaintext_int, iteration):
    """Ejecuta una iteración del flujo AES completo."""

    cocotb.log.info(f"\n========== ITERACIÓN {iteration} ==========")

    # 1) Reset alto
    dut.rst.value = 1
    await RisingEdge(dut.clk)

    # 2) Cargar entradas
    dut.key.value = key_int
    dut.plaintext.value = plaintext_int
    await RisingEdge(dut.clk)

    cocotb.log.info(f"[{iteration}] KEY        = {to_hex128(key_int)}")
    cocotb.log.info(f"[{iteration}] PLAINTEXT  = {to_hex128(plaintext_int)}")

    # 3) Quitar reset
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    # 4) Esperar done = '1'
    while dut.done.value != 1:
        await RisingEdge(dut.clk)

    # 5) Loggear resultados
    cipher_int = int(dut.ciphertext.value)
    decoded_int = int(dut.decodedtext.value)

    cocotb.log.info(f"[{iteration}] CIPHERTEXT = {to_hex128(cipher_int)}")
    cocotb.log.info(f"[{iteration}] DECODED    = {to_hex128(decoded_int)}")

    # Verificación opcional
    if decoded_int != plaintext_int:
        raise AssertionError(
            f"Iteration {iteration}: decoded != plaintext"
        )

    cocotb.log.info(f"[{iteration}] RESULT OK (decoded == plaintext)")


@cocotb.test()
async def aes_encrypt_decrypt_test(dut):
    """Test completo: 3 iteraciones con la misma key y 3 plaintext distintos."""

    cocotb.log.info("=== INICIO TEST AES ===")

    # Crear reloj (10 ns)
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # La misma KEY para las 3 iteraciones
    KEY = 0x2b7e151628aed2a6abf7158809cf4f3c

    # Tres plaintexts distintos
    PLAINTEXTS = [
        0x3243f6a8885a308d313198a2e0370734,
        0x00000000000000000000000000000000,
        0xffffffffffffffffffffffffffffffff,
    ]

    # Ejecutamos 3 iteraciones
    for i, pt in enumerate(PLAINTEXTS, start=1):
        await run_one_iteration(dut, KEY, pt, i)

    cocotb.log.info("=== TEST AES COMPLETADO ===")

