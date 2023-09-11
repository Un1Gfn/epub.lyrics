%{
  #include <string.h>
  #include "y.tab.h"
  void yyerror(char *s);
  int yylex();
%}

%%

[/{}()]     {return yytext[0];}
[^/{}()]+   {yylval.u_str=strdup(yytext); return stuffinside;}

%%

int yywrap(){
  return 1;
}
