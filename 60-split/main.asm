extern DoAdd
extern DoSub
extern DoMul
extern DoDiv

section .text
    global _start

_start:

    ; ----- Addition -----
    mov rcx,8        ; premier opérande
    mov rdx,16       ; deuxième opérande
    call DoAdd       ; rax = 8 + 16
    mov r8, rax      ; sauvegarde le résultat de l'addition

    ; ----- Soustraction -----
    mov rcx,9
    mov rdx,3
    call DoSub       ; rax = 9 - 3
    mov r9, rax      ; sauvegarde le résultat de la soustraction

    ; ----- Multiplication -----
    ; rax contient toujours le dernier résultat (soustraction)
    call DoMul       ; rax = rax * rcx (rcx n'est pas réinitialisé ici)
    mov r10, rax     ; sauvegarde le résultat de la multiplication

    ; ----- Division -----
    ; rax contient le dernier résultat (multiplication)
    call DoDiv       ; rax = rax / rcx
    mov r11, rax     ; sauvegarde le résultat de la division

    ; ----- exit -----
    mov rax, 60
    xor rdi, rdi
    syscall
