hex: gen
	nvim mkhex/hell.s

show: gen
	riscv32-unknown-elf-objdump --disassembler-color=on -S .mkhex/hell.o
gen:
	cd ./mkhex
	./mkhex/mkhex.sh

output:
	mkdir output
setup: output
	cd output
vlog: 
	@vlog main_tb.sv $(shell find ./design -type f \( -name '*.sv' \))

vsim: vlog 
	vsim -c work.main_tb  -do "run -all" 

gtk: 
	gtkwave waveform.vcd load_i.gtkw &
