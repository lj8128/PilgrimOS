#include "string.h"

int strlen(char* s) {
    int s_len = 0;
    int idx = 0;
    char c = s[idx];
    
    while(c != '\0') {
        ++s_len;
        c = s[++idx];
    }

    return s_len;
}