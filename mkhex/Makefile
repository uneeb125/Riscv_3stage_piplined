
default:
	nvim hell.s
	riscv32-unknown-elf-as -o hell.o hell.s -march=rv32i -mabi=ilp32
	riscv32-unknown-elf-gcc -o hell.elf hell.o -T linker.ld -nostdlib -march=rv32i
	riscv32-unknown-elf-objdump --disassembler-color=on -S hell.elf
