%ifndef BLH_STRING
%define BLH_STRING

; blh_strlen(char* s)
blh_strlen:
    ;prologue
    push bp
    mov bp, sp
    push si

    mov si, [bp + 4]        ; si = s
    mov ax, 0               ; result 
.strlen_loop_start:
    mov cl, [si]
    cmp cl, 0               ; di = s[ax]
    je .strlen_loop_end
    inc si
    inc ax
    jmp .strlen_loop_start
.strlen_loop_end:
    ;epilogue
    pop si
    mov sp, bp
    pop bp
    ret

%endif