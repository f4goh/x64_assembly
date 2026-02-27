section .text
    global _start

_start:
    xor rdx, rdx            ; RDX = 0
    mov rcx,0
loop:
    mov rdx,rcx
    inc rcx
    cmp rcx,3
    je finish
    jmp loop
finish:

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


