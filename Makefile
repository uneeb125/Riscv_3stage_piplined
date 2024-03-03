hex: hexgen vsim

show: hexgen
	riscv32-unknown-elf-objdump --disassembler-color=on -S .mkhex/hell.o
hexgen:
	cd ./mkhex
	./mkhex/mkhex.sh

output:
	mkdir output
setup: output
	cd output
vlog: 
	vlog main_tb.sv ./design/*.sv

vsim: vlog 
	vsim +memory -c work.main_tb  -do "run -all" 

gtk: vsim
	gtkwave waveform.vcd &
