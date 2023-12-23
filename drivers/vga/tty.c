#include <stddef.h>
#include "../../include/text_mode.h"

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

/**
 * @brief Initialises the terminal.
 * 
 * @param fg The foreground color to initialise the terminal to.
 * @param bg The background color to initialise the terminal to.
 */
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

/**
 * @brief Converts an unsigned integer to a string.
 * 
 * @param number The number to convert.
 * @param converted The string to place the converted number in.
 */
static void uint_to_string(int number, char converted[12])
{
	const char decimalnums[11] = "0123456789";
	size_t i = 0;

	do
	{
		converted[i] = decimalnums[number % 10];
		i++;
		number /= 10;
	} while (number);

	converted[i] = '\0';
}

/**
 * @brief Converts an hexadecimal number to a string.
 * 
 * @param number The number to convert.
 * @param converted The string to place the converted number in.
 */
static void hex_to_string(int number, char converted[12])
{
	const char hexnums[17] = "0123456789ABCDEF";
	size_t i = 0;

	do
	{
		converted[i] = hexnums[number % 16];
		i++;
		number /= 16;
	} while (number);

	converted[i] = '\0';
}

/**
 * @brief Scrolls the terminal down.
 */
void terminal_scroll(void)
{
	for(int i = VGA_WIDTH; i < (VGA_WIDTH*VGA_HEIGHT); i++)
	{
		terminal_buffer[i-VGA_WIDTH] = terminal_buffer[i];
		terminal_buffer[i] = vga_entry(' ', terminal_color);
	}
	terminal_row--;
}

/**
 * @brief Writes a character to the screen WITHOUT updating cursor.
 * 
 * @param character The character to write.
 * @note Though it does not update the cursor, it does update the position to write at.
 */
static void vga_writech(char character)
{
	const size_t index = (terminal_row * VGA_WIDTH) + terminal_column;

	switch (character)
	{
	case '\n':
		if (++terminal_row == VGA_HEIGHT)
		{
			terminal_scroll();
		}	
		terminal_column = 0;
		return;
	default:
		terminal_buffer[index] = vga_entry(character, terminal_color);
	}

	if (++terminal_column == VGA_WIDTH) {
		terminal_column = 0;
		if (++terminal_row == VGA_HEIGHT)
		{
			terminal_scroll();
			terminal_row -= 2;
		}
	}
}

/**
 * @brief Prints out a character to VGA and updates cursor.
 * 
 * @param character The character to print out.
 */
void vga_putch(char character) 
{
    vga_writech(character);
	update_cursor(terminal_column, terminal_row);
}

/**
 * @brief Prints out a string to VGA and updates cursor.
 * 
 * @param string The string to print out.
 */
void vga_puts(char *string)
{
	size_t i;

	for(i = 0; string[i]; i++)
	{
		vga_writech(string[i]);
	}
	update_cursor(terminal_column, terminal_row);
}

/**
 * @brief Prints out a decimal number to VGA and updates cursor.
 * 
 * @param number The decimal number to print out.
 */
void vga_putint(int number)
{
	char converted[12];
	uint_to_string(number, converted);
	vga_puts(converted);
}

/**
 * @brief Prints a hexadecimal number to VGA and updates cursor.
 * 
 * @param number The hexadecimal number to print out.
 * @note This does print out "0x" before the number.
 */
void vga_puthex(int number)
{
	char converted[12];
	hex_to_string(number, converted);
	vga_puts(converted);
}
