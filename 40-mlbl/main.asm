;----------------------------------------------------------
; Macro : power
; Paramètres :
;   %1 = base
;   %2 = exponent
;
; Logique :
;   rax = 1
;   rcx = exponent
;   si exponent == 0 :
;       aller à finish
;   rbx = base
;   begin :
;       rax = rax * rbx
;       décrémenter rcx (loop)
;       si rcx != 0 → recommencer
;   finish :
;       résultat final dans rax
;
; Remarque :
;   %%label permet de créer des labels locaux en NASM
;   loop décrémente rcx et saute si rcx ≠ 0
;----------------------------------------------------------
%macro power 2

    mov rax, 1            ; rax = 1 (valeur initiale)
    mov rcx, %2           ; rcx = exponent
    cmp rcx, 0
    je %%finish           ; si exponent = 0 → fin

    mov rbx, %1           ; rbx = base

%%begin:
    mul rbx               ; rdx:rax = rax * rbx
    loop %%begin          ; rcx-- et saute si rcx ≠ 0

%%finish:

%endmacro




section .text
    global _start

_start:

    power 4,2
    power 4,3

    ; exit(0)
    mov rax, 60            ; numéro de syscall pour exit (Linux x86-64)
    xor rdi, rdi           ; code de retour 0
    syscall                ; appel système pour terminer le programme


