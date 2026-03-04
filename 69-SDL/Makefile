ASM = nasm
ASMFLAGS = -f elf64 -g -F dwarf

CC = gcc
LDFLAGS = -lSDL2 -no-pie

TARGET = main
OBJS = main.o

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET) $(LDFLAGS)

%.o: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@

clean:
	rm -f *.o $(TARGET)
