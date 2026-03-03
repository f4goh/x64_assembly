section .data
    prompt db "Entrez un texte : ", 10
    prompt_len equ $ - prompt

section .bss
    buffer resb 100        ; réserve 100 octets pour la saisie

section .text
    global _start

_start:

    ; write(1, prompt, prompt_len)
    mov rax, 1              ; syscall write
    mov rdi, 1              ; stdout
    mov rsi, prompt         ; adresse du message
    mov rdx, prompt_len     ; longueur
    syscall

    ; read(0, buffer, 100)
    mov rax, 0              ; syscall read
    mov rdi, 0              ; stdin
    mov rsi, buffer         ; adresse du buffer
    mov rdx, 100            ; taille max
    syscall
    ; rax contient le nombre de caractères lus

    ; write(1, buffer, rax)
    mov rdx, rax            ; nombre réel de caractères lus
    mov rax, 1              ; syscall write
    mov rdi, 1              ; stdout
    mov rsi, buffer         ; adresse du buffer
    syscall

    ; exit(0)
    mov rax, 60             ; syscall exit
    xor rdi, rdi            ; code retour 0
    syscall
