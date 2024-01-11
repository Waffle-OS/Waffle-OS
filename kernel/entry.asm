[BITS 32]
[EXTERN main]

global _start

_start:
    xor     EAX, EAX
	mov     ESP, 0x7C00
    mov     EBP, ESP
    call    main
    jmp     $
