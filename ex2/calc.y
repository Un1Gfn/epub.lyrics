%{

  #include <assert.h>
  #include <ctype.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <stdint.h>
  #include <time.h>
  #include <stdbool.h>
  #include "f.h"

  void yyerror(char *s);
  int yylex();

%}

%union {
  uint8_t u_i;
  char *u_s;
}

%start pars

%token <u_s> tk_plain

%token tk_parsep

%type <u_s> exps
%type <u_s> lines
%type <u_s> pars

%%

/* <span class=\"x1p8df\">%s</span> */
/* "<ruby>%s<rt>%s</rt></ruby>" */
/* asprintf(&(...), "...", ...) */

/* N tk_plain */
/* S span  */
/* B ruby  */

exps: tk_plain {$$=f_appendplain($1, strdup(""));};
exps: exps tk_plain {$$=f_appendplain($1, $2);};

exps: '(' exps ')' {$$=f_appendspan(NULL, $2);};
exps: exps '(' exps ')' {$$=f_appendspan($1, $3);};

exps: '{' exps '/' exps '}' {$$=f_appendruby(NULL, $2, $4);};
exps: exps '{' exps '/' exps '}' {$$=f_appendruby($1, $3, $5);};

lines: exps '\n' {$$=f_appendline(NULL, $1);};
lines: lines exps '\n' {$$=f_appendline($1, $2);};

pars: lines tk_parsep {$$=f_appendpar(NULL, $1);};
pars: pars lines tk_parsep {$$=f_appendpar($1, $2);};

%%

int main(){
  setbuf(stdout, NULL); // disable stdout buffering
  int r=yyparse();
  puts("");
  puts("");
  puts((char*)NULL);
  puts(root);
  free(root); root=NULL;
  // char *s=strdup("asdlfjk");
  return r;
}

void yyerror(char *s){
  fprintf(stderr, "%s\n", s);
}
