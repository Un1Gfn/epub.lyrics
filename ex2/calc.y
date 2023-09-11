%{
  #include <ctype.h>
  #include <stdio.h>
  #include <stdlib.h>
  void yyerror(char *s);
  int yylex();
  int symbols[52];
  int symbolVal(char symbol);
  void updateSymbolVal(char symbol, int val);
%}

%union {int u_num; char u_id;}
%start line

%token print
%token exit_command
%token <u_num> number
%token <u_id> identifier

%type <u_num> line exp term
%type <u_id> assignment

%%

/* descriptions of expected inputs     corresponding actions (in C) */

line: assignment ';'      {;}
  | exit_command ';'      {exit(EXIT_SUCCESS);}
  | print exp ';'    	    {printf("Printing %d\n", $2);}
  | line assignment ';'	  {;}
  | line print exp ';'	  {printf("Printing %d\n", $3);}
  | line exit_command ';' {exit(EXIT_SUCCESS);}
  ;

assignment: identifier '=' exp {updateSymbolVal($1,$3);}
  ;

exp: term        {$$ = $1;}
  | exp '+' term {$$ = $1 + $3;}
  | exp '-' term {$$ = $1 - $3;}
  ;

term: number   {$$ = $1;}
  | identifier {$$ = symbolVal($1);} 
  ;

%%

int computeSymbolIndex(char token){
  int idx = -1;
  if(islower(token)){
    idx = token - 'a' + 26;
  } else if(isupper(token)){
    idx = token - 'A';
  }
  return idx;
} 

/* returns the value of a given symbol */
int symbolVal(char symbol){
  int bucket = computeSymbolIndex(symbol);
  return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val){
  int bucket = computeSymbolIndex(symbol);
  symbols[bucket] = val;
}

int main (void){
  /* init symbol table */
  for(int i=0; i<52; i++){
    symbols[i] = 0;
  }
  return yyparse();
}

void yyerror(char *s){
  fprintf (stderr, "%s\n", s);
}
