#include "io/io.h"

extern void main(void)
{
    *(char *)0xC00B8000 = 'Q';
}


