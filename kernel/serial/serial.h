#ifndef WAFFLE_SERIAL_H
#define WAFFLE_SERIAL_H

#include <stdint.h>

#define COM1 0x3F8

/**
 * @brief Initialises the serial port (if there is one) at COM1.
 * 
 * @return 0 on success, some other value on failure.
 */
uint8_t init_com1(void);

/**
 * @brief Reads a uint8_t from COM1.
 *   
 * @return The data read.
 */
uint8_t com1_read(void);

/**
 * @brief Writes a uint8_t to COM1.
 * 
 * @param data The data to write.
 */
void com1_write(uint8_t data);

#endif
