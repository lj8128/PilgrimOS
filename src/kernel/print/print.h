#ifndef PRINT_H
#define PRINT_H

#include <stdint.h>

int print_char(char c, uint8_t c_attributes);
int print_str(char* s, int s_len);
int print_str_with_props(char* s, int s_len, uint8_t c_props);

#endif