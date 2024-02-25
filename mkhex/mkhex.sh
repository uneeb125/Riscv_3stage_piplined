cd ./mkhex	
nvim hell.s
	riscv32-unknown-elf-as hell.s -o hell.o -march=rv32i -mabi=ilp32
	riscv32-unknown-elf-objdump --disassembler-color=on -S hell.o > hell.hex
    awk '{if ($2 ~ /^[0-9a-f]+$/) print $2}' hell.hex > ../inst.mem
