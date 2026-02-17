section .data
    var dq 2        ; variable 64 bits contenant la valeur 2

section .text
    global _start

_start:
    xor rdx, rdx        ; RDX = 0
                        ; Important : mul/div utilisent RDX:RAX comme opérande implicite

    mov rax,10          ; RAX = 10 (sera utilisé par mul)
    mov rbx,5           ; RBX = 5

    mul rbx             ; multiplication non signée :
                        ; RDX:RAX = RAX * RBX = 10 * 5 = 50
                        ; RAX = 50 (bas 64 bits)
                        ; RDX = 0  (haut 64 bits, car résultat < 2^64)

    mul qword [var]     ; multiplie encore RAX par [var] = 2
                        ; RDX:RAX = 50 * 2 = 100
                        ; RAX = 100
                        ; RDX = 0

    mov rbx,8           ; RBX = 8 (diviseur)

    div rbx             ; division non signée :
                        ; divise RDX:RAX (0:100) par 8
                        ; RAX = quotient = 12
                        ; RDX = reste = 4

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

