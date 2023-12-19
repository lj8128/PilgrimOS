BITS 16

seg_init:
    cli                     ; disable interrupts 
    mov ax, 0x07E0
    mov ds, ax
    mov es, ax
    mov ss, ax
    sti                     ; enable interrupts

stack_init:                 ; position stack regs at end of 100 sectors
    mov ax, 0xC7ff
    mov bp, ax
    mov sp, ax

main:
    ; set ax = strlen("Hello World")
    mov si, hello_world
    push si
    call blh_strlen
    ; print "Hello World"
    push ax                 ; ax = strlen(hello_world)
    call blh_print_str
    add sp, 4
    jmp $

hello_world db "Hello World", 0

%include "blh_string.asm"
%include "blh_print.asm"

zero_fill       times 51200-($-$$) db 0
