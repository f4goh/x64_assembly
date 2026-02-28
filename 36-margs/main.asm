
;----------------------------------------------------------
; Macro : clrReg
; Paramètres : 1 (nom du registre)
; Rôle : met le registre passé en paramètre à 0
; Usage : clrReg rax
;----------------------------------------------------------
%macro clrReg 1
    xor %1, %1        ; XOR du registre avec lui-même → résultat = 0
%endmacro


;----------------------------------------------------------
; Macro : sum
; Paramètres :
;   %1 = registre destination (obligatoire)
;   %2 = valeur x (défaut = 2)
;   %3 = valeur y (défaut = 8)
;
; Rôle : charge x dans le registre puis ajoute y
;
; Appels possibles :
;   sum rbx          → mov rbx,2  / add rbx,8
;   sum rbx,12       → mov rbx,12 / add rbx,8
;   sum rbx,18,12    → mov rbx,18 / add rbx,12
;----------------------------------------------------------
%macro sum 1-3 2,8
    mov %1, %2        ; %1 ← x (ou valeur par défaut 2)
    add %1, %3        ; %1 ← %1 + y (ou valeur par défaut 8)
%endmacro


section .text
    global _start

_start:
    clrReg rax

    sum rbx
    sum rbx,12
    sum rbx,18,12


    ; exit(0)
    mov rax, 60            ; numéro de syscall pour exit (Linux x86-64)
    xor rdi, rdi           ; code de retour 0
    syscall                ; appel système pour terminer le programme


