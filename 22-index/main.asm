section .data
    arr: dq 10,20,30
    arr_len equ ($ - arr) / 8

section .text
    global _start

_start:
    lea rsi, arr
    mov rcx,0

loop:
    mov rdx, [rsi + rcx*8]   ; 8 car qword
    inc rcx
    cmp rcx, arr_len
    jne loop

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

