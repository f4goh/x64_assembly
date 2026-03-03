ASM = nasm
ASMFLAGS = -f elf64 -g -F dwarf

CXX = g++
CXXFLAGS = -g -std=c++17 -mavx   # <- activation AVX

all: main

# Linker final
main: main.o
	$(CXX) -o main main.o

# Compiler le C++ en objet
main.o: main.cpp
	$(CXX) $(CXXFLAGS) -c main.cpp -o main.o

clean:
	rm -f *.o main
