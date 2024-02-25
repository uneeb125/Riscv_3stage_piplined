hex:
	cd ./mkhex
	./mkhex/mkhex.sh

output:
	mkdir output
setup: output
	cd output
vlog: 
	vlog main_tb.sv ./design/*.sv

vsim: vlog 
	vsim -c work.main_tb  -do "run -all"

gtk: vsim
	gtkwave waveform.vcd
