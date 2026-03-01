;----------------------------------------------------------
; Macro : nums
; Paramètres :
;   %1 = premier argument
;   %2 = deuxième argument
;   %3 = troisième argument
;
; Logique :
;   Pour chaque argument passé à la macro :
;       push argument
;   Puis :
;       pop rcx
;       pop rbx
;       pop rax
;
; Remarque :
;   %0 = nombre total d’arguments
;   %rotate 1 = décale les paramètres vers la gauche
;----------------------------------------------------------
%macro nums 3

    ; Répéter autant de fois qu’il y a d’arguments
    %rep %0
        push %1        ; empile l’argument courant
        %rotate 1      ; décale les paramètres
    %endrep

    ; Dépilement dans les registres
    pop rcx
    pop rbx
    pop rax

%endmacro

;----------------------------------------------------------
; Macro : chars
; Paramètre :
;   %1 = chaîne de caractères (ex: "ABC")
;
; Logique :
;   Pour chaque caractère de la chaîne :
;       push sa valeur ASCII
;   Puis :
;       pop rcx
;       pop rbx
;       pop rax
;
; Remarque :
;   %substr est indexé à partir de 1
;----------------------------------------------------------
%macro chars 1

    %assign i 1
    %assign len %strlen(%1)

    %rep len
        %substr ch %1 i,1
        push ch
        %assign i i+1
    %endrep

    pop rcx
    pop rbx
    pop rax

%endmacro




section .text
    global _start

_start:

    nums 1,2,3
    chars "ABC"

    ; exit(0)
    mov rax, 60            ; numéro de syscall pour exit (Linux x86-64)
    xor rdi, rdi           ; code de retour 0
    syscall                ; appel système pour terminer le programme


