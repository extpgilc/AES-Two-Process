.DEFAULT_GOAL := sim

PROJECT_ROOT := $(shell realpath $(PWD)/..)

GHDL_EXECUTABLE = docker run --rm \
	-v $(PROJECT_ROOT):/work \
	-w /work/Tests \
	ghdl/ghdl:6.0.0-dev-llvm-ubuntu-22.04 ghdl

# copilot se queda sin ideas	
export GHDL = $(GHDL_EXECUTABLE)

SIM_BUILD = Build

SIM = ghdl
TOPLEVEL_LANG = vhdl

# Nombre exacto del entity
TOPLEVEL = testwrapper

# Nombre del módulo Python sin .py
MODULE = test_aes


# Rutas a tus fuentes
AES_PKG = ../RTL/AesGf2Pkg.vhd
AES_ENC = ../RTL/128Encoder.vhd
AES_DEC = ../RTL/128Decoder.vhd

# GHDL necesita compilar la librería aes ANTES que Cocotb
pre_compile:
	mkdir -p Build
	$(GHDL_EXECUTABLE) -a --work=aes $(AES_PKG)
	$(GHDL_EXECUTABLE) -a --work=aes $(AES_ENC)
	$(GHDL_EXECUTABLE) -a --work=aes $(AES_DEC)

# Archivos que cocotb compilará (usa la librería aes automáticamente)
VHDL_SOURCES = AesTestingWrapper.vhd

CUSTOM_COMPILE_DEPS = pre_compile

include $(shell cocotb-config --makefiles)/Makefile.sim
