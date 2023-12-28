ORG 0x0010_0000
BITS 32

mov eax, 0xcafeface
jmp $

zero_fill times 51200 -($-$$) db 0