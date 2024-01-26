#include "serial/terminal.h"
#include "interrupts/pic.h"
#include "kutils/panic.h"

extern void main(void)
{
    // Initialise COM1 for terminal output.
    if(init_com1())
        return;
    
    // Remap PIC so that it doesnt overlap with exceptions.
    pic_remap(0x20, 0x28);

    terminal_puts("\033[37;1m");
    terminal_puts("_______________\n");
    terminal_puts("|  _   _   _  |  WELCOME! \n");
    terminal_puts("| |_| |_| |_| |  WaffleOS 0.0.0-prealpha \n");
    terminal_puts("|  _   _   _  |\n");
    terminal_puts("| |_| |_| |_| |\n");
    terminal_puts("|  _   _   _  |\n");
    terminal_puts("| |_| |_| |_| |\n");
    terminal_puts("|_____________|\n");

}


