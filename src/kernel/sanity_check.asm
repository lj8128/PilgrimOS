BITS 32

section .asm

global sanity_check

sanity_check:
mov eax, 0xfacecafe
jmp $