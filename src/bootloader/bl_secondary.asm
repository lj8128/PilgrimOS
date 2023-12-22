BITS 16

seg_init:
    cli                     ; disable interrupts 
    mov ax, 0x07E0
    mov ds, ax
    mov es, ax
    mov ss, ax
    sti                     ; enable interrupts

stack_init:                 ; position stack regs at end of 90 sectors
    mov ax, 0xb3ff
    mov bp, ax
    mov sp, ax

main:
    call blh_print_line_terminator
    mov si, welcome_msg 
    push si
    call blh_print_str
    add sp, 2
    jmp $

welcome_msg db " Welcome to the text editor!", 0xa, 0xd, 0

%include "blh_string.asm"
%include "blh_print.asm"

zero_fill times 46080 -($-$$) db 0
