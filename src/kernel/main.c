#include "print/print.h"
#include "string/string.h"
#include "pic/pic.h"
#include "idt/idt.h"

int main() {
    char* msg = "Hello, World!";
    print_str(msg, strlen(msg));
    
    intialize_PIC();
    initialize_idt();
    enable_interrupts();

    while(1) {}; 
    return 0;
}