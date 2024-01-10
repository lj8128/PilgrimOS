BITS 32

section .asm

global outb
global outw
global outdw
global inb
global inw 
global indw

; void outb(uint16_t port, uint8_t byte);
outb:
    push ebp
    mov ebp, esp
    mov edx, [ebp + 8]
    mov eax, [ebp + 12]
    out dx, al
    pop ebp
    ret

; void outw(uint16_t port, uint16_t word);
outw:
    push ebp
    mov ebp, esp
    mov edx, [ebp + 8]
    mov eax, [ebp + 12]
    out dx, ax
    pop ebp
    ret

; void outdw(uint16_t port, uint32_t double_word);
outdw:
    push ebp
    mov ebp, esp
    mov edx, [ebp + 8]
    mov eax, [ebp + 12]
    out dx, eax
    pop ebp
    ret

;uint8_t inb(uint16_t port);
inb:
    push ebp
    mov ebp, esp
    mov edx, [ebp + 8]
    in al, dx 
    pop ebp
    ret

; uint16_t inw(uint16_t port);
inw:
    push ebp
    mov ebp, esp
    mov edx, [ebp + 8]
    in ax, dx 
    pop ebp
    ret

; uint32_t indw(uint16_t port);
indw:
    push ebp
    mov ebp, esp
    mov edx, [ebp + 8]
    in eax, dx 
    pop ebp
    ret
