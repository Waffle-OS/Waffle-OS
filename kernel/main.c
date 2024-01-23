#include "serial/terminal.h"

extern void main(void)
{
    init_com1();
    terminal_putch('H');
    terminal_puts("ello, World!\n");
}


