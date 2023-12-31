#include "../../include/interrupts.h"

static idtr_t idtr;
__attribute__((aligned(0x10))) 
static idt_entry_t idt[256];
