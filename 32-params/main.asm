
section .text
    global _start

_start:
    xor rax,rax
    push 100
    push 500

    call max

    add rsp,16     ; ou 2 pop

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

max:
    mov rcx, [rsp+16]       ; récupère le premier argument (poussé en dernier) depuis la pile
    mov rdx, [rsp+8]        ; récupère le second argument depuis la pile
    cmp rcx,rdx
    jg large
    mov rax,rdx
    jmp finish
large:
    mov rax,rcx
finish:
    ret


