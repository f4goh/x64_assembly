BITS 64

section .data
    prompt1 db "Saisir un premier chiffre entier : ", 0
    prompt2 db "Saisir un deuxieme chiffre entier : ", 0
    formatInt db "%d", 0
    formatOutput db "La somme des deux chiffres est : %d", 10, 0  ; 10 = saut de ligne

section .bss
    value1 resd 1    ; réserve 4 octets pour le premier entier
    value2 resd 1    ; réserve 4 octets pour le deuxième entier

section .note.GNU-stack

global main
extern printf
extern scanf

section .text

main:
        push rbp
        mov rbp, rsp

        ; afficher le prompt1
        mov rdi, prompt1
        xor rax, rax
        call printf

        ; lire premier entier
        mov rdi, formatInt
        lea rsi, [value1]
        xor rax, rax
        call scanf

        ; afficher le prompt2
        mov rdi, prompt2
        xor rax, rax
        call printf

        ; lire deuxième entier
        mov rdi, formatInt
        lea rsi, [value2]
        xor rax, rax
        call scanf

        ; calculer la somme
        mov eax, [value1]
        add eax, [value2]

        ; afficher le résultat
        mov rdi, formatOutput
        mov esi, eax
        xor rax, rax
        call printf

        pop rbp
        mov rax, 0
        ret

