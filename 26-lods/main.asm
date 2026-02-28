section .data
    src: db 'abc'
    src_len equ $ - src
   

section .text
    global _start

_start:
    xor rdx, rdx        ; Met RDX à 0
    xor r8, r8          ; Met R8 à 0
    xor r9, r9          ; Met R9 à 0

    lea rsi, src      ; RSI = adresse de src (source)
    mov rdi, rsi        ; RDI = même adresse → traitement en place
    mov rcx, src_len    ; RCX = nombre d'octets à traiter

    cld                 ; Clear Direction Flag → RSI et RDI seront incrémentés

loop:
    lodsb               ; AL = [RSI], puis RSI++
    sub al, 32          ; Soustrait 32 (ex: conversion minuscule → majuscule ASCII)
    stosb               ; Écrit AL dans [RDI], puis RDI++
    dec rcx             ; Décrémente le compteur
    jnz loop            ; Continue tant que RCX ≠ 0

    mov dl, [src + 0]
    mov r8b, [src + 1]
    mov r9b, [src + 2]

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


