# https://youtu.be/54bo1qaHAfk
# https://youtu.be/__-wUHG2rfM
# https://github.com/jengelsma/yacc-tutorial

ifeq ($(shell uname -s),Darwin)
  $(info loading homebrew compat $$PATH ...)
  include /usr/local/share/make/compat.mk
endif

MAKEFLAGS:=-j1 --no-print-directory

# https://gcc.gnu.org/onlinedocs/gcc/Environment-Variables.html
OPT=/opt/homebrew/opt

# C:=clang -fsanitize=memory -fPIE -pie -fno-omit-frame-pointer -g -O2 -L$(OPT)/flex/lib

C:=clang
C+=-std=gnu17 -O1 -g
# C+=-fsanitize=address -fPIE -pie -fno-omit-frame-pointer
# C+=-DNDEBUG
C+=-L$(OPT)/flex/lib

# LDLIBS:=-lfl

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
	@which clang
	@# clear
	@# printf '\\e\[3J'
	$(MAKE) clean
	$(MAKE) calc.out
	dot -Tsvg calc.gv >y.svg
	@echo
	@# echo; env ASAN_OPTIONS="detect_leaks=1" ./calc.out <in.txt; echo
	echo; ./calc.out <in.txt; echo

calc.out: calc.tab.c lex.yy.c
	$(C) -o $@ $^ $(LDLIBS)

lex.yy.c: calc.l calc.tab.h
	flex $<

calc.tab.h calc.tab.c: calc.y
	bison --graph -Wcounterexamples -d $<

clean:
	@grm -fv *.out *.tab.h *.tab.c lex.yy.c *.gv
	@grm -rfv *.out.dSYM/

# test:
# 	@grm -fv lex.yy.c
# 	flex -v scanner.l
# 	$(C) lex.yy.c scanner.c $(LDLIBS)
# 	gsed -z 's/^\n*\|\n*$$//g' in.txt | ./a.out

test:
	nm -a /opt/homebrew/opt/flex/lib/libfl.2.dylib
	@echo
	clang -print-search-dirs
	@echo
	gcc-13 -print-search-dirs
	@echo
	echo | clang -E -Wp,-v -
	@echo
	echo | gcc-13 -E -Wp,-v -
	@echo
	gcc-13 -print-prog-name=ldx -print-prog-name=ranlib
	ranlib -V
	type nm
	type cp
	type clang
	type bison
	type flex
	type nm
	type objcopy
	type ranlib
