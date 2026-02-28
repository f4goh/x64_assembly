section .data
    arr: dq 100,150,250
    arr_len equ ($ - arr) / 8

section .text
    global _start

_start:
    mov rcx,arr_len
    lea rdx,[arr]
    call sum

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

sum:
    xor rax,rax
loop:
    add rax,[rdx]
    add rdx,8
    dec rcx
    jnz loop
    ret


