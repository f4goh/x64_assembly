section .data
    dst: times 3 db 0
    dst_len equ $ - dst
   

section .text
    global _start

_start:
    xor rdx,rdx
    xor r8,r8
    xor r9,r9
    mov al, 'A'
    lea rdi, dst
    mov rcx,dst_len

    cld                 ; Clear Direction Flag → incrémente RSI et RDI après chaque copie
    rep stosb           ; Répète RCX fois : écrit AL à l’adresse [RDI], puis avance RDI

    mov dl, [dst + 0]
    mov r8b, [dst + 1]
    mov r9b, [dst + 2]

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


