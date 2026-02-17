section .data
    var dq 64        ; variable 64 bits

section .text
    global _start

_start:
    xor rcx, rcx
    xor rdx, rdx

    mov rcx, 36  ;mov ecx, 5 efface automatiquement la partie haute du registre 64 bits (rcx)

    add rcx,[var]
    mov rdx,400
    add rdx,rcx
    sub rcx,100
    
    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

