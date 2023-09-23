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

  // char *fin=NULL;

  // #define M_CAT(pS0,SA) {
  //   char *t=NULL;
  //   asprintf(&(t), "%s%s", *(pS0), SA);
  //   *(pS0)=t;
  // }

  uint8_t random2();
  bool dup[UINT8_MAX+1]={};

  char *root=NULL;

%}

%union {
  uint8_t u_i;
  char *u_s;
  // char **u_ps;
}

%start ex

%token <u_s> plain

%type <u_s> ex

%%

/* <span class=\"x1p8df\">%s</span> */
/* "<ruby>%s<rt>%s</rt></ruby>" */
/* asprintf(&(...), "...", ...) */

/* N plain */
/* S span  */
/* B ruby  */

ex: plain {
  $$=strdup($1);
  DEBUGWRAPPER(printf("| .N | %s\n", $$));
  root=$$;
};

ex: '(' ex ')' {
  asprintf(&($$), "<span class=\"x1p8df\">%s</span>", $2);
  DEBUGWRAPPER(printf("| .S | %s\n", $$));
  root=$$;
};

ex: '{'   ex    '/' ex '}' {
  asprintf(&($$), "<ruby>%s<rt>%s</rt></ruby>", $2, $4);
  DEBUGWRAPPER(printf("| .B | %s\n", $$));
  root=$$;
};

ex: ex plain {
  asprintf(&($$), "%s%s", $1, $2);
  DEBUGWRAPPER(printf("| +N | %s\n", $$));
  root=$$;
};

ex: ex '(' ex ')' {
  asprintf(&($$), "%s<span class=\"x1p8df\">%s</span>", $1, $3);
  DEBUGWRAPPER(printf("| +S | %s\n", $$));
  root=$$;
};

ex: ex '{' ex '/' ex '}' {
  asprintf(&($$), "%s<ruby>%s<rt>%s</rt></ruby>", $1, $3, $5);
  DEBUGWRAPPER(printf("| +B | %s\n", $$));
  root=$$;
};

%%

int main (void){
  setbuf(stdout, NULL); // disable stdout buffering
  int r=yyparse();
  puts((char*)NULL);
  puts(root);
  // char *s=strdup("asdlfjk");
  return r;
}

void yyerror(char *s){
  fprintf(stderr, "%s\n", s);
}

uint8_t random2(){
  typeof(yylval.u_i) t=0;
  while(dup[(t=random()%16)]){;}
  dup[t] = true;
  return t;
}
