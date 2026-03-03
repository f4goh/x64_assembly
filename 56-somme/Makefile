ASM = nasm
ASMFLAGS = -f elf64 -g -F dwarf

CC = gcc
CFLAGS = -m64 -no-pie -g

all: main

main: main.o
	$(CC) $(CFLAGS) main.o -o main -lc

main.o: main.asm
	$(ASM) $(ASMFLAGS) main.asm -o main.o

clean:
	rm -f main.o main
