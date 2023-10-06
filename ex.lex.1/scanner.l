  // https://westes.github.io/flex/manual/

%{
  #include "scanner.h"
%}

%%

\n\n                return TOKEN_NEWPARAGRAPH;

\n                  return TOKEN_NEWLINE;

"\("                return TOKEN_BEGIN_LIGHT;
"\)"                return TOKEN_END_LIGHT;


%%

int yywrap(){
  return 1;
}
