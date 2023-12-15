BITS 16

jmp 0x07C0:seg_init         ; CS = 0x07c0, IP = seg_init

seg_init:
    cli                     ; disable interrupts 
    mov ax, 0x07C0
    mov ds, ax
    mov ax, 0x07E0
    mov es, ax
    sti                     ; enable interrupts

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
    jmp 0x07E0:0             ; jump to secondary bootloader

print_ERROR:
    mov ah, 0xE
    mov al, 'E'
    mov bh, 0
    int 0x10 

end:

zero_fill       times 510-($-$$) db 0
boot_signature  dw 0xAA55