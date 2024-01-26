#include "terminal.h"

void terminal_putch(char character)
{
    com1_write(character);
    if(character == '\n')
        com1_write('\r');   // Terminal newline only brings the cursor's Y pos down
                            // so we have to reset X pos manually, using carriage return.
}

void terminal_puts(char *format)
{
    while (*format != '\0') 
    {

      terminal_putch(*format);
      
      format++;
   }
}
