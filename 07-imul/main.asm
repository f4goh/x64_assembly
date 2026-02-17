section .data
    var dq  4       ; variable 64 bits contenant la valeur 4

section .text
    global _start

_start:
    xor rax, rax        ; RAX = 0
    xor rbx, rbx        ; RBX = 0

    mov rax,10          ; RAX = 10
    mov rbx,2           ; RBX = 2

    ; --- IMUL forme 1 : 1 opérande ---
    ; imul rbx
    ; Multiplie RAX * RBX
    ; Résultat 128 bits dans RDX:RAX
    ; RAX = partie basse, RDX = partie haute
    imul rbx            ; RDX:RAX = 10 * 2 = 20
                        ; RAX = 20, RDX = 0

    ; --- IMUL forme 1 avec opérande mémoire ---
    ; imul qword [var]
    ; Multiplie RAX * [var] (4)
    ; Résultat 128 bits dans RDX:RAX
    imul qword [var]    ; RDX:RAX = 20 * 4 = 80
                        ; RAX = 80, RDX = 0

    ; --- IMUL forme 3 : 3 opérandes ---
    ; imul rax, rbx, -3
    ; Calcule : RAX = RBX * (-3)
    ; Ici RBX = 2 → RAX = -6
    ; Résultat 64 bits (pas de RDX utilisé)
    imul rax, rbx, -3   ; RAX = 2 * (-3) = -6

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

