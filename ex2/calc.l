%{
  #include "y.tab.h"
  void yyerror(char *s);
  int yylex();
%}

%%

"print"         {return print;}
"exit"          {return exit_command;}
[a-zA-Z]        {yylval.u_id = yytext[0]; return identifier;}
[0-9]+          {yylval.u_num = atoi(yytext); return number;}
[ \t\n]         ;
[-+=;]          {return yytext[0];}
.               {ECHO; yyerror ("unexpected character");}

%%

int yywrap(){return 1;}
