import cocotb
from cocotb.triggers import Timer

import logging

@cocotb.test()
async def key_expansion_test(dut):
   logger = logging.getLogger("my_testbench")

   key = 0x2b7e151628aed2a6abf7158809cf4f3c 
   dut.key.value = key
   await Timer(1, "ns")
   
   round_key = int(dut.round_key.value);
   
   logger.info(f"original_key (hex) = {key:032x}")
   logger.info(f"round_key (hex)    = {round_key:032x}")
    
    

