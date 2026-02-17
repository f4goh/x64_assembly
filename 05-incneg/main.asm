section .data
    var dq 99        ; variable 64 bits

section .text
    global _start

_start:
    xor rcx, rcx
    inc qword [var]
    mov rcx,51
    dec rcx
    neg rcx
    
    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

