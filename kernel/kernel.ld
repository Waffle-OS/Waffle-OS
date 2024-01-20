ENTRY(_start)

OUTPUT(out/kernel.bin)
OUTPUT_FORMAT(binary)

STARTUP(out/entry.o)

SECTIONS
{
  .text.start (0xC0100000) : {
    out/entry.o( .text )
  }

  .text : ALIGN(CONSTANT(MAXPAGESIZE)) {
_TEXT_START_ = .;
    *(.text)
_TEXT_END_ = .;
  }

  .data : ALIGN(CONSTANT(MAXPAGESIZE)) {
_DATA_START_ = .;
    *(.data)
_DATA_END_ = .;
  }

  .bss : ALIGN(CONSTANT(MAXPAGESIZE)) {
_BSS_START_ = .;
    *(.bss)
_BSS_END_ = .;
  }
}
