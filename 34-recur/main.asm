
section .text
    global _start

_start:
    mov rax, 1            ; initialise RAX = 1 (premier terme de la suite Fibonacci)
    mov rdx, 1            ; initialise RDX = 1 (second terme de la suite Fibonacci)
    call fib              ; appelle la fonction fib

    ; exit(0)
    mov rax, 60           ; numéro de syscall pour exit (Linux x86-64)
    xor rdi, rdi          ; code de retour 0
    syscall               ; appel système pour terminer le programme

; ----------------------
fib:
    mov rcx, rdx          ; copie RDX dans RCX (enregistrement temporaire)
    xadd rax, rdx         ; additionne RAX+RDX et place l’ancien RAX dans RDX
    cmp rax, 5            ; compare le nouveau RAX avec 5 (condition d’arrêt)
    jg finish             ; si RAX > 5, saute à finish
    call fib              ; sinon, rappelle récursivement fib
finish:
    ret                   ; retourne à l’appelant, RAX contient le terme courant
