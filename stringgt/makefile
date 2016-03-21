SYMFORMAT=dwarf
FORMAT=elf

stringgt: stringgt.o main.o
	gcc -m32 -g -o stringgt stringgt.o main.o

stringgt.o: stringgt.asm
	nasm -f $(FORMAT) -g -F $(SYMFORMAT) stringgt.asm

main.o: main.c
	gcc -m32 -g -c -Wall -std=c99 -pedantic main.c

clean:
	rm stringgt main.o stringgt.o

archive:
	tar -czvf stringgt.tar.gz main.c stringgt.asm makefile
