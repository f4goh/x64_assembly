section .text
    global _start

_start:
    xor rcx, rcx            ; RCX = 0
                            ; Pas de modification des flags

    mov cl,255              ; CL = 255
                            ; Pas de modification des flags

    add cl,1                ; 255 + 1 = 0 (overflow 8 bits)
                            ; AC=1  CY=1  EI=-  OV=0  PE=1  PL=0  UP=-  ZR=1

    dec cl                  ; 0 - 1 = 255
                            ; AC=-  CY=1  EI=-  OV=0  PE=0  PL=1  UP=-  ZR=0
                            ; (dec ne modifie pas CY)

    mov cl,127              ; CL = 127
                            ; Pas de modification des flags

    add cl,1                ; 127 + 1 = 128 (0x80)
                            ; AC=1  CY=0  EI=-  OV=1  PE=0  PL=1  UP=-  ZR=0

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


