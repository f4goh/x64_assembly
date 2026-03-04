;nasm -f elf64 main.asm -o main.o
;gcc -no-pie main.o -o main -lncurses

global main

extern initscr
extern mvprintw
extern refresh
extern getch
extern endwin

section .data
    msg db "Hello ncurses depuis NASM !", 0

section .text
main:
    sub rsp, 8          ; alignement ABI correct

    ; initscr()
    call initscr

    ; mvprintw(y, x, msg)
    mov rdi, 5
    mov rsi, 10
    mov rdx, msg
    xor eax, eax        ; ABI variadique
    call mvprintw

    ; refresh()
    call refresh

    ; getch()
    call getch

    ; endwin()
    call endwin

    add rsp, 8
    xor eax, eax
    ret

section .note.GNU-stack noalloc noexec nowrite progbits

