%{
  #include <ctype.h>
  #include <stdio.h>
  #include <stdlib.h>
  void yyerror(char *s);
  int yylex();
%}

%union {
  int u_num;
  char u_id;
  char *u_str;
}

%start root

%token <u_str> somestring

/* %type <u_num> root */

%%

root: something ';'      {;}
  | root something ';'   {;}
  ;

something: '{' somestring '/' somestring '}' {
  printf("<ruby>%s<rt>%s</rt>\n", $2, $4);
  free($2);
  free($4);
  $2 = NULL;
  $4 = NULL;
} ;

%%

int main (void){
  return yyparse();
}

void yyerror(char *s){
  fprintf (stderr, "%s\n", s);
}
