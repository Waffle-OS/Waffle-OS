[BITS 32]
[EXTERN main]

global _start

    
_start:
    call    main

halt:
    cli
    hlt 
    jmp     halt
