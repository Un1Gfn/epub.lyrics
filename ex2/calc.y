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
  void f_appendline(char**, char*, char*);
  void f_appendpar(char**, char*, char*){}

  char *root=NULL;

%}

%union {
  uint8_t u_i;
  char *u_s;
}

%start pars

%token <u_s> tk_plain

%token tk_parsep

%type <u_s> exps
%type <u_s> lines
%type <u_s> pars

%%

/* <span class=\"x1p8df\">%s</span> */
/* "<ruby>%s<rt>%s</rt></ruby>" */
/* asprintf(&(...), "...", ...) */

/* N tk_plain */
/* S span  */
/* B ruby  */

exp: tk_plain {f_plain(&($$), $1);};

exps: tk_plain {f_plain(&($$), $1);};

exps: '(' exps ')' {f_appendspan(&($$), strdup(""), $2);};

exps: '{' exps '/' exps '}' {f_appendruby(&($$), strdup(""), $2, $4);};

exps: exps tk_plain {
  asprintf(&($$), "%s%s", $1, $2);
  free($1); $1=NULL;
  free($2); $2=NULL;
  DEBUGWRAPPER(printf("| +N | %s\n", $$));
  root=$$;
};

exps: exps '(' exps ')' {f_appendspan(&($$), $1, $3);};

exps: exps '{' exps '/' exps '}' {f_appendruby(&($$), $1, $3, $5);};

lines: exps '\n' {f_appendline(&($$), $1, NULL);};

lines: lines exps '\n' {f_appendline(&($$), $1, $2);};

pars: lines tk_parsep {f_appendpar(&($$), $1, NULL);};

pars: pars lines tk_parsep {f_appendpar(&($$), $1, $2);};

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

void f_appendline(char **ssp, char* s, char*sa){
  if(sa){
    asprintf(ssp, "%s\t%s<br/>\n", s, sa);
    free(s);
    free(sa);
    DEBUGWRAPPER(printf("| +L | %s\n", *ssp));
  }else{
    asprintf(ssp, "\t%s<br/>\n", s);
    free(s);
    DEBUGWRAPPER(printf("| .L | %s\n", *ssp));
  }
  root=*ssp;
}

int main(){
  setbuf(stdout, NULL); // disable stdout buffering
  int r=yyparse();
  puts("");
  puts("");
  puts((char*)NULL);
  puts(root);
  free(root); root=NULL;
  // char *s=strdup("asdlfjk");
  return r;
}

void yyerror(char *s){
  fprintf(stderr, "%s\n", s);
}
