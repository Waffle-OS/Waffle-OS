#ifndef TEXT_MODE_DRIVERS_H
#define TEXT_MODE_DRIVERS_H
#include <stdint.h>

#define VGA_HEIGHT 25
#define VGA_WIDTH 80

typedef enum VGA_COLOR
{
    VGA_COLOR_BLACK = 0,
	VGA_COLOR_BLUE = 1,
	VGA_COLOR_GREEN = 2,
	VGA_COLOR_CYAN = 3,
	VGA_COLOR_RED = 4,
	VGA_COLOR_MAGENTA = 5,
	VGA_COLOR_BROWN = 6,
	VGA_COLOR_LIGHT_GREY = 7,
	VGA_COLOR_DARK_GREY = 8,
	VGA_COLOR_LIGHT_BLUE = 9,
	VGA_COLOR_LIGHT_GREEN = 10,
	VGA_COLOR_LIGHT_CYAN = 11,
	VGA_COLOR_LIGHT_RED = 12,
	VGA_COLOR_LIGHT_MAGENTA = 13,
	VGA_COLOR_LIGHT_BROWN = 14,
	VGA_COLOR_WHITE = 15,
} VGA_COLOR;


/* TERMINAL FUNCTIONS */


/**
 * @brief Initialises the terminal.
 * 
 * @param fg The foreground color to initialise the terminal to.
 * @param bg The background color to initialise the terminal to.
 */
void terminal_initialize(VGA_COLOR fg, VGA_COLOR bg);

/**
 * @brief Scrolls the terminal down.
 */
void terminal_scroll(void);

/**
 * @brief Prints out a character to VGA and updates cursor.
 * 
 * @param character The character to print out.
 */
void vga_putch(char character);

/**
 * @brief Prints out a string to VGA and updates cursor.
 * 
 * @param string The string to print out.
 */
void vga_puts(char *string);

/**
 * @brief Prints out a decimal number to VGA and updates cursor.
 * 
 * @param number The decimal number to print out.
 */
void vga_putint(int number);

/**
 * @brief Prints a hexadecimal number to VGA and updates cursor.
 * 
 * @param number The hexadecimal number to print out.
 * @note This does print out "0x" before the number.
 */
void vga_puthex(int number);


/* CURSOR RELATED FUNCTIONS */

/**
 * @brief Enables the cursor, also setting how many scan lines it takes up.
 * 
 * @param cursor_start The first scanline the cursor takes up (from 0 to 15).
 * @param cursor_end The second scanline the cursor takes up (from 0 to 15).
 */
void enable_cursor(uint8_t cursor_start, uint8_t cursor_end);

/**
 * @brief Disables the cursor. 
 */
void disable_cursor(void);

/**
 * @brief Updates the cursors position to that specified.
 * 
 * @param x The column to place the cursor in.
 * @param y The row to place the cursor in.
 */
void update_cursor(int x, int y);

#endif
