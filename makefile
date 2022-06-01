CC=gcc
ASMBIN=nasm

all : asm cc link
asm : 
	$(ASMBIN) -o write_code.o -f elf -g -l write_code.lst write_code.asm
	$(ASMBIN) -o extend_code.o -f elf -g -l extend_code.lst extend_code.asm
cc :
	$(CC) -m32 -c -g -O0 image.c &> errors.txt
	$(CC) -m32 -c -g -O0 code_gen.c &> errors.txt
link :
	$(CC) -m32 -g -o codegen write_code.o extend_code.o image.o code_gen.o

clean :
	rm errors.txt	
	rm write_code.lst
	rm extend_code.lst
	rm codegen
	rm *.o
