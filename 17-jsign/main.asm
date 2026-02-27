section .text
    global _start

_start:
    xor rdx, rdx            ; RDX = 0
    mov rbx,-4
    mov rcx,-1
    cmp rcx,rbx
    jg greater
    mov rdx,1
greater:

    mov rcx,-16
    cmp rcx,rbx
    jl less
    mov rdx,2
less:

    mov rcx,-4
    cmp rcx,rbx
    jle equal
    mov rdx,3
equal:

    cmp rcx,rbx
    jnle notLessOrEqual
    mov rdx,4
notLessOrEqual:

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


