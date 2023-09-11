%{
  #include <string.h>
  #include "y.tab.h"
  void yyerror(char *s);
  int yylex();
%}

%%

[a-zA-Z]+       {yylval.u_str=strdup(yytext); return somestring;}
[ \t\n]         ;
[;/{}]          {return yytext[0];}
.               {ECHO; yyerror ("unexpected character");}

%%

int yywrap(){
  return 1;
}
