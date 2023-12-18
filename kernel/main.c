#include "../include/io.h"

extern void main(void)
{
    *(char *)0xb8000 = 'Q';
    
}
