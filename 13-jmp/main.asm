section .text
    global _start

_start:
    xor r14,r14
    xor r15,r15
    jmp next
    mov r14,100
next:
    mov r15,final
    jmp r15
    mov r14,100
final:




    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


