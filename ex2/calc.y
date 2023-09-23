%{

  #include <assert.h>
  #include <ctype.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <stdint.h>
  #include <time.h>
  #include <stdbool.h>

  #ifdef NDEBUG
    #define DEBUGWRAPPER(X) ;
  #else
    #define DEBUGWRAPPER(X) {X;}
  #endif

  void yyerror(char *s);
  int yylex();

  void f_plain(char**, char*);
  void f_appendruby(char**, char*, char*, char*);
  void f_appendspan(char**, char*, char*);

  char *root=NULL;

%}

%union {
  uint8_t u_i;
  char *u_s;
}

%start ex

%token <u_s> tk_plain
%token tk_par

%type <u_s> ex

%%

/* <span class=\"x1p8df\">%s</span> */
/* "<ruby>%s<rt>%s</rt></ruby>" */
/* asprintf(&(...), "...", ...) */

/* N tk_plain */
/* S span  */
/* B ruby  */

ex: tk_plain {f_plain(&($$), $1);};

ex: '(' ex ')' {f_appendspan(&($$), strdup(""), $2);};

ex: '{' ex '/' ex '}' {f_appendruby(&($$), strdup(""), $2, $4);};

ex: ex tk_plain {
  asprintf(&($$), "%s%s", $1, $2);
  free($1); $1=NULL;
  free($2); $2=NULL;
  DEBUGWRAPPER(printf("| +N | %s\n", $$));
  root=$$;
};

ex: ex '(' ex ')' {f_appendspan(&($$), $1, $3);};

ex: ex '{' ex '/' ex '}' {f_appendruby(&($$), $1, $3, $5);};

ex: ex tk_par ex {
  asprintf(&($$), "%s</p> <p>%s\n", $1, $3);
  free($1); $1=NULL;
  free($3); $3=NULL;
  DEBUGWRAPPER(printf("| +P | %s\n", $$));
  root=$$;
};

%%

void f_plain(char **ssp, char *s){
  *ssp=s;
  DEBUGWRAPPER(printf("| .N | %s\n", *ssp));
  root=*ssp;
}

void f_appendruby(char **ssp, char *s, char *rb, char *rt){
  asprintf(ssp, "%s<ruby>%s<rt>%s</rt></ruby>", s, rb, rt);
  free(s);
  free(rb);
  free(rt);
  DEBUGWRAPPER(printf("| +B | %s\n", *ssp));
  root=*ssp;
}

void f_appendspan(char** ssp, char* s, char*sa){
  asprintf(ssp, "%s<span class=\"x1p8df\">%s</span>", s, sa);
  free(s);
  free(sa);
  DEBUGWRAPPER(printf("| +S | %s\n", *ssp));
  root=*ssp;
}

int main(){
  setbuf(stdout, NULL); // disable stdout buffering
  int r=yyparse();
  puts((char*)NULL);
  puts(root);
  free(root); root=NULL;
  // char *s=strdup("asdlfjk");
  return r;
}

void yyerror(char *s){
  fprintf(stderr, "%s\n", s);
}
