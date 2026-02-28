
section .text
    global _start

_start:
    xor rax, rax           ; RAX = 0, initialise registre pour calculs
    push 100               ; empile l’argument (100) sur la pile

    call total             ; appelle la fonction total

    add rsp, 8             ; libère l’argument de la pile (équivalent à 1 pop)

    ; exit(0)
    mov rax, 60            ; numéro de syscall pour exit (Linux x86-64)
    xor rdi, rdi           ; code de retour 0
    syscall                ; appel système pour terminer le programme

; ----------------------
total:
    push rbp               ; sauvegarde de l’ancien base pointer
    mov rbp, rsp           ; initialise le base pointer pour la fonction
    sub rsp, 16            ; réserve 16 octets sur la pile pour variables locales

    mov rax, [rbp+16]      ; récupère l’argument (100) depuis la pile
    mov [rbp-8], rax       ; stocke l’argument dans la première variable locale
    mov [rbp-16], rax      ; stocke l’argument dans la seconde variable locale
    add rax, [rbp-8]       ; additionne la première variable locale à RAX
    add rax, [rbp-16]      ; additionne la seconde variable locale à RAX

    mov rsp, rbp            ; restaure la pile (supprime variables locales)
    pop rbp                 ; restaure l’ancien base pointer
    ret                     ; retourne à l’appelant (RAX contient le total)

