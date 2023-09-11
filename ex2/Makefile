# https://youtu.be/54bo1qaHAfk
# https://youtu.be/__-wUHG2rfM
# https://github.com/jengelsma/yacc-tutorial

MAKEFLAGS:=-j1

OPT:=/opt/homebrew/opt

# $(OPT)/flex/bin/bison
Y:=$(OPT)/bison/bin/yacc

# $(OPT)/flex/bin/flex -v
L:=$(OPT)/flex/bin/lex

C:=$(OPT)/gcc/bin/gcc-13 -std=c11 -Og -g -B$(OPT)/gcc/bin -B$(OPT)/binutils/bin -L$(OPT)/binutils/lib -L$(OPT)/flex/lib
LDLIBS:=-lfl

.PRECIOUS: y.tab.h

default:
	$(MAKE) clean
	$(MAKE) calc.out
	./calc.out <<<"{x/y};{laksjdfksjdf/xnxnxb};"	

calc.out: y.tab.c lex.yy.c
	$(C) -o $@ $^

lex.yy.c: calc.l y.tab.h
	$(L) $<

y.tab.h y.tab.c: calc.y
	$(Y) -d $<

clean:
	@grm -fv calc.out y.tab.h y.tab.c lex.yy.c
	@grm -rfv calc.out.dSYM/

# test:
# 	@grm -fv lex.yy.c
# 	$(L) -v scanner.l
# 	$(C) lex.yy.c scanner.c $(LDLIBS)
# 	gsed -z 's/^\n*\|\n*$$//g' in.txt | ./a.out

# info:
# 	$(C) -print-prog-name=ldx

# clean:
# 	@grm -fv a.out lex.yy.c
