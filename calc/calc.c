#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "f.h"

extern FILE *yyin;
int yyparse();

char *calc(char *buf){

  // puts(s);
  // setbuf(stdout, NULL); // disable stdout buffering

  // printf("@%s@\n", buf);
  // return 0;
  assert((yyin=fmemopen(buf, strlen(buf), "r")));

  int r=yyparse();

  // puts("");
  // puts("");
  // puts((char*)NULL);
  // puts(root);
  // free(root);

  return root;

}
