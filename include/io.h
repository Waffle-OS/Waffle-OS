#ifndef IO_DRIVERS_H
#define IO_DRIVERS_H

#include <stdint.h>

#ifdef USING_IN_OUT

/* OUTPUT */


/**
 * @brief Writes a byte to the specified port.
 * 
 * @param port The port to write to.
 * @param val The value to write.
 */
inline void outb(uint16_t port, uint8_t val);

/**
 * @brief Writes a word to the specified port.
 * 
 * @param port The port to write to.
 * @param val The value to write.
 */
inline void outw(uint16_t port, uint16_t val);

/**
 * @brief Writes a double word to the specified port.
 * 
 * @param port The port to write to.
 * @param val The value to write.
 */
inline void outl(uint16_t port, uint32_t val);


/* INPUT */


/**
 * @brief Reads the byte written at the specified port.
 * 
 * @param port The port to read from.
 */
inline uint8_t inb(uint16_t port);

/**
 * @brief Reads the word written at the specified port.
 * 
 * @param port The port to read from.
 */
inline uint16_t inw(uint16_t port);

/**
 * @brief Reads the double word written at the specified port.
 * 
 * @param port The port to read from.
 */
inline uint32_t inl(uint16_t port);

#endif


/* MISCELLANIOUS */


#ifdef USING_IO_WAIT

/**
 * @brief Delays by a small amount of time, usually by a few microseconds, using IO ports.
 *  
 */
inline void io_wait(void);

#endif

#endif
