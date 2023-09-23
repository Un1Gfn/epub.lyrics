%{
  #include <string.h>
  #include "calc.tab.h"
  void yyerror(char *s);
  int yylex();
%}

/* %option bison-bridge */
/* %option verbose */
%option noyywrap

%%
[/{}()]     {return yytext[0];}
[^/{}()]+   {yylval.u_s=strdup(yytext); return plain;}
  /* [^/{}()]+   {yylval->u_s=strdup(yytext); return plain;} */

%%

/*
int yywrap(){
  return 1;
} */
