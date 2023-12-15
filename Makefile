all: ./bin/bootloader.bin 

./bin/bootloader.bin: ./bin/bl_primary.asm.bin ./bin/bl_secondary.asm.bin
	cat ./bin/bl_primary.asm.bin ./bin/bl_secondary.asm.bin > ./bin/bootloader.bin

./bin/bl_primary.asm.bin: ./src/bootloader/bl_primary.asm 
	nasm -f bin ./src/bootloader/bl_primary.asm -o ./bin/bl_primary.asm.bin

./bin/bl_secondary.asm.bin: ./src/bootloader/bl_secondary.asm
	nasm -f bin ./src/bootloader/bl_secondary.asm -o ./bin/bl_secondary.asm.bin

clean:
	rm -f ./bin/*.bin