; 
;; puts a character onto the screen
; params:
; * AL - character to put on screen
putch:
        mov     ah, 0x0e
        int     10h
        ret

; 
;; puts a string onto the screen
; params:
; * SI - pointer to the string to put on screen (must have a null char)
;
puts:
        pusha
.loop:
        mov     al, [si]
        or      al, al
        jz      .end
        call putch
        inc     si
        jmp     .loop
.end:   
        popa
        ret

; 
;; gets a character from keyboard input
; returns:
; * AH - scancode of input
; * AL - character inputted
;
getch:
        mov     ah, 0
        int     0x16     
        ret

;
;; gets a string from keyboard input
; params:
; * BL - size of input buffer (including null char)
; * SI - pointer to buffer
; * BH - make non-zero to echo back input
; returns:
; * [SI] - the string recieved
;
gets:
        pusha
.loop:
        cmp     bl, 1
        je      .end
        call getch
        cmp     bh, 0
        je      .noecho
        call putch
.noecho:
        mov     byte [si], al
        inc     si
        dec     bl
        jmp     .loop
.end:
        inc     si
        mov     byte [si], 0
        popa
        ret
