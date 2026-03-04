import cocotb
from cocotb.triggers import Timer, RisingEdge
from cocotb.clock import Clock
import logging


@cocotb.test()
async def key_expansion_test(dut):

    logger = logging.getLogger("aes_encoder_tb")

    # ============
    #  Clock setup
    # ============
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())  # periodo = 10 ns

    # ============
    #   Reset
    # ============
    dut.srst.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.srst.value = 0

    # ============
    #   Input data
    # ============
    plaintext = 0x3243f6a8885a308d313198a2e0370734
    key       = 0x2b7e151628aed2a6abf7158809cf4f3c

    dut.plaintext.value = plaintext
    dut.key.value = key

    # ============
    #   Wait for AES to finish
    # ============
    while dut.done.value == 0:
        await RisingEdge(dut.clk)

    # ============
    #   Collect output
    # ============
    ciphertext_int = int(dut.ciphertext.value)
    ciphertext_hex = f"{ciphertext_int:032x}"

    logger.info(f"plaintext  (hex) = {plaintext:032x}")
    logger.info(f"ciphertext (hex) = {ciphertext_hex}")
