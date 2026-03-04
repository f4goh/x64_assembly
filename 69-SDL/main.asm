; sdl_rectangle.asm — Dessine un rectangle rouge avec SDL2 en NASM
; Fenêtre invisible au départ, affichée avant le rendu
; Compilation : nasm -f elf64 sdl_main.asm -o sdl_main.o && gcc -no-pie sdl_main.o -o sdl_main -lSDL2

extern SDL_Init
extern SDL_CreateWindow
extern SDL_CreateRenderer
extern SDL_SetRenderDrawColor
extern SDL_RenderClear
extern SDL_RenderFillRect
extern SDL_RenderPresent
extern SDL_PollEvent
extern SDL_DestroyRenderer
extern SDL_DestroyWindow
extern SDL_Quit
extern SDL_ShowWindow      ; afficher la fenêtre

section .data
    SDL_INIT_VIDEO           equ 0x20
    SDL_WINDOWPOS_UNDEFINED  equ 0x1FFF0000
    SDL_WINDOW_HIDDEN        equ 0x8
    SDL_QUIT                 equ 0x100

    title       db "SDL2 Rectangle", 0
    width       equ 640
    height      equ 480

section .bss
    window      resq 1
    renderer    resq 1
    rect        resd 4
    event       resb 56

section .note.GNU-stack       ; pile non exécutable

section .text
    global main

main:
    sub rsp, 8               ; alignement stack System V

    ; -----------------------------
    ; Initialisation SDL
    ; -----------------------------
    mov edi, SDL_INIT_VIDEO
    call SDL_Init

    ; -----------------------------
    ; Création de la fenêtre (invisible)
    ; -----------------------------
    mov rdi, title
    mov esi, SDL_WINDOWPOS_UNDEFINED
    mov edx, SDL_WINDOWPOS_UNDEFINED
    mov ecx, width
    mov r8d, height
    mov r9d, SDL_WINDOW_HIDDEN
    call SDL_CreateWindow
    mov [window], rax

    ; -----------------------------
    ; Création du renderer
    ; -----------------------------
    mov rdi, [window]
    mov esi, -1
    xor edx, edx
    call SDL_CreateRenderer
    mov [renderer], rax

    ; -----------------------------
    ; Afficher la fenêtre avant le rendu
    ; -----------------------------
    mov rdi, [window]
    call SDL_ShowWindow

    ; -----------------------------
    ; Effacer l’écran en noir
    ; -----------------------------
    mov rdi, [renderer]
    xor esi, esi      ; r = 0
    xor edx, edx      ; g = 0
    xor ecx, ecx      ; b = 0
    mov r8d, 255      ; a = 255
    call SDL_SetRenderDrawColor
    call SDL_RenderClear

    ; -----------------------------
    ; Dessiner un rectangle rouge
    ; -----------------------------
    mov rdi, [renderer]
    mov esi, 255      ; r = 255
    xor edx, edx      ; g = 0
    xor ecx, ecx      ; b = 0
    mov r8d, 255      ; a = 255
    call SDL_SetRenderDrawColor

    mov dword [rect], 100
    mov dword [rect+4], 100
    mov dword [rect+8], 200
    mov dword [rect+12], 150

    lea rsi, [rel rect]
    mov rdi, [renderer]
    call SDL_RenderFillRect

    ; Afficher le rendu
    mov rdi, [renderer]
    call SDL_RenderPresent

    ; -----------------------------
    ; Boucle d’attente d’événement
    ; -----------------------------
.wait:
    lea rdi, [rel event]
    call SDL_PollEvent
    test eax, eax
    jz .wait
    cmp dword [event], SDL_QUIT
    jne .wait

    ; -----------------------------
    ; Nettoyage SDL
    ; -----------------------------
    mov rdi, [renderer]
    call SDL_DestroyRenderer
    mov rdi, [window]
    call SDL_DestroyWindow
    call SDL_Quit

    add rsp, 8
    xor eax, eax
    ret
