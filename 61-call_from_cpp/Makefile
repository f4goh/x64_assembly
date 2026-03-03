ASM = nasm
ASMFLAGS = -f elf64 -g -F dwarf

CXX = g++
CXXFLAGS = -g -std=c++17

all: main

# Linker final
main: main.o functions.o
	$(CXX) -o main main.o functions.o

# Compiler le C++ en objet
main.o: main.cpp
	$(CXX) $(CXXFLAGS) -c main.cpp -o main.o

# Compiler l'ASM en objet
functions.o: functions.asm
	$(ASM) $(ASMFLAGS) functions.asm -o functions.o

clean:
	rm -f *.o main
