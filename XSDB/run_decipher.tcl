	##################################################################

	## Test to verify aes_core (Arty Z7 project)

	## This test must be run from Vivado XSDB console
	## Ex.: C:/Xilinx/Vivado/2024.2/settings64
	
	## Before running this script open hardware manager in Vivado
	## and set up the ILA triggers
	
	## Remember to set up and run the Vivado ILA triggers 

	##################################################################
	
	## Enable decipher in the Aes Control register (reg 8 bit 0)
	mwr 0x43C00020 0x00000001
	
	## Write in the AES registers to set up a key (256 bits)
	mwr 0x43C00000 0x603deb10
	mwr 0x43C00004 0x15ca71be
	mwr 0x43C00008 0x2b73aef0
	mwr 0x43C0000C 0x857d7781
	mwr 0x43C00010 0x1f352c07
	mwr 0x43C00014 0x3b6108d7
	mwr 0x43C00018 0x2d9810a3
	mwr 0x43C0001C 0x0914dff4
	
	## Initialize the DDR memory (input and output sections)
	mwr 0x01000000 0xf3eed1bd
	mwr 0x01000004 0xb5d2a03c
	mwr 0x01000008 0x064b5a7e
	mwr 0x0100000C 0x3db181f8
		
	mwr 0x02000000 0xDEADBEEF
	mwr 0x02000004 0xDEADBEEF
	mwr 0x02000008 0xDEADBEEF
	mwr 0x0200000C 0xDEADBEEF
	
	## Reset both DMA interfaces before configuration 
	## reset MM2S
	mwr 0x40400000 0x00000004
	## reset S2MM
	mwr 0x40400030 0x00000004
	
	## Configure the DMA slave control registers
	## enable S2MM
	mwr 0x40400030 0x00000001
	## destiny location
	mwr 0x40400048 0x02000000
	## length in bytes
	mwr 0x40400058 16
	
	## Configure the DMA master control registers
	## enable MM2S
	mwr 0x40400000 0x00000001
	## source location
	mwr 0x40400018 0x01000000
	## length in bytes
	mwr 0x40400028 16
	
	## Check DMA control bits
	## master interface
	## mrd 0x40400004
	## slave interface
	## mrd 0x40400034
	
	## Check DDR registers with input value
	## mrd 0x01000000
	## mrd 0x01000008
	## mrd 0x01000010
	## mrd 0x01000018
	## Check DDR registers with output value
	## mrd 0x02000000
	## mrd 0x02000008
	## mrd 0x02000010
	## mrd 0x02000018
	
	## Debug AXI Lite
	## check mode
	## mrd 0x43C00020
	## check key
	## mrd 0x43C00000 
	## mrd 0x43C00004 
	## mrd 0x43C00008 
	## mrd 0x43C0000C 
	## mrd 0x43C00010 
	## mrd 0x43C00014 
	## mrd 0x43C00018 
	## mrd 0x43C0001C 