nasm_includes = -I./src/bootloader/helpers -I./src/bootloader/data -I./src/bootloader/errors
gcc_options = -O0 -g -Iinc -falign-functions -falign-jumps -falign-labels -falign-loops -ffreestanding -finline-functions -fno-builtin -fomit-frame-pointer -fstrength-reduce -nodefaultlibs -nostartfiles -nostdlib -Wall -Werror -Wextra -Wno-cpp -Wno-unused-function -Wno-unused-label -Wno-unused-parameter  
object_files = ./build/kernel/main.o ./build/kernel/sanity_check.asm.o ./build/kernel/print/print.o ./build/kernel/string/string.o ./build/kernel/in_out/in_out.asm.o ./build/kernel/pic/pic.asm.o ./build/kernel/idt/idt.asm.o ./build/kernel/idt/idt.o

all: ./bin/hda_image.bin

./bin/hda_image.bin: ./bin/bootloader.asm.bin ./bin/kernel.bin
	cat ./bin/bootloader.asm.bin ./bin/kernel.bin > ./bin/hda_image.bin	
	dd if=/dev/zero of=./bin/hda_image.bin bs=1 count=0 seek=102912

./bin/bootloader.asm.bin: ./bin/bl_primary.asm.bin ./bin/bl_secondary.asm.bin ./bin/bl_tertiary.asm.bin
	cat ./bin/bl_primary.asm.bin ./bin/bl_secondary.asm.bin > ./bin/bl_intermediate.asm.bin
	cat ./bin/bl_intermediate.asm.bin ./bin/bl_tertiary.asm.bin > ./bin/bootloader.asm.bin

./bin/bl_primary.asm.bin: ./src/bootloader/bl_primary.asm 
	nasm -f bin $(nasm_includes) ./src/bootloader/bl_primary.asm -o ./bin/bl_primary.asm.bin

./bin/bl_secondary.asm.bin: ./src/bootloader/bl_secondary.asm
	nasm -f bin $(nasm_includes) ./src/bootloader/bl_secondary.asm -o ./bin/bl_secondary.asm.bin

./bin/bl_tertiary.asm.bin: ./src/bootloader/bl_tertiary.asm
	nasm -f bin $(nasm_includes) ./src/bootloader/bl_tertiary.asm -o ./bin/bl_tertiary.asm.bin

./bin/kernel.bin: $(object_files)
	i686-elf-ld -g -relocatable $(object_files) -o ./build/kernel/kernel.o
	i686-elf-gcc $(gcc_options) -T ./config/linker.ld ./build/kernel/kernel.o -o ./bin/kernel.bin

./build/kernel/main.o: ./src/kernel/main.c
	i686-elf-gcc -I./src/kernel $(gcc_options) -std=gnu99 -c ./src/kernel/main.c -o ./build/kernel/main.o

./build/kernel/print/print.o: ./src/kernel/print/print.c
	i686-elf-gcc -I./src/kernel -I./src/kernel/print $(gcc_options) -std=gnu99 -c ./src/kernel/print/print.c -o ./build/kernel/print/print.o

./build/kernel/string/string.o: ./src/kernel/string/string.c
	i686-elf-gcc -I./src/kernel -I./src/kernel/string $(gcc_options) -std=gnu99 -c ./src/kernel/string/string.c -o ./build/kernel/string/string.o

./build/kernel/sanity_check.asm.o: ./src/kernel/sanity_check.asm
	nasm -f elf -g ./src/kernel/sanity_check.asm -o ./build/kernel/sanity_check.asm.o

./build/kernel/in_out/in_out.asm.o: ./src/kernel/in_out/in_out.asm
	nasm -f elf -g ./src/kernel/in_out/in_out.asm -o ./build/kernel/in_out/in_out.asm.o

./build/kernel/pic/pic.asm.o: ./src/kernel/pic/pic.asm
	nasm -f elf -g ./src/kernel/pic/pic.asm -o ./build/kernel/pic/pic.asm.o

./build/kernel/idt/idt.asm.o: ./src/kernel/idt/idt.asm
	nasm -f elf -g ./src/kernel/idt/idt.asm -o ./build/kernel/idt/idt.asm.o

./build/kernel/idt/idt.o: ./src/kernel/idt/idt.c
	i686-elf-gcc -I./src/kernel -I./src/kernel/idt $(gcc_options) -std=gnu99 -c ./src/kernel/idt/idt.c -o ./build/kernel/idt/idt.o

clean:
	rm -f ./bin/*.bin
	rm -f ./build/kernel/*.o
	rm -f ./build/kernel/print/*.o
	rm -f ./build/kernel/string/*.o
	rm -f ./build/kernel/in_out/*.o
	rm -f ./build/kernel/pic/*.o
	rm -f ./build/kernel/idt/*.o