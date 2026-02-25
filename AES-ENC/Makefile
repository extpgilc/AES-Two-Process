# ===============================
#   Cocotb + GHDL Makefile
# ===============================

TOPLEVEL_LANG = vhdl
SIM = ghdl

# === Project Structure ===
RTL_DIR = RTL
TEST_DIR = Tests

# Collect all VHDL files
VHDL_SOURCES = $(shell find $(RTL_DIR) -type f -name "*.vhd" -o -name "*.vhdl")

# Change these for your DUT
TOPLEVEL ?= KeySchedule
MODULE   ?= test_KeySchedule

# Default target
.PHONY: all
all:
	$(MAKE) -f $(shell cocotb-config --makefiles)/Makefile \
		SIM=$(SIM) \
		TOPLEVEL_LANG=$(TOPLEVEL_LANG) \
		TOPLEVEL=$(TOPLEVEL) \
		MODULE=$(MODULE) \
		VHDL_SOURCES="$(VHDL_SOURCES)"

# Clean
.PHONY: clean
clean:
	$(MAKE) -f $(shell cocotb-config --makefiles)/Makefile clean
	rm -rf sim_build __pycache__ *.vcd *.ghw
