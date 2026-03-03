section .text
    global DoAdd
    global DoSub
    global DoMul
    global DoDiv

; ----- Addition -----
DoAdd:
    mov rax,rcx      ; charge le premier opérande
    add rax,rdx      ; additionne le deuxième opérande
    ret

; ----- Soustraction -----
DoSub:
    mov rax,rcx      ; charge le premier opérande
    sub rax,rdx      ; soustrait le deuxième opérande
    ret

; ----- Multiplication -----
DoMul:
    mul rcx          ; multiplie rax par rcx (rax = dernier résultat)
    ret

; ----- Division -----
DoDiv:
    shr rax,1        ; division par 2 avant division entière
    div rcx          ; divise rax par rcx
    ret

