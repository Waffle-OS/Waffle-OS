#include "panic.h"
#include "../serial/terminal.h"


void kpanic(char *message)
{
    terminal_puts("\033[37m");
    terminal_puts("\033[44m");
    terminal_puts("\033[2J");
    terminal_puts("\033[1;1H");
    terminal_puts("Panic!\n");
    terminal_puts(message);
}
