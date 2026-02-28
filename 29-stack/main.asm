section .data
    var: dw 256
    
section .text
    global _start

_start:
    mov rax,64
    push rax
    mov rax,25
    push word [var]
    mov word [var],75
    pop word [var]
    pop r10

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


