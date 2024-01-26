#ifndef WAFFLE_TERMINAL_H
#define WAFFLE_TERMINAL_H

#include "serial.h"

/**
 * @brief Writes a character to COM1 (which is probably a terminal).
 * 
 * @param character The character to write.
 */
void terminal_putch(char character);

/**
 * @brief Writes a string to COM1 (which is probably a terminal).
 * 
 * @param format The string to write.
 */
void terminal_puts(char *format);

#endif
