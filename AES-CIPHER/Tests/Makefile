TOPLEVEL_LANG = vhdl
SIM = ghdl

PWD=$(shell pwd)

VHDL_SOURCES =\
	$(PWD)/KeyExpansionPkg.vhd \
	$(PWD)/KeyExpansionWrapper.vhd
	
	
TOPLEVEL = KeyExpander

MODULE = test_aes_cipher

export COCOTB_LOG_LEVEL=INFO

include $(shell cocotb-config --makefiles)/Makefile.sim
