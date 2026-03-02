section .data
    msg db "Hello world!", 10     ; le texte + saut de ligne
    len equ $ - msg              ; longueur du message

section .text
    global _start

_start:
    ; write(1, msg, len)
    mov rax, 1        ; syscall write = 1
    mov rdi, 1        ; stdout = 1
    mov rsi, msg      ; adresse du message
    mov rdx, len      ; longueur
    syscall

    ; exit(0)
    mov rax, 60       ; syscall exit = 60
    xor rdi, rdi      ; code retour = 0
    syscall

