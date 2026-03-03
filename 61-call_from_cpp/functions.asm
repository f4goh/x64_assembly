section .note.GNU-stack                  ; indique que la pile n’est pas exécutable

section .text
    global DoSum

; ----- Addition -----
; System V AMD64 calling convention (Linux)
; premier argument -> rdi
; deuxième argument -> rsi
; valeur de retour -> rax
DoSum:
    mov rax, rdi      ; charge le premier argument dans rax (registre de retour)
    add rax, rsi      ; additionne le deuxième argument
    ret                ; rax contient la valeur retournée

