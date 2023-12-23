#include "../include/text_mode.h"

extern void main(void)
{
    terminal_initialize(VGA_COLOR_WHITE, VGA_COLOR_BLACK);
    vga_puts("Hello, World!\n");
    for(int i = 0; i < VGA_HEIGHT; i++)
        vga_puts("hH\n");
}
