# SDL2 en Assembleur NASM (x86-64)

Ce README explique comment utiliser SDL2 en assembleur à partir d’un exemple fonctionnel de dessin d’un rectangle rouge et de gestion d’événements.

---

## 1. Vérification et installation de SDL2

Pour compiler et lier un programme SDL2 en ASM, il faut les headers et la librairie de développement SDL2. Vérifiez avec la commande : `ls /usr/include/SDL2/SDL.h`. Si le fichier n’existe pas, installez SDL2 avec : `sudo apt update && sudo apt install libsdl2-dev`.

---

## 2. Fonctions SDL2 les plus utilisées et passage des paramètres

En assembleur x86-64 Linux (System V ABI), les six premiers arguments d’une fonction C sont passés dans les registres : 1er = RDI, 2e = RSI, 3e = RDX, 4e = RCX, 5e = R8, 6e = R9. Les arguments supplémentaires sont passés sur la pile. Les fonctions variadiques requièrent souvent de mettre EAX à zéro avant l’appel, mais SDL2 n’est pas variadique.

Fonctions importantes pour un programme graphique simple :

- `SDL_Init(Uint32 flags)` : Initialise SDL avec le(s) sous-système(s) choisi(s), ex : SDL_INIT_VIDEO.
- `SDL_CreateWindow(title, x, y, w, h, flags)` : Crée une fenêtre SDL (RDI=title, RSI=x, RDX=y, RCX=w, R8=h, R9=flags).
- `SDL_CreateRenderer(window, index, flags)` : Crée un renderer pour dessiner (RDI=window, RSI=index, RDX=flags).
- `SDL_SetRenderDrawColor(renderer, r, g, b, a)` : Définit la couleur de dessin (RDI=renderer, RSI=r, RDX=g, RCX=b, R8=a).
- `SDL_RenderClear(renderer)` : Efface le renderer avec la couleur actuelle.
- `SDL_RenderFillRect(renderer, rect)` : Dessine un rectangle (RDI=renderer, RSI=&rect).
- `SDL_RenderPresent(renderer)` : Affiche le rendu sur la fenêtre.
- `SDL_PollEvent(event)` : Lit le prochain événement (RDI=&event, retourne 1 si un événement a été lu, 0 sinon).
- `SDL_ShowWindow(window)` : Affiche la fenêtre (utile si créée initialement cachée).
- `SDL_DestroyRenderer(renderer)` : Détruit le renderer.
- `SDL_DestroyWindow(window)` : Détruit la fenêtre.
- `SDL_Quit()` : Ferme SDL proprement.

---

## 3. Exemple en assembleur NASM

Exemple complet de dessin d’un rectangle rouge et boucle d’événements SDL2 :

`; Initialisation SDL`
`mov edi, SDL_INIT_VIDEO`
`call SDL_Init`

`; Création de la fenêtre invisible`
`mov rdi, title`
`mov esi, SDL_WINDOWPOS_UNDEFINED`
`mov edx, SDL_WINDOWPOS_UNDEFINED`
`mov ecx, width`
`mov r8d, height`
`mov r9d, SDL_WINDOW_HIDDEN`
`call SDL_CreateWindow`
`mov [window], rax`

`; Création du renderer`
`mov rdi, [window]`
`mov esi, -1`
`xor edx, edx`
`call SDL_CreateRenderer`
`mov [renderer], rax`

`; Afficher la fenêtre avant le rendu`
`mov rdi, [window]`
`call SDL_ShowWindow`

`; Effacer le renderer en noir`
`mov rdi, [renderer]`
`xor esi, esi`
`xor edx, edx`
`xor ecx, ecx`
`mov r8d, 255`
`call SDL_SetRenderDrawColor`
`call SDL_RenderClear`

`; Dessiner un rectangle rouge`
`mov rdi, [renderer]`
`mov esi, 255`
`xor edx, edx`
`xor ecx, ecx`
`mov r8d, 255`
`call SDL_SetRenderDrawColor`

`mov dword [rect], 100`
`mov dword [rect+4], 100`
`mov dword [rect+8], 200`
`mov dword [rect+12], 150`
`lea rsi, [rel rect]`
`mov rdi, [renderer]`
`call SDL_RenderFillRect`

`; Afficher le rendu`
`mov rdi, [renderer]`
`call SDL_RenderPresent`

`; Boucle d’attente d’événement (SDL_QUIT)`
`.wait:`
`lea rdi, [rel event]`
`call SDL_PollEvent`
`test eax, eax`
`jz .wait`
`cmp dword [event], SDL_QUIT`
`jne .wait`

`; Nettoyage SDL`
`mov rdi, [renderer]`
`call SDL_DestroyRenderer`
`mov rdi, [window]`
`call SDL_DestroyWindow`
`call SDL_Quit`

---

## 4. Compilation et linkage

Pour assembler et lier le programme :

`nasm -f elf64 sdl_rectangle.asm -o sdl_rectangle.o`  
`gcc -no-pie sdl_rectangle.o -o sdl_rectangle -lSDL2`

- `-f elf64` : format 64 bits Linux  
- `-no-pie` : désactive Position Independent Executable  
- `-lSDL2` : lie la librairie SDL2

---

## 5. Points importants

- Toujours aligner la pile avant un call (`sub rsp, 8`) et restaurer (`add rsp, 8`)  
- Les couleurs sont passées en 4 registres (r,g,b,a), SDL lit seulement les octets bas  
- Créer la fenêtre invisible puis appeler `SDL_ShowWindow` avant tout rendu pour éviter la fenêtre fantôme  
- SDL_Rect = {x, y, w, h} 4 entiers de 32 bits  
- La boucle d’événements SDL_PollEvent attend proprement la fermeture de la fenêtre

---

## 6. Références

- [SDL2 Wiki](https://wiki.libsdl.org/)  
- [Struct SDL_Rect](https://wiki.libsdl.org/SDL_Rect)  
- [SDL2 Events](https://wiki.libsdl.org/CategoryEvents)
