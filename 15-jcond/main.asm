section .text
    global _start

_start:
    xor rdx, rdx            ; RDX = 0
    mov cl,255
    add cl,1
    jc carry
    mov rdx,1
carry:

    mov cl,-128
    sub cl,1
    jo overflow
    mov rdx,2
overflow:

    mov cl,255
    and cl, 10000000b
    js sign
    mov rdx,3
sign:

    jnz notZero
    mov rdx,4
notZero:

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


