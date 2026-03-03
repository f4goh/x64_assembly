ASM = nasm
ASMFLAGS = -f elf64 -g -F dwarf

LD = ld
LDFLAGS = 

all: main

main: main.o functions.o
	$(LD) -o main main.o functions.o $(LDFLAGS)

main.o: main.asm
	$(ASM) $(ASMFLAGS) main.asm -o main.o

functions.o: functions.asm
	$(ASM) $(ASMFLAGS) functions.asm -o functions.o

clean:
	rm -f *.o main
