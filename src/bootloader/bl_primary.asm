ORG 0x07C00
BITS 16

%define CODE_SEG gdt_code_seg_descriptor - gdt_null_seg_descriptor
%define DATA_SEG gdt_data_seg_descriptor - gdt_null_seg_descriptor

seg_init:
    cli                     ; disable interrupts 
    mov ax, 0x0
    mov ds, ax
    mov es, ax
    mov ss, ax
    sti                     ; enable interrupts

stack_init:                 ; initialize bp and sp to bottom of this sector
    mov ax, 0x1FF
    mov bp, ax
    mov sp, ax

daps:                       ; Disk Address Packet Structure
    size_of_packet          db 0x10
    zero                    db 0
    num_sectors_to_read     dw 0x64
    destination_offset      dw 0x0
    destination_segment     dw 0x07E0
    lba_lower_32_bits       dd 1
    lba_upper_16_bits       dd 0

read_from_disk_int13ext:
    mov si, daps
    mov ah, 0x42             ; read from disk (0x43 to write)
    int 0x13
    jc print_ERROR
    ; jmp 0x07E0:0             ; jump to secondary bootloader

switch_to_protected_mode:
    ; enable_a20_line  
    in al, 0x92
    or al, 2
    out 0x92, al

    cli                      ; disable (maskable) interrupts
    lgdt[gdt_descriptor]     ; load GDT
    mov eax, cr0             ; read content of cr0 to eax             
    or eax, 0x1              ; set bit at 0th place to 1 
    mov cr0, eax             ; write content of eax to cr0, setting PE bit 
    jmp CODE_SEG:protected_mode

print_ERROR:
    mov ah, 0xE
    mov al, 'E'
    mov bh, 0
    int 0x10

BITS 32

protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov ss, ax
    
    mov eax, 0xcafe

    jmp $
 
%include "blh_gdt.asm"

zero_fill       times 510-($-$$) db 0
boot_signature  dw 0xAA55