section .data
    var dq 0        ; variable 64 bits

section .text
    global _start

_start:
    xor rcx, rcx
    xor rdx, rdx

    mov rcx, 5  ;mov ecx, 5 efface automatiquement la partie haute du registre 64 bits (rcx)

    xchg rcx, [var]    ; rcx = contenu de var ou  xchg [var],rcx 
    mov dl,3
    xchg dh,dl          ; ou xchg dl,dh

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

