#include <stdlib.h>
#include <stdio.h>

#include "f.h"

int main(){
  int r=yyparse();
  printf("%s", root);
  free(root);
  return r;
}
