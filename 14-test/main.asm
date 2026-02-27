section .text
    global _start

_start:
    xor rcx,rcx
    mov rcx,0111b        ; rcx = 0b0111
    test rcx,0001b       ; 0111 AND 0001 = 0001
                         ; PE = 0 (1 bit à 1 → impair)
                         ; ZR = 0 (résultat ≠ 0)

    mov rcx,1000b        ; rcx = 0b1000
    test rcx,0001b       ; 1000 AND 0001 = 0000
                         ; PE = 1 (0 → parité paire)
                         ; ZR = 1 (résultat = 0)

    mov rcx,0111b        ; rcx = 0b0111
    test rcx,0100b       ; 0117 AND 0100 = 0100
                         ; PE = 0 (1 bit à 1 → impair)
                         ; ZR = 0 (résultat ≠ 0)

    mov rcx,1000b        ; rcx = 0b1000
    test rcx,0100b       ; 1000 AND 0100 = 0000
                         ; PE = 1 (0 → parité paire)
                         ; ZR = 1 (résultat = 0)



    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


