%ifndef BLH_PRINT
%define BLH_PRINT

; print '\n\r'
blh_print_line_terminator:
    ;prologue
    push bp
    mov bp, sp

    mov si, line_terminator
    push si
    call blh_print_str
    add sp, 2
    
    ;epilogue
    mov sp, bp
    pop bp
    ret

; blh_print_str(char* s)
blh_print_str:
    ;prologue
    push bp
    mov bp, sp

    mov cx, [bp + 4]
    push cx
    call blh_strlen
    push ax                 ; ax = strlen(error_msg)
    call blh_print_str_n

    ;epilogue
    mov sp, bp
    pop bp
    ret

; blh_print_str_n(char* s, int strlen(s))

blh_print_str_n:
    ; prologue
    push bp
    mov bp, sp
    push di
    push si

    mov cx, [bp + 4]        ; cx = strlen(s)
    mov si, [bp + 6]        ; si = s
    mov dx, 0               ; loop index
.print_str_loop_start:
    cmp dx, cx              ; cmp index to strlen(s)
    je .print_str_loop_end
    mov di, [si]            ; di = s[dx] 
    push di 
    call blh_print_char
    add sp, 2
    inc si
    inc dx
    jmp .print_str_loop_start
.print_str_loop_end:
    
    ;epilogue
    pop si
    pop di
    mov sp, bp
    pop bp 
    ret

; blh_print_char(char c)
blh_print_char:
    ; prologue
    push bp
    mov bp, sp
    push bx

    mov ax, [bp + 4]        ; effectively moves `c` into al.
    mov ah, 0xE
    mov bh, 0
    int 0x10

    ;epilogue
    pop bx
    mov sp, bp
    pop bp
    ret

line_terminator db 0xa, 0xd, 0

%include "blh_string.asm"

%endif