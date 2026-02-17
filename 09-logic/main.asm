
section .text
    global _start

_start:
    xor rcx, rcx
    xor rdx, rdx
    mov rcx, 0101b
    mov rdx, 0011b
    xor rcx,rdx
    and rcx,rdx
    or  rcx,rdx
    
    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

