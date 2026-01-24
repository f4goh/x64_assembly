VALUE equ 12

section .text
    global _start

_start:
    mov rcx, VALUE              ; rcx = 12
    mov rdx, VALUE + 8          ; rdx = 20
    mov rcx, VALUE + 8 * 2      ; rcx = 28
    mov rdx, (VALUE + 8) * 2    ; rdx = 40
    mov rcx, VALUE % 5          ; rcx = 12 % 5 = 2
    mov rdx, (VALUE - 3) / 3    ; rdx = (12 - 3) / 3 = 3

    mov rax, 60
    xor rdi, rdi
    syscall

