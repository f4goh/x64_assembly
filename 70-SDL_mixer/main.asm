; main.asm — Lecture d'un fichier MOD avec SDL2_mixer
; Compilation :
; nasm -f elf64 main.asm -o main.o
; gcc -no-pie main.o -o main -lSDL2 -lSDL2_mixer

; Déclaration des fonctions externes de SDL2 et SDL2_mixer
extern SDL_Init
extern SDL_Quit
extern Mix_OpenAudio
extern Mix_CloseAudio
extern Mix_LoadMUS
extern Mix_PlayMusic
extern Mix_HaltMusic
extern Mix_FreeMusic
extern getchar                 ; fonction standard C pour attendre une touche

; =============================
; Données
; =============================
section .data
    SDL_INIT_AUDIO equ 0x10                 ; flag SDL pour initialiser uniquement l'audio
    MIX_DEFAULT_FREQUENCY equ 44100         ; fréquence audio par défaut
    MIX_DEFAULT_FORMAT equ 0x8010           ; format audio (AUDIO_S16SYS)
    MIX_DEFAULT_CHANNELS equ 2              ; nombre de canaux (stéréo)

    filename db "./galactica.mod",0        ; nom du module MOD à jouer (chemin relatif)

; =============================
; Zone BSS (variables non initialisées)
; =============================
section .bss
    music resq 1                             ; pointeur vers la musique chargée (Mix_Music *)

; =============================
; Section pour indiquer pile non-exécutable
; =============================
section .note.GNU-stack

; =============================
; Code
; =============================
section .text
    global main

main:
    sub rsp, 8                               ; alignement de la pile à 16 octets pour l’ABI System V

    ; -----------------------------
    ; Initialisation SDL audio
    ; -----------------------------
    mov edi, SDL_INIT_AUDIO                  ; mettre le flag SDL_INIT_AUDIO dans EDI (1er argument)
    call SDL_Init                             ; appeler SDL_Init(SDL_INIT_AUDIO)

    ; -----------------------------
    ; Initialisation SDL2_mixer
    ; Mix_OpenAudio(frequency, format, channels, chunksize)
    ; -----------------------------
    mov edi, MIX_DEFAULT_FREQUENCY            ; fréquence audio = 44100 Hz
    mov esi, MIX_DEFAULT_FORMAT               ; format = AUDIO_S16SYS
    mov edx, MIX_DEFAULT_CHANNELS             ; stéréo
    mov ecx, 1024                             ; taille du buffer audio
    call Mix_OpenAudio                         ; appel Mix_OpenAudio(frequency, format, channels, 1024)

    ; -----------------------------
    ; Charger le module MOD
    ; -----------------------------
    lea rdi, [rel filename]                  ; adresse de la chaîne "./galactica.mod"
    call Mix_LoadMUS                          ; Mix_LoadMUS(filename)
    mov [music], rax                          ; stocker le pointeur renvoyé dans music
    test rax, rax                             ; tester si le chargement a échoué (rax == 0)
    jz .quit                                  ; si échec, sauter vers la sortie

    ; -----------------------------
    ; Jouer le module en boucle infinie
    ; -----------------------------
    mov rdi, [music]                          ; 1er argument = pointeur musique
    mov esi, -1                               ; 2e argument = -1 pour boucle infinie
    call Mix_PlayMusic                         ; Mix_PlayMusic(music, -1)

    ; -----------------------------
    ; Attente simple : l'utilisateur appuie sur Entrée pour arrêter
    ; -----------------------------
.wait:
    call getchar                               ; lire un caractère depuis stdin
    cmp eax, 10                                ; comparer avec code ASCII Entrée (10)
    jne .wait                                  ; si pas Entrée, recommencer

.quit:
    ; -----------------------------
    ; Arrêt de la musique et nettoyage
    ; -----------------------------
    mov rdi, [music]
    call Mix_HaltMusic                         ; arrêter la lecture de la musique

    mov rdi, [music]
    call Mix_FreeMusic                         ; libérer la musique chargée

    call Mix_CloseAudio                         ; fermer SDL2_mixer
    call SDL_Quit                               ; quitter SDL

    add rsp, 8                                  ; restaurer la pile
    xor eax, eax                                ; valeur de retour 0
    ret
