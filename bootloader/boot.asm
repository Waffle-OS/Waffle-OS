[ORG 0x7c00]
[BITS 16]

%define NEWL 13, 10

jmp     0x00:boot

;----------
; MAIN
;----------

boot:
        ; Setting up stack and segments
        mov     SP, 0x7C00
        mov     BP, SP
        xor     AX, AX
        mov     DS, AX
        mov     ES, AX
        mov     SS, AX

        mov     [drive_num], DL

        ; Entering VGA video mode 3
        mov     AH, 0x00
        mov     AL, 0x03
        int     0x10

.load_stage2:
        ; Check presence of LBA extensions
        clc
        mov     AH, 0x41
        mov     BX, 0x55AA
        mov     DL, [drive_num]
        int     0x13
        jc      .failed_load                    

        ; Read stage 2 from disk
        mov     AH, 0x42
        mov     DL, [drive_num]
        mov     SI, extboot_lba_packet
        int     0x13
        mov     DL, [drive_num]
        jnc     0x7E00                          ; Jump to stage 2 if no errors


.failed_load:
        mov     SI, failed_load_msg
        call    puts
.halt:
        jmp     $



;----------
; DATA
;----------

drive_num:              db 0

failed_load_msg:        db 'Unable to load stage 2 bootloader.', NEWL, 0


; The DAP (disk address packet) used to load the extended bootloader
extboot_lba_packet:
        .size:          db 0x10
        .reserved:      db 0
        .blocks:        dw 3
        .offset:        dw 0x7E00
        .segment:       dw 0
        .low_address:   dd 1                    ; Low 32 bits of address
        .high_address:  dw 0                    ; High 16 bits of address
        .null:          dw 0



;----------
; FUNCTIONS
;----------

%include "misc/tty.asm"


; Boot signature
times 510-($-$$) db 0              
dw 0xaa55
