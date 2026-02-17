section .text
    global _start

_start:
    xor rax, rax        ; RAX = 0
    xor rbx, rbx        ; RBX = 0
    xor rdx, rdx        ; RDX = 0 (prépare RDX:RAX pour une division positive)

    mov rax,100         ; RAX = 100 (dividende)
    mov rbx,3           ; RBX = 3   (diviseur)

    ; --- IDIV (division signée) ---
    ; idiv rbx
    ; Divise le nombre signé RDX:RAX (0:100) par RBX (3)
    ; Quotient  = 33
    ; Reste     = 1
    idiv rbx            ; RAX = 33, RDX = 1

    mov rax,-100        ; RAX = -100 (dividende négatif)

    ; --- CQO : sign-extend RAX en RDX:RAX ---
    ; cqo copie le bit de signe de RAX dans tout RDX
    ; Si RAX = -100 → RDX = -1 (0xFFFFFFFFFFFFFFFF)
    ; On obtient un dividende 128 bits correct pour idiv
    cqo                 ; RDX:RAX = -1 : -100

    ; --- IDIV avec dividende négatif ---
    ; Divise RDX:RAX (-100) par RBX (3)
    ; Quotient = -33
    ; Reste    = -1
    idiv rbx            ; RAX = -33, RDX = -1

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

