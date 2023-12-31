#ifndef INTERRUPTS_H
#define INTERRUPTS_H

#include <stdint.h>


/* IDT */


typedef struct {
   uint16_t offset_1;        // First 16 bits of offset
   uint16_t selector;        // Segment selector
   uint8_t  reserved;            // Set to 0
   uint8_t  type_attributes; // Gate type, DPL and P fields
   uint16_t offset_2;        // Last 16 bits of offset
} __attribute__((packed)) idt_entry_t;

typedef struct {
	uint16_t	limit;
	uint32_t	base;
} __attribute__((packed)) idtr_t;


/* PIC COMMUNICATION */


#define PIC1		0x20		// IO base address for master PIC
#define PIC2		0xA0		// IO base address for slave PIC
#define PIC1_COMMAND	PIC1
#define PIC1_DATA	(PIC1+1)
#define PIC2_COMMAND	PIC2
#define PIC2_DATA	(PIC2+1)

/**
 * @brief Sends an EOI (end of interrupt) signal to the PIC.
 * 
 * @param irq The line the interrupt came from.
 */
void pic_eoi(uint8_t irq);

/**
 * @brief Initialises the PIC to use the specified offsets to send interrupt vectors with.
 * 
 * @param master_offset The master PIC offset.
 * @param slave_offset The slave PIC offset.
 */
void pic_remap(int master_offset, int slave_offset);

void irq_set_mask(uint8_t line);

void irq_clear_mask(uint8_t line);

uint16_t pic_get_irr(void);

uint16_t pic_get_isr(void);

void pic_disable(void);

#endif
