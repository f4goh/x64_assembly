
%macro clrRCX 0        ; 0 signifie que la macro ne prend pas d'arguments
    xor rcx, rcx
%endmacro

%macro clrRAX 0        ; 0 signifie que la macro ne prend pas d'arguments
    xor rax, rax
%endmacro


section .text
    global _start

_start:
    clrRAX
    clrRCX

    ; exit(0)
    mov rax, 60            ; numéro de syscall pour exit (Linux x86-64)
    xor rdi, rdi           ; code de retour 0
    syscall                ; appel système pour terminer le programme


