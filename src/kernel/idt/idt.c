#include "idt.h"
#include "global_constants.h"
#include "print/print.h"
#include "string/string.h"
#include "pic/pic.h"

extern void keyboard_isr();
extern void unimplemented_isr();

void keyboard_interrupt_handler() {
  char* msg = "Key pressed!";
  print_str(msg, strlen(msg));
  send_EOI_to_PIC(0x21); 
}

void unimplemented_interrupt_handler() {
  send_EOI_to_PIC(0x21);
}

static void set_gate_descriptor(struct gate_descriptor* idt, int irq, void* isr_address) {
  idt[irq] = (struct gate_descriptor){
    .isr_address_lower = (uint32_t)isr_address & 0xFFFF,
    .segment_selector = KERNEL_CODE_SEGMENT_SELECTOR,
    .reserved = 0x0,
    .gate_attributes = 0x8E,
    .isr_address_upper = (uint32_t)isr_address >> 16,
  };
}

static void set_gate_descriptor_array(struct gate_descriptor* idt) {
  for(int i = 0; i < IDT_MAX_ENTRIES; ++i) {
    set_gate_descriptor(idt, i, unimplemented_isr);
  }  

  set_gate_descriptor(idt, 0x21, keyboard_isr);
}

void initialize_idt() {
  struct gate_descriptor idt[IDT_MAX_ENTRIES];

  set_gate_descriptor_array(idt);

  struct idt_descriptor idt_descriptor_instance = {
    .idt_size = sizeof(idt),
    .idt_address = (uint32_t)idt
  };

  load_idt(&idt_descriptor_instance);
}

