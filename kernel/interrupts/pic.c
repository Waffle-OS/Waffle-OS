#include "pic.h"
#include "../io/io.h"

inline void io_wait(void)
{
    outb(0x80, 0);
}

void pic_eoi(uint8_t irq)
{
	if(irq >= 8)
		outb(PIC2_COMMAND, 0x20);
 
	outb(PIC1_COMMAND, 0x20);
}


void pic_remap(int master_offset, int slave_offset)
{
	uint8_t master_mask = inb(PIC1_DATA); // Saves masks
	uint8_t slave_mask = inb(PIC2_DATA);
 
	outb(PIC1_COMMAND, 0x11); // Starts initialisation (in cascade mode)
	io_wait();
	outb(PIC2_COMMAND, 0x11);
	io_wait();
	outb(PIC1_DATA, master_offset);  // ICW2: Master PIC vector offset
	io_wait();
	outb(PIC2_DATA, slave_offset); // ICW2: Slave PIC vector offset
	io_wait();
	outb(PIC1_DATA, 0b00000100); // ICW3: tell Master PIC that there is a slave PIC at IRQ2 (0000 0100)
	io_wait();
	outb(PIC2_DATA, 2); // ICW3: tell Slave PIC its cascade identity (0000 0010)
	io_wait();
 
	outb(PIC1_DATA, 0x01); // ICW4: have the PICs use 8086 mode (and not 8080 mode)
	io_wait();
	outb(PIC2_DATA, 0x01);
	io_wait();
 
	outb(PIC1_DATA, master_mask); // Restores saved masks
	outb(PIC2_DATA, slave_mask);
}


void irq_set_mask(uint8_t line) 
{
    uint16_t port;
    uint8_t value;
 
    if(line < 8) {
        port = PIC1_DATA;
    } else {
        port = PIC2_DATA;
        line -= 8;
    }
    value = inb(port) | (1 << line);
    outb(port, value);        
}


void irq_clear_mask(uint8_t line) 
{
    uint16_t port;
    uint8_t value;
 
    if(line < 8) {
        port = PIC1_DATA;
    } else {
        port = PIC2_DATA;
        line -= 8;
    }
    value = inb(port) & ~(1 << line);
    outb(port, value);        
}


uint16_t pic_get_irr(void)
{
	/* OCW3 to PIC CMD to get the register values.  PIC2 is chained, and
     * represents IRQs 8-15.  PIC1 is IRQs 0-7, with 2 being the chain */
    outb(PIC1_COMMAND, 0x0A);
    outb(PIC2_COMMAND, 0x0A);
    return (inb(PIC2_COMMAND) << 8) | inb(PIC1_COMMAND);
}
 

uint16_t pic_get_isr(void)
{
    outb(PIC1_COMMAND, 0x0B);
    outb(PIC2_COMMAND, 0x0B);
    return (inb(PIC2_COMMAND) << 8) | inb(PIC1_COMMAND);
}


void pic_disable(void) 
{
    outb(PIC1_DATA, 0xff);
    outb(PIC2_DATA, 0xff);
}




