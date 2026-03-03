section .data
    filename db "texte.txt",0
    msg_write db "Bonjour",10
    msg_len equ $ - msg_write

section .text
    global _start

_start:

    ; open("texte.txt", O_WRONLY | O_CREAT, 0666)
    mov rax, 2          ; syscall open
    lea rdi, [filename]
    mov rsi, 1+64       ; O_WRONLY | O_CREAT
    ;mov rdx, 0666       ; lecture/écriture pour owner/group/others
    mov rdx, 0x1B6      ; permissions rw-rw-rw- (il faut convertir 0666 octal en hexadécimal)
    syscall
    mov r12, rax

    cmp rax, 0
    jl exit_program

    ; write
    mov rax, 1
    mov rdi, r12
    lea rsi, [msg_write]
    mov rdx, msg_len
    syscall

    ; close
    mov rax, 3
    mov rdi, r12
    syscall

exit_program:
    mov rax, 60
    xor rdi, rdi
    syscall

