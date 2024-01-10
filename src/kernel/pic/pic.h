#ifndef PIC_H
#define PIC_H

#include <stdint.h>

void intialize_PIC();
void send_EOI_to_PIC(uint8_t irq_num);

#endif