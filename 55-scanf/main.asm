BITS 64       ; Mode 64-bit

section .data
    prompt db "Entrez un texte : ", 0
    formatInput db "%s", 0          ; format pour scanf (chaîne)
    formatOutput db "Texte saisi : %s", 10, 0 ; format pour printf + saut de ligne

section .bss
    buffer resb 100       ; réserve 100 octets pour la chaîne

section .note.GNU-stack

global main
extern printf
extern scanf

section .text

main:
        push rbp
        mov rbp, rsp

        ; afficher le prompt
        mov rdi, prompt
        xor rax, rax
        call printf

        ; scanf("%s", buffer)
        mov rdi, formatInput
        lea rsi, [buffer]    ; adresse du buffer
        xor rax, rax
        call scanf

        ; printf("Texte saisi : %s\n", buffer)
        mov rdi, formatOutput
        lea rsi, [buffer]
        xor rax, rax
        call printf

        pop rbp
        mov rax, 0
        ret

