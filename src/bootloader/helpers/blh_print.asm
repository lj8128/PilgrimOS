%ifndef BLH_PRINT
%define BLH_PRINT

; print_str(char* s, int strlen(s))
print_str:
    push bp
    mov bp, sp
    mov si, [bp + 4]        ; si = s
    mov bx, [bp + 6]        ; bx = strlen(s)
    mov dx, 0               ; loop index
loop_start:
    cmp dx, bx              ; cmp index to strlen(s)
    je loop_end
    mov di, [si]            ; di = s[dx] 
    push di
    call print_char
    add sp, 2
    inc si
    inc dx
    jmp loop_start
loop_end:
    mov sp, bp
    pop bp 
    ret

; print_char(char c)
print_char:
    push bp
    mov bp, sp
    mov ax, [bp + 4]        ; effectively moves `c` into al.
    mov ah, 0xE
    mov bh, 0
    int 0x10 
    mov sp, bp
    pop bp
    ret

%endif