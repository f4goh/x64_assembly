ASM = nasm
ASMFLAGS = -f elf64 -g -F dwarf

LD = ld
LDFLAGS = 

all: main

main: main.o
	$(LD) -o main main.o $(LDFLAGS)

main.o: main.asm
	$(ASM) $(ASMFLAGS) main.asm -o main.o

clean:
	rm -f *.o main
