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

gdt_null_segment_descriptor:
    dq 0x0

gdt_code_segment_descriptor:
    dw 0xFFFF                ; Limit, first part (lower 16 bits)
    dw 0x0                   ; Base, first part (lower 16 bits)
    db 0x0                   ; Base, second part (middle 8 bits)
    db 1001_1011b            ; Access Byte
    db 1100_1111b            ; Flags and Limit, second part (upper 4 bits)
    db 0x0                   ; Base, third part (upper 8 bits)

gdt_data_segment_descriptor:
    dw 0xFFFF                ; Limit, first part (lower 16 bits)
    dw 0x0                   ; Base, first part (lower 16 bits)
    db 0x0                   ; Base, second part (middle 8 bits)
    db 1000_0011b            ; Access Byte
    db 1100_1111b            ; Flags and Limit, second part (upper 4 bits)
    db 0x0                   ; Base, third part (upper 8 bits)

gdt_descriptor:
    dw gdt_null_segment_descriptor - gdt_descriptor - 1;
    dd gdt_null_segment_descriptor

zero_fill       times 512-($-$$) db 0
