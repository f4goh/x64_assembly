section .data
    arrA: db 1,2,3          ; byte  (1 octet)
    arrB: dw 10,20,30       ; word  (2 octets)
    arrC: dd 100,200,300    ; dword (4 octets)
    arrD: dq 1000,2000,3000 ; qword (8 octets)

section .text
    global _start

_start:
    mov cl,[arrA]
    mov dx,[arrB]
    mov r8d,[arrC]
    mov r9,[arrD]

    mov cl,[arrA + 1]
    mov dx,[arrB + 2]
    mov r8d,[arrC + 4]
    mov r9,[arrD + 8]

    mov cl,[arrA+ (2*1)]
    mov dx,[arrB + (2*2)]
    mov r8d,[arrC + (2*4)]
    mov r9,[arrD + (2*8)]


    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

