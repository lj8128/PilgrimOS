BITS 32

; The offset of the Code Segment Descriptor in the GDT.
%define CODE_SEG_DESCR_OFFSET 0x8

stack_init:                     ; initialize bp and sp to bottom of this sector
    mov eax, 0x0001_4400
    mov ebp, eax
    mov esp, eax

; load from LBA 101 (0b0110_0101), since bl_primary 
;   already loaded sectors 1-100. Note that we use
;   the protocol for 28-bit LBA addresses. So our LBA
;   for 101 is (0b0000_0000_0000_0000_0000_0110_0101).
load_kernel_with_pata_interface:
    ; select first ("master") drive, and send high 4 bits of LBA
    mov eax, 0xE0                ; signature for the first drive
    or eax, 0x0                  ; highest four bits of LBA. Can omit this line.
    mov dx, 0x1F6
    out dx, al

    ; set sectors_to_read to 100 (0x64)
    mov eax, 0x64
    mov dx, 0x1F2
    out dx, al

    ; send lowest 8 bits of LBA
    mov eax, 0b0110_0101         ; binary equiv. of decimal 101
    mov dx, 0x1F3
    out dx, al

    ; send middle 16 bits of LBA, which for us are 0s.
    mov eax, 0x0  
    mov dx, 0x1F4
    out dx, al
    mov dx, 0x1F5
    out dx, al

    ; send read sectors command
    mov eax, 0x20
    mov dx, 0x1F7
    out dx, al

    ; set edi to starting memory address from which we want to read 100 sectors.
    ;   This is the starting address of our kernel.
    mov edi, 0x0010_0000        ; 0x0010_0000 bits = 2^20 bits = 1MiB
    mov ebx, 0x64               ; store sectors to read in ebx

.poll_pata_drive_status:        ; check if drive is ready to transmit 1 sector 
    in al, dx                   ; port 0x1F7 contains the status bits
    and al, 0b1000_1000         ; mask all bits except BSY and DRQ
    cmp al, 0b0000_1000         ; check if BSY bit is clear and DRQ is set
    jne .poll_pata_drive_status ; poll drive until it is ready

.read_one_sector:
    ; 0x1F0 is the data port (the port at which the drive makes 16 bits of data
    ;   available at a time).
    mov dx, 0x1F0               
    mov cx, 256
    ; insw: reads 16 bits from port dx; increments edi (b/c our DC bit for the 
    ;   data segment was set to 0. If the DC bit were 1, insw would decrement
    ;   edi) 
    ; rep {instruction}: if cx > 0, executes {instruction} and decrements cx. Stops when cx == 0.
    rep insw 

.check_if_done_reading:
    dec ebx                     ; decrement sectors to read
    cmp ebx, 0x0
    je .jump_to_kernel          ; jump to kernel if done reading.

.wait_for_drive_status_to_reset:
    mov dx, 0x1F7               ; reset dx to status port number
    mov cx, 4
.wait:
    in al, dx
    dec cx
    cmp cx, 0
    je .wait
    jmp .poll_pata_drive_status 

.jump_to_kernel:
    jmp CODE_SEG_DESCR_OFFSET:0x0010_0000       

zero_fill times 5120 -($-$$) db 0