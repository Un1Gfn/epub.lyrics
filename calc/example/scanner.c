#include <stdio.h>
#include "scanner.h"

extern int yylex();
extern int yylineno;
extern char *yytext;

int main(){
  printf("<p>\n\t");
  int ntoken=-1;
  for(;;){
    // printf("asdlkfj\n");
    ntoken=yylex();
    if(!ntoken)
      break;
    // printf("[%d]", ntoken);
    switch(ntoken){
      case TOKEN_BEGIN_LIGHT:
        printf("<span class=\"x1p8df\">"); break;
      case TOKEN_END_LIGHT:
        printf("</span>"); break;
      case TOKEN_NEWPARAGRAPH:
        printf("<br/>\n</p>\n<p>\n\t"); break;
      case TOKEN_NEWLINE:
        printf("<br/>\n\t"); break;
    }
  }
  printf("<br/>\n</p>\n");
  return 0;
}
