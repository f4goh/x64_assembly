;----------------------------------------------------------
; Macro : scan
; Paramètre :
;   %1 = valeur numérique (constante)
;
; Rôle :
;   Si num > 50  → rax = 1
;   Si num < 50  → rax = 0
;   Sinon (=50)  → rax = num
;----------------------------------------------------------
%macro scan 1
    %if %1 > 50
        mov rax, 1
    %elif %1 < 50
        mov rax, 0
    %else
        mov rax, %1
    %endif
%endmacro


section .text
    global _start

_start:

    scan 100
    scan 0
    scan 50

    ; exit(0)
    mov rax, 60            ; numéro de syscall pour exit (Linux x86-64)
    xor rdi, rdi           ; code de retour 0
    syscall                ; appel système pour terminer le programme


