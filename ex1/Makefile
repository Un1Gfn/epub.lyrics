# https://youtu.be/54bo1qaHAfk
# https://youtu.be/__-wUHG2rfM

MAKEFLAGS:=-j1

OPT:=/opt/homebrew/opt
LEX:=$(OPT)/flex/bin/flex
C:=$(OPT)/gcc/bin/gcc-13 -B$(OPT)/gcc/bin -B$(OPT)/binutils/bin -L$(OPT)/binutils/lib -L$(OPT)/flex/lib
# LDLIBS:=-lfl
# CFLAGS:=-B$(OPT)/gcc/bin -B$(OPT)/binutils/bin
# LDFLAGS:=-L$(OPT)/binutils/lib
# CPPFLAGS:=-I$(OPT)/binutils/include

test:
	@grm -fv lex.yy.c
	$(LEX) -v scanner.l
	$(C) lex.yy.c scanner.c $(LDLIBS)
	gsed -z 's/^\n*\|\n*$$//g' in.txt | ./a.out

info:
	$(C) -print-prog-name=ldx

clean:
	@grm -fv a.out lex.yy.c
