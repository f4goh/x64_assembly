section .data
    src: db 'abc'
    src_len equ $ - src
    ;dst: times 3 db 0  ; ou section .bss

section .bss
    dst: resb 3
   

section .text
    global _start

_start:
    xor rdx,rdx
    xor r8,r8
    xor r9,r9
    lea rsi, src
    lea rdi, dst
    mov rcx,src_len

    cld                 ; Clear Direction Flag → incrémente RSI et RDI après chaque copie
    rep movsb           ; Copie RCX blocs de 1 octet de [RSI] vers [RDI]

    mov dl, [dst + 0]
    mov r8b, [dst + 1]
    mov r9b, [dst + 2]

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


