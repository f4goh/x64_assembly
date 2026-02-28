# x64_assembly
https://sonictk.github.io/asm_tutorial/

# NASM — Déclarations de variables

## Section .data (variables initialisées)

| Directive | Taille | Description |
|------------|--------|-------------|
| db | 1 octet  | define byte |
| dw | 2 octets | define word |
| dd | 4 octets | define double word |
| dq | 8 octets | define quad word |
| dt | 10 octets | define ten bytes (float étendu x87) |

### Exemples

var8    db  10
str     db  'abc', 0

var16   dw  1000
var32   dd  100000
var64   dq  10000000000

tab8    db  1,2,3,4,5
tab32   dd  10,20,30


---

## Section .bss (variables non initialisées)

| Directive | Réserve |
|------------|----------|
| resb | bytes |
| resw | words (2 bytes) |
| resd | dwords (4 bytes) |
| resq | qwords (8 bytes) |
| rest | 10 bytes |

### Exemples

buf8    resb 16
buf16   resw 8
buf32   resd 4
buf64   resq 2


---

## Correspondance avec registres

| Taille | Registre 8/16/32/64 bits |
|----------|--------------------------|
| 8 bits   | AL |
| 16 bits  | AX |
| 32 bits  | EAX |
| 64 bits  | RAX |

---

## Particularités de `mov` sur variables

Quand on écrit dans une adresse mémoire, NASM **ne déduit pas la taille automatiquement**. 

### Exemples d’écriture en mémoire

mov byte [match], 1       ; écrit 1 octet (8 bits) à l'adresse de match 
mov word [match], 123     ; écrit 2 octets (16 bits) 
mov dword [match], 100000 ; écrit 4 octets (32 bits) 
mov qword [match], 10000000000 ; écrit 8 octets (64 bits) 

- La taille doit toujours être précisée (`byte`, `word`, `dword`, `qword`) pour éviter l'erreur : 
  operation size not specified 

### Exemples de lecture mémoire selon le registre

mov al, [match]   ; AL = 8 bits → NASM sait qu'on lit 1 octet 
mov ax, [match]   ; AX = 16 bits → NASM sait qu'on lit 2 octets 
mov eax, [match]  ; EAX = 32 bits → NASM sait qu'on lit 4 octets 
mov rax, [match]  ; RAX = 64 bits → NASM sait qu'on lit 8 octets 

### Exemples d’écriture dans un registre (taille implicite)

mov al, 100       ; AL = 8 bits 
mov ax, 100       ; AX = 16 bits 
mov eax, 100      ; EAX = 32 bits 
mov rax, 100      ; RAX = 64 bits 

