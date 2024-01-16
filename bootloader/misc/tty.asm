[BITS 16]

; 16 bit teletype functions.

%define NEWL 13, 10

; puts - Prints out a string.
; Parameters:
;       - DS:SI - The location of the string.
; Notes:
;       - Will change the data in SI and AX.
puts:
        mov     AH, 0x0E
.loop:
        mov     AL, [SI]
        or      AL, AL
        jz      .end
        int     0x10
        inc     SI
        jmp     .loop
.end:   
        ret
        