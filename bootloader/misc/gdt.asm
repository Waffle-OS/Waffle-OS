;=============================
;                            |
; GDT data                   |
;                            |
;=============================

gdt_start:
        .null:
                dq 0
        .k_code:
                dw 0xFFFF               ; Lower limit
                dw 0                   
                db 0                    ; Lower base
                db 0x9A                 ; Access byte  
                db 0xCF                 ; Other flags + Higher limit
                db 0                    ; Higher base
        .k_data:
                dw 0xFFFF
                dw 0
                db 0
                db 0x92
                db 0xCF
                db 0
        .usr_code:
                dw 0xFFFF     
                dw 0                   
                db 0                 
                db 0xFA           
                db 0xCF             
                db 0                  
        .usr_data:
                dw 0xFFFF
                dw 0
                db 0
                db 0xF2
                db 0xCF
                db 0

.desc:
        dw .desc - gdt_start - 1
        dd gdt_start
        