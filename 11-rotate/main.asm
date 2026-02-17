section .text
    global _start

_start:
    xor rcx, rcx            ; RCX = 0
                            ; donc CL = 0 et CH = 0

    mov cl, 65              ; CL = 65  (0x41, ASCII 'A')
    mov ch, 90              ; CH = 90  (0x5A, ASCII 'Z')
                            ; CX = CH:CL = 0x5A41

    rol cx, 8               ; Rotation à gauche de 8 bits
                            ; CX = 0x5A41 devient 0x415A
                            ; (les deux octets sont échangés)

    rol cx, 8               ; Encore une rotation de 8 bits
                            ; CX = 0x415A devient 0x5A41
                            ; On revient à la valeur initiale

    shr cx, 8               ; Décalage logique à droite de 8 bits
                            ; CX = 0x5A41 >> 8 = 0x005A
                            ; CL = 0x5A ('Z'), CH = 0x00

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

