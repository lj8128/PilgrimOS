BITS 16

seg_init:
    cli                     ; disable interrupts 
    mov ax, 0x1460
    mov ds, ax
    mov es, ax
    mov ss, ax
    sti                     ; enable interrupts

stack_init:                 ; position stack regs at end of two sectors
    mov ax, 0x1ff 
    mov bp, ax
    mov sp, ax

main:
    mov ah, 0xE
    mov al, 'Y'
    mov bh, 0
    int 0x10 
    jmp $

zero_fill       times 512-($-$$) db 0
