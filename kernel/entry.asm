[BITS 32]
[EXTERN main]

[GLOBAL _start]

_start:
    call    main

halt:
    cli
    hlt 
    jmp     halt
