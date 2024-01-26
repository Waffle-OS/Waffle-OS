#ifndef WAFFLE_PANIC_H
#define WAFFLE_PANIC_H

#include <stdint.h>

/**
 * @brief Used when a fatal exception occurs in kernel.
 * 
 * @param message The message to show to the user.
 * @param fault_loc The location of the fault.
 */
void kpanic(char *message);

#endif
