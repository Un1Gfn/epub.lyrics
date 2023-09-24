#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "f.h"

extern FILE *yyin;
int yyparse();

char buf[]="\
x\n\
x(m(p))b\n\
x{a/b}c\n\
x{a/b}c(d)\n\
x{a/b}c(e{f/g}h)\n\
(a)({c/d}e)f\n\
{x/y}alyyjf{mx92jdf/MMM}xksdkfj(93j)sdf\n\
\n\
xxx\n\
x({먹/머}a{어/거})\n\
c(hahaha){kkkkk/s}\n\
\n\
xxx\n\
x({먹/머}b{어/거})\n\
c(hahaha){kkkkk/s}\n\
\n\
";

int main(){

  setbuf(stdout, NULL); // disable stdout buffering

  // printf("@%s@\n", buf);
  // return 0;
  assert((yyin=fmemopen(buf, strlen(buf), "r")));

  int r=yyparse();

  puts("");
  puts("");
  puts((char*)NULL);
  puts(root);
  free(root);

  return r;

}
