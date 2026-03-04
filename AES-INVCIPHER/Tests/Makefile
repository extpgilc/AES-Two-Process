SIM = ghdl
TOPLEVEL_LANG = vhdl

# Nombre exacto del entity
TOPLEVEL = Encoder

# Nombre del módulo Python sin .py
MODULE = test_aes_cipher

# Rutas a tus fuentes
AES_PKG  = $(PWD)/../RTL/AesGf2Pkg.vhd
AES_CORE = $(PWD)/../RTL/128Encoder.vhd

# GHDL necesita compilar la librería aes ANTES que Cocotb
pre_compile:
	ghdl -i --work=aes $(AES_PKG)

# Archivos que cocotb compilará (usa la librería aes automáticamente)
VHDL_SOURCES = $(AES_PKG) $(AES_CORE)

CUSTOM_COMPILE_DEPS = pre_compile

include $(shell cocotb-config --makefiles)/Makefile.sim
