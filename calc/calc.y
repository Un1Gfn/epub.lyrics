%{

  #include <stddef.h>
  #include <stdint.h>
  #include <stdio.h>
  #include <string.h> // strdup
  #include "f.h"

  void yyerror(char *s);
  int yylex();

%}

%union {
  uint8_t u_i;
  char *u_s;
}

%token <u_s> tk_plain
%token <u_s> tk_html
%token tk_parsep

%type <u_s> exps
%type <u_s> lines
%type <u_s> pars

%start pars

%%

/* <span class=\"x1p8df\">%s</span> */
/* "<ruby>%s<rt>%s</rt></ruby>" */
/* asprintf(&(...), "...", ...) */

/* N tk_plain */
/* S span  */
/* B ruby  */

exps:      tk_plain {$$=f_appendplain($1, strdup(""));};
exps: exps tk_plain {$$=f_appendplain($1, $2);};

exps:      '(' exps ')' {$$=f_appendspan(NULL, $2);};
exps: exps '(' exps ')' {$$=f_appendspan($1, $3);};

exps:      '{' exps '/' exps '}' {$$=f_appendruby(NULL, $2, $4);};
exps: exps '{' exps '/' exps '}' {$$=f_appendruby($1, $3, $5);};

lines:       exps '\n' {$$=f_appendline(NULL, $1);};
lines: lines exps '\n' {$$=f_appendline($1, $2);};

lines:       tk_html '\n' {$$=f_appendline(NULL, $1);};
lines: lines tk_html '\n' {$$=f_appendline($1, $2);};

pars:      lines tk_parsep {$$=f_appendpar(NULL, $1);};
pars: pars lines tk_parsep {$$=f_appendpar($1, $2);};

%%

void yyerror(char *s){
  fprintf(stderr, "%s\n", s);
}
