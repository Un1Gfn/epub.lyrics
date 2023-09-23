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

\n\n        {puts("par detected"); return tk_par;}
[/{}()]     {return yytext[0];}
[^/{}()]+   {yylval.u_s=strdup(yytext); return tk_plain;}

%%

/*
int yywrap(){
  return 1;
} */
