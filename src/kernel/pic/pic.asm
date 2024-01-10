BITS 32

section .asm

%define MASTER_COMMAND_PORT 0x20
%define MASTER_DATA_PORT    0x21
%define SLAVE_COMMAND_PORT  0xA0
%define SLAVE_DATA_PORT     0xA1

global intialize_PIC
global send_EOI_to_PIC

; void intialize_PIC();
intialize_PIC:
.prologue:
    push ebp
    mov ebp, esp
    sub esp, 8                   ; make room to store 2 PIC masks as local variables
.save_PIC_masks:
    mov dx, MASTER_DATA_PORT
    in al, dx
    mov [ebp - 4], eax           ; [ebp - 4] = master_pic_mask
    mov dx, SLAVE_DATA_PORT
    in al, dx
    mov [ebp - 8], eax           ; [ebp - 8] = slave_pic_mask
.send_init_code_to_PICs:
    mov dx, MASTER_COMMAND_PORT
    mov al, 0x11
    out dx, al
    mov dx, SLAVE_COMMAND_PORT
    out dx, al 
; remap PIC IRQs from range [0,15] to [32,47]
.remap_PIC_vectors:
    mov dx, MASTER_DATA_PORT
    mov al, 0x20                ; 0x20 = 32
    out dx, al
    mov dx, SLAVE_DATA_PORT
    mov al, 0x28                ; 0x28 = 40
    out dx, al
.connect_master_and_slave_PICs:
    mov dx, MASTER_DATA_PORT
    mov al, 0x4
    out dx, al
    mov dx, SLAVE_DATA_PORT
    mov al, 0x2
    out dx, al
.have_PICS_use_8086_mode:
    mov dx, MASTER_DATA_PORT
    mov al, 0x01
    out dx, al
    mov dx, SLAVE_DATA_PORT
    mov al, 0x01
    out dx, al
.restore_PIC_masks:
    mov dx, MASTER_DATA_PORT
    mov eax, [ebp - 4]
    out dx, al
    mov dx, SLAVE_DATA_PORT
    mov eax, [ebp - 8]
    out dx, al
.epilogue:
    mov esp, ebp
    pop ebp
    ret

; void send_EOI_to_PIC(uint8_t irq_num);
send_EOI_to_PIC:
.prologue:
    push ebp
    mov ebp, esp
.check_irq_num:
    mov eax, [ebp + 8]
    cmp al, 8
    jg .send_EOI_to_master
.send_EOI_to_slave:
    mov dx, SLAVE_COMMAND_PORT 
    mov al, 0x20
    out dx, al
.send_EOI_to_master:
    mov dx, MASTER_COMMAND_PORT
    mov al, 0x20
    out dx, al
.epilogue:
    pop ebp
    ret