#ifndef IDT_H
#define IDT_H

#include <stdint.h>

#define IDT_MAX_ENTRIES 256

struct gate_descriptor {
    uint16_t isr_address_lower;      // bits 0-15 of the ISR's address
    uint16_t segment_selector;
    uint8_t reserved;
    uint8_t gate_attributes;
    uint16_t isr_address_upper;      // bits 16-31 of the ISR's address
}__attribute__((packed));

struct idt_descriptor {
    uint16_t idt_size; // size of idt - 1;
    uint32_t idt_address;
}__attribute__((packed));

void initialize_idt();

void enable_interrupts();

void load_idt(struct idt_descriptor* idt_descriptor_ptr);

#endif