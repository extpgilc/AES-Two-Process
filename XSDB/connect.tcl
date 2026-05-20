	##################################################################

	## Test to verify aes_core (Arty Z7 project)

	## This test must be run from Vivado XSDB console
	## Ex.: C:/Xilinx/Vivado/2024.2/settings64
	
	## Before running this script open hardware manager in Vivado
	## and set up the ILA triggers
	
	## Remember to set up and run the Vivado ILA triggers 

	##################################################################
	
	
	## Connect to the xc7z020 board
	connect
	after 1000
	
	## Suspend ARM Cortex-A9 MPCore #0 before configuration
	targets 2
	after 1000
	stop
	
	## Load the xsa for a functional memory map
	targets 1
	after 1000
	loadhw -hw zynq_design.xsa -mem-ranges {0x00000000 0xFFFFFFFF}
	
	## Load the elf to initialize the Zynq PS
	targets 2
	after 1000
	dow zynq_fsbl.elf