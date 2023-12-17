;=============================
;                            |
; GDT data                   |
;                            |
;=============================

gdt_data:
        .null:
                dq 0
        .code:
                dw 0xffff
                dw 0
                db 0
                db 10011010b
                db 11001111b
                db 0
        .data:
                dw 0xffff
                dw 0
                db 0
                db 10010010b
                db 11001111b
                db 0
.end:

.desc:
        dw gdt_data.end - gdt_data - 1
        dd gdt_data
        