BITS 32

; TO-DO: Initialize stack
stack_init:                     ; initialize bp and sp to bottom of this sector
    mov eax, 0x1FF
    mov ebp, ax
    mov esp, ax


mov eax, 0xcafe
jmp $

zero_fill times 5120 -($-$$) db 0