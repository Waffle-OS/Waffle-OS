#include <stddef.h>
#include "../../include/text_mode.h"

#define VGA_HEIGHT 25
#define VGA_WIDTH 80

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;
uint16_t* terminal_buffer;

static inline uint8_t vga_color_entry(VGA_COLOR fg, VGA_COLOR bg)
{
    return (fg | bg << 4);
}

static inline uint16_t vga_entry(char character, uint8_t color_entry)
{
    return (uint16_t) character | (uint16_t) color_entry << 8;
}

void terminal_initialize(VGA_COLOR fg, VGA_COLOR bg) 
{
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = vga_color_entry(fg, bg);
	terminal_buffer = (uint16_t*) 0xB8000;
	for (size_t y = 0; y < VGA_HEIGHT; y++) {
		for (size_t x = 0; x < VGA_WIDTH; x++) {
			const size_t index = (y * VGA_WIDTH) + x;
			terminal_buffer[index] = vga_entry(' ', terminal_color);
		}
	}
}

void vga_putch(char character) 
{
    const size_t index = (terminal_row * VGA_WIDTH) + terminal_column;
    terminal_buffer[index] = vga_entry(character, terminal_color);

	if (++terminal_column == VGA_WIDTH) {
		terminal_column = 0;
		if (++terminal_row == VGA_HEIGHT)
			terminal_row = 0;
	}
}
void vga_puts(char *string);
