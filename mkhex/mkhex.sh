cd ./mkhex	
	riscv32-unknown-elf-as hell.s -o hell.o -march=rv32izicsr -mabi=ilp32
	riscv32-unknown-elf-objdump --disassembler-color=on -S hell.o > hell.hex
	riscv32-unknown-elf-objdump --disassembler-color=on -S hell.o -M numeric
    awk '{if ($2 ~ /^[0-9a-f]+$/) print $2}' hell.hex > ../inst.mem
