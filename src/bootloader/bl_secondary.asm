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
    ; print "Hello World"
    mov si, hello_world
    mov bx, 11              ; length of "Hello World"
    push bx
    push si
    call print_str
    add sp, 4

    ; jump to tertiary bootloader
    jmp 0x1460:0             

hello_world db "Hello World", 0

%include "blh_print.asm"

zero_fill       times 51200-($-$$) db 0
