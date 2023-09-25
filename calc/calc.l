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

^%.*$        {yylval.u_s=strdup(yytext+1); return tk_html;}
^\n          {return tk_parsep;}
\n           {return yytext[0];}
[/{}()]      {return yytext[0];}
[^/{}()\n]+  {yylval.u_s=strdup(yytext); return tk_plain;}

%%

/*
int yywrap(){
  return 1;
} */
