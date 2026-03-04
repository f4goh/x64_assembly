# SDL2_mixer en Assembleur NASM (x86-64)

Ce README explique comment utiliser **SDL2_mixer** en assembleur pour lire un fichier audio, y compris les modules MOD de type Amiga.

---

## 1. Installation de SDL2 et SDL2_mixer

Pour utiliser SDL2 et SDL2_mixer, il faut installer les librairies de développement :

```bash
sudo apt update
sudo apt install libsdl2-dev libsdl2-mixer-dev
```

Vérification :

```bash
ls /usr/include/SDL2/SDL.h
ls /usr/include/SDL2/SDL_mixer.h
```

Si les fichiers existent, les headers sont bien installés.

---

## 2. Fonctions les plus courantes de SDL2_mixer

| Fonction               | Description                                                                 |
| ---------------------- | --------------------------------------------------------------------------- |
| `SDL_Init(flags)`       | Initialise SDL avec les fonctionnalités choisies (`SDL_INIT_AUDIO`).       |
| `SDL_Quit()`            | Ferme SDL proprement.                                                      |
| `Mix_OpenAudio(f, fmt, ch, sz)` | Initialise SDL_mixer avec fréquence, format, canaux et taille du buffer. |
| `Mix_CloseAudio()`      | Ferme SDL_mixer.                                                           |
| `Mix_LoadMUS(filename)` | Charge un fichier audio (MOD, MP3, OGG, etc.) et retourne un pointeur Mix_Music. |
| `Mix_PlayMusic(music, loops)` | Joue la musique chargée. `loops=-1` pour boucle infinie.               |
| `Mix_HaltMusic()`       | Arrête immédiatement la lecture de la musique.                            |
| `Mix_FreeMusic(music)`  | Libère la mémoire allouée à la musique.                                    |
| `Mix_PlayingMusic()`    | Retourne 1 si une musique est en cours de lecture, 0 sinon.               |

---

## 3. Passage des paramètres en ASM x86-64 (System V AMD64)

En assembleur Linux 64 bits, les **6 premiers arguments** d’une fonction C sont passés dans les registres :

| Argument | Registre |
| -------- | -------- |
| 1er      | RDI      |
| 2e       | RSI      |
| 3e       | RDX      |
| 4e       | RCX      |
| 5e       | R8       |
| 6e       | R9       |

Les arguments supplémentaires sont passés sur la pile.  
Les fonctions variadiques nécessitent parfois de mettre `EAX=0` avant l’appel, mais ce n’est pas nécessaire pour SDL2_mixer.

---

## 4. Exemple : lecture d’un fichier MOD en ASM

Le code suivant lit `galactica.mod` dans le même répertoire que l’exécutable et attend que l’utilisateur appuie sur Entrée pour quitter.

```asm
; main.asm — Lecture d'un fichier MOD avec SDL2_mixer
extern SDL_Init
extern SDL_Quit
extern Mix_OpenAudio
extern Mix_CloseAudio
extern Mix_LoadMUS
extern Mix_PlayMusic
extern Mix_HaltMusic
extern Mix_FreeMusic
extern getchar

section .data
    SDL_INIT_AUDIO equ 0x10
    MIX_DEFAULT_FREQUENCY equ 44100
    MIX_DEFAULT_FORMAT equ 0x8010
    MIX_DEFAULT_CHANNELS equ 2
    filename db "./galactica.mod",0

section .bss
    music resq 1

section .note.GNU-stack

section .text
    global main

main:
    sub rsp, 8

    ; Initialisation SDL audio
    mov edi, SDL_INIT_AUDIO
    call SDL_Init

    ; Initialisation SDL2_mixer
    mov edi, MIX_DEFAULT_FREQUENCY
    mov esi, MIX_DEFAULT_FORMAT
    mov edx, MIX_DEFAULT_CHANNELS
    mov ecx, 1024
    call Mix_OpenAudio

    ; Charger le module MOD
    lea rdi, [rel filename]
    call Mix_LoadMUS
    mov [music], rax
    test rax, rax
    jz .quit

    ; Jouer en boucle infinie
    mov rdi, [music]
    mov esi, -1
    call Mix_PlayMusic

.wait:
    call getchar
    cmp eax, 10
    jne .wait

.quit:
    mov rdi, [music]
    call Mix_HaltMusic

    mov rdi, [music]
    call Mix_FreeMusic

    call Mix_CloseAudio
    call SDL_Quit

    add rsp, 8
    xor eax, eax
    ret
```

---

## 5. Compilation et exécution

```bash
nasm -f elf64 main.asm -o main.o
gcc -no-pie main.o -o main -lSDL2 -lSDL2_mixer
./main
```

- Le programme attend qu’on appuie sur **Entrée** pour quitter.  
- `./galactica.mod` doit être présent dans le même répertoire que l’exécutable.  
- Pour une lecture continue sans interaction, on peut remplacer la boucle `getchar` par `Mix_PlayingMusic()` pour vérifier si la musique joue toujours.

---

## 6. Points importants

1. SDL2_mixer joue la musique en **arrière-plan**, donc si le programme se termine, la musique s’arrête immédiatement.  
2. Toujours aligner la pile avant un `call` (`sub rsp, 8` ou `sub rsp, 16`).  
3. SDL2_mixer supporte de nombreux formats : MOD, MP3, OGG, WAV.  
4. Vérifier que `Mix_LoadMUS` ne retourne pas `NULL` pour éviter des crashes.

---

## Références

- [SDL2 documentation](https://wiki.libsdl.org/FrontPage)  
- [SDL2_mixer documentation](https://www.libsdl.org/projects/SDL_mixer/)  
