section .data
    rows: db 0,1,2,3, 10,11,12,13, 20,21,22,23          ; byte  (1 octet)
    cols: db 0,10,20, 1,11,21, 2,12,22, 3,13,23        ; byte  (1 octet)
    arrA: dd 0,1,2,3, 10,11,12,13, 20,21,22,23      ; dword (4 octets)
    arrB: dd 0,10,20, 1,11,21, 2,12,22, 3,13,23

section .text
    global _start

_start:
    mov cl,[rows]
    mov ch,[cols]
    mov r8d,[arrA]
    mov r9d,[arrB]

    mov cl,[rows + 5]
    mov ch,[cols + 4]

    mov r8d,[arrA + (8*4)]
    mov r9d,[arrB + (2*4)]


    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

