%ifndef BLD_DAPS
%define BLD_DAPS

bld_daps:                       ; Disk Address Packet Structure
    size_of_packet          db 0x10
    zero                    db 0
    num_sectors_to_read     dw 0x64
    destination_offset      dw 0x0
    destination_segment     dw 0x07E0
    lba_lower_32_bits       dd 1
    lba_upper_16_bits       dd 0

%endif