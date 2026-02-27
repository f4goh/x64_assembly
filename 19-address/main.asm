section .data
    a: db 10 
    b: db 20
    c: db 30
    d: db 40

section .text
    global _start

_start:
    xor rdx, rdx            ; RdX = 0
    mov al,[a]
    mov ah,[a+3]
    lea rcx,b
    mov dl,[rcx]
    mov dh,[rcx + 1]


    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

