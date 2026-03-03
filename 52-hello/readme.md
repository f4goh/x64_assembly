# SYSCALLS LINUX x86-64 — FICHE DE SYNTHÈSE (NASM)

Architecture : x86-64 
Instruction : `syscall`

https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md

https://x64.syscall.sh/


---

## 📌 Convention d’appel (ABI Linux x86-64)

| Registre | Rôle |
|----------|------|
| `rax` | Numéro du syscall |
| `rdi` | Argument 1 |
| `rsi` | Argument 2 |
| `rdx` | Argument 3 |
| `r10` | Argument 4 |
| `r8`  | Argument 5 |
| `r9`  | Argument 6 |
| `rax` | Valeur de retour |

⚠️ Si `rax < 0` → erreur (`-errno`)

---

# Entrées / Sorties

| Nom | Numéro | Description |
|-----|--------|------------|
| `read`  | 0 | Lire depuis un descripteur |
| `write` | 1 | Écrire vers un descripteur |
| `close` | 3 | Fermer un descripteur |
| `lseek` | 8 | Déplacer le curseur |

# SYSCALLS FONDAMENTAUX

| Nom     | Numéro | Description |
|----------|--------|------------|
| `read`   | 0  | Lire depuis un descripteur |
| `write`  | 1  | Écrire vers un descripteur |
| `exit`   | 60 | Terminer le programme |

---

# PROCESSUS

| Nom        | Numéro |
|------------|--------|
| `exit`     | 60 |
| `fork`     | 57 |
| `execve`   | 59 |
| `wait4`    | 61 |
| `getpid`   | 39 |
| `getppid`  | 110 |
| `kill`     | 62 |

---

## Descripteurs standards

| Valeur | Signification |
|--------|--------------|
| `0` | stdin |
| `1` | stdout |
| `2` | stderr |

---

# Gestion des fichiers

| Nom | Numéro | Description |
|-----|--------|------------|
| `open`   | 2   | Ouvre un fichier |
| `openat` | 257 | Version moderne de open |
| `close`  | 3   | Ferme fichier |
| `unlink` | 87  | Supprime fichier |
| `rename` | 82  | Renomme fichier |
| `mkdir`  | 83  | Crée dossier |
| `rmdir`  | 84  | Supprime dossier |

## Flags pour `open`

```c
O_RDONLY = 0
O_WRONLY = 1
O_RDWR   = 2
O_CREAT  = 64
O_TRUNC  = 512
O_APPEND = 1024


# EXEMPLES MINIMAUX

## 🔹 read (clavier)

```asm
mov rax, 0      ; read
mov rdi, 0      ; stdin
mov rsi, buffer
mov rdx, taille
syscall

## 🔹 write (clavier)

```asm
mov rax, 1      ; write
mov rdi, 1      ; stdout
mov rsi, buffer
mov rdx, taille
syscall

## 🔹 Exit

```asm
mov rax, 60     ; exit
xor rdi, rdi    ; code 0
syscall

