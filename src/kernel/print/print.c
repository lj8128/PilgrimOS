#include "print.h"
#include "status.h"

static uint16_t* cur_buffer_address = (uint16_t*)0x000b9000;

int print_char(char c, uint8_t c_props) {
    int res = SUCCESS;

    uint16_t c_with_props = c_props;
    c_with_props <<= 8;
    c_with_props |= c;
    *cur_buffer_address = c_with_props;

    return res;
}

int print_str_with_props(char* s, int s_len, uint8_t c_props) {
    int res = SUCCESS;

    for(int i = 0; i < s_len; ++i) {
        char c = s[i];
        print_char(c, c_props);
        ++cur_buffer_address;
    }

    return res;
}

int print_str(char* s, int s_len) {
    int res = SUCCESS;
    print_str_with_props(s, s_len, 0x0f);
    return res;
}
