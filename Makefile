
all: fizzbuzz

fizzbuzz: fizzbuzz.o
	ld $^ -o fizzbuzz

%.o: %.asm
	nasm $< -f elf64

clean:
	$(RM) *.o fizzbuzz
