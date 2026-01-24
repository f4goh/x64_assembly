section .data
    var dq 100        ; variable 64 bits

section .text
    global _start

_start:
    xor rcx, rcx
    xor rdx, rdx

    mov rcx, 33       ; rcx = 33
    mov rdx, rcx      ; rdx = 33

    mov rcx, [var]    ; rcx = contenu de var
    mov [var], rdx    ; var = rdx

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

