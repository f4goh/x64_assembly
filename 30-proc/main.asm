    
section .text
    global _start

_start:
    mov rax,8
    call zeroRAX

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

zeroRAX:
    xor rax,rax
    ret


