gdt_null_seg_descriptor:
    dq 0x0

gdt_code_seg_descriptor:
    dw 0xFFFF                ; Limit, first part (lower 16 bits)
    dw 0x0                   ; Base, first part (lower 16 bits)
    db 0x0                   ; Base, second part (middle 8 bits)
    db 1001_1011b            ; Access Byte
    db 1100_1111b            ; Flags and Limit, second part (upper 4 bits)
    db 0x0                   ; Base, third part (upper 8 bits)

gdt_data_seg_descriptor:
    dw 0xFFFF                ; Limit, first part (lower 16 bits)
    dw 0x0                   ; Base, first part (lower 16 bits)
    db 0x0                   ; Base, second part (middle 8 bits)
    db 1001_0011b            ; Access Byte
    db 1100_1111b            ; Flags and Limit, second part (upper 4 bits)
    db 0x0                   ; Base, third part (upper 8 bits)

gdt_descriptor:
    dw gdt_null_seg_descriptor - gdt_descriptor - 1
    dd gdt_null_seg_descriptor
