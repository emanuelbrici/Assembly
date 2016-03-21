SYMFORMAT=dwarf
FORMAT=elf

gcd: gcd.o 
	gcc -m32 -nostartfiles -g -o gcd gcd.o

gcd.o: gcd.asm
	nasm -f $(FORMAT) -g -F $(SYMFORMAT) gcd.asm

clean:
	rm gcd gcd.o 

archive:
	tar -czvf gcd.tar.gz gcd.asm makefile
