nasm_includes = -I./src/bootloader/helpers -I./src/bootloader/data -I./src/bootloader/errors

all: ./bin/bootloader.asm.bin 

./bin/bootloader.asm.bin: ./bin/bl_primary.asm.bin ./bin/bl_secondary.asm.bin ./bin/bl_tertiary.asm.bin ./bin/kernel_test.asm.bin
	cat ./bin/bl_primary.asm.bin ./bin/bl_secondary.asm.bin > ./bin/bl_intermediate.asm.bin
	cat ./bin/bl_intermediate.asm.bin ./bin/bl_tertiary.asm.bin > ./bin/bootloader.asm.bin
	cat ./bin/bootloader.asm.bin ./bin/kernel_test.asm.bin > ./bin/hda_image.bin;

./bin/bl_primary.asm.bin: ./src/bootloader/bl_primary.asm 
	nasm -f bin $(nasm_includes) ./src/bootloader/bl_primary.asm -o ./bin/bl_primary.asm.bin

./bin/bl_secondary.asm.bin: ./src/bootloader/bl_secondary.asm
	nasm -f bin $(nasm_includes) ./src/bootloader/bl_secondary.asm -o ./bin/bl_secondary.asm.bin

./bin/bl_tertiary.asm.bin: ./src/bootloader/bl_tertiary.asm
	nasm -f bin $(nasm_includes) ./src/bootloader/bl_tertiary.asm -o ./bin/bl_tertiary.asm.bin

./bin/kernel_test.asm.bin: ./src/kernel/kernel_test.asm
	nasm -f bin $(nasm_includes) ./src/kernel/kernel_test.asm -o ./bin/kernel_test.asm.bin

clean:
	rm -f ./bin/*.bin