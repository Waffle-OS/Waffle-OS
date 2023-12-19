#include "../include/text_mode.h"

extern void main(void)
{
    terminal_initialize(VGA_COLOR_WHITE, VGA_COLOR_BLACK);
    vga_putch('Q');
    vga_putch('Q');
    
}
