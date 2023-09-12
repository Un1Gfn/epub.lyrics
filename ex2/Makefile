# https://youtu.be/54bo1qaHAfk
# https://youtu.be/__-wUHG2rfM
# https://github.com/jengelsma/yacc-tutorial

MAKEFLAGS:=-j1 --no-print-directory

OPT:=/opt/homebrew/opt

# Y:=$(OPT)/bison/bin/yacc
Y:=$(OPT)/bison/bin/bison --graph -Wcounterexamples

# $(OPT)/flex/bin/flex -v
L:=$(OPT)/flex/bin/lex

C:=$(OPT)/gcc/bin/gcc-13 -std=gnu11 -Og -g -B$(OPT)/gcc/bin -B$(OPT)/binutils/bin -L$(OPT)/binutils/lib -L$(OPT)/flex/lib
LDLIBS:=-lfl

.PRECIOUS: y.tab.h

# "x+a+b+c"
# "x+{a/b}+c"
# "x+{a/b}+c+(d)"
# "x+{a/b}+c+(e+{f/g}+h)"
# "(a+b)+({c/d}+e)+f"
# "x+(m+n+o+(p+q))+b"

# "x"
# "x(m(p))b"
# "x{a/b}c"
# "x{a/b}c(d)"
# "x{a/b}c(e{f/g}h)"
# "(a)({c/d}e)f"
# "{x/y}alyyjf{mx92jdf/MMM}xksdkfj(93j)sdf"

default:
	@clear
	# @printf '\\e\[3J'
	$(MAKE) clean
	$(MAKE) calc.out
	dot -Tsvg calc.gv >y.svg
	@echo
	echo; printf %s "x{a/b}c(e{f/g}h)" | ./calc.out; echo

calc.out: calc.tab.c lex.yy.c
	$(C) -o $@ $^

lex.yy.c: calc.l calc.tab.h
	$(L) $<

calc.tab.h calc.tab.c: calc.y
	$(Y) -d $<

clean:
	@grm -fv *.out *.tab.h *.tab.c lex.yy.c *.gv
	@grm -rfv *.out.dSYM/

# test:
# 	@grm -fv lex.yy.c
# 	$(L) -v scanner.l
# 	$(C) lex.yy.c scanner.c $(LDLIBS)
# 	gsed -z 's/^\n*\|\n*$$//g' in.txt | ./a.out

# info:
# 	$(C) -print-prog-name=ldx

# clean:
# 	@grm -fv a.out lex.yy.c
