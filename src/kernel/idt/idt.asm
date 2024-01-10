BITS 32

section .asm

global enable_interrupts 
global load_idt 
global keyboard_isr
global unimplemented_isr

extern keyboard_interrupt_handler
extern unimplemented_interrupt_handler 

;void enable_interrupts();
enable_interrupts:
.prologue:
    push ebp
    mov ebp, esp
.set_interrupt_flag:
    sti
.epilogue:
    pop ebp
    ret

;void load_idt(struct idt_descriptor* idt_descriptor_ptr);
load_idt:
.prologue:
    push ebp
    mov ebp, esp
.load_idt:
    mov eax, [ebp + 8]
    lidt [eax]
.epilogue:
    pop ebp
    ret

keyboard_isr:
.prologue:
    cli
    pushad
.call_handler:
    call keyboard_interrupt_handler
.epilogue:
    popad
    sti
    iret

unimplemented_isr:
.prologue:
    cli
    pushad
.call_handler:
    call unimplemented_interrupt_handler 
.epilogue:
    popad
    sti
    iret