ASM = nasm
ASMFLAGS = -f elf64 -g -F dwarf

CC = gcc
LDFLAGS = -lraylib -ldl -lm -lpthread -no-pie

all: main

main: main.o
	$(CC) main.o -o main $(LDFLAGS)

main.o: main.asm
	$(ASM) $(ASMFLAGS) main.asm -o main.o

clean:
	rm -f *.o main

