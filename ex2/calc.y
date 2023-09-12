%{

  #include <assert.h>
  #include <ctype.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <stdint.h>
  #include <time.h>
  #include <stdbool.h>

  void yyerror(char *s);
  int yylex();
  // char *fin=NULL;

  // #define M_CAT(pS0,SA) {
  //   char *t=NULL;
  //   asprintf(&(t), "%s%s", *(pS0), SA);
  //   *(pS0)=t;
  // }

  uint8_t random2();
  bool dup[UINT8_MAX+1] = {};

%}

%union {
  uint8_t u_i;
  char *u_s;
  char **u_ps;
}

%start ex

%token <u_s> plain

%type <u_i> ex

%%

/* <span class=\"x1p8df\">%s</span> */
/* "<ruby>%s<rt>%s</rt></ruby>" */
/* asprintf(&(...), "...", ...) */

/* N plain */
/* S span  */
/* B ruby  */

/*  $1    $2  $3    $4 $5  $6 $7 */
ex: plain                           {{printf("%3d |  N | ",__LINE__); uint8_t t=random2(); printf(" %3u _ %3u " ,t ,$$ ); printf("_"); printf( " '%s'        " ,$1                     ); $$=t; puts("");};} ;
  | '('   ex  ')'                   {{printf("%3d |  S | ",__LINE__); uint8_t t=random2(); printf(" %3u _ %3u " ,t ,$$ ); printf("_"); printf( " %3u         "     ,$2                 ); $$=t; puts("");};} ;
  | '{'   ex  '/'   ex '}'          {{printf("%3d |  B | ",__LINE__); uint8_t t=random2(); printf(" %3u _ %3u " ,t ,$$ ); printf("_"); printf( " %3u %3u     "     ,$2     ,$4         ); $$=t; puts("");};} ;
  | ex    '+' plain                 {{printf("%3d | +N | ",__LINE__); uint8_t t=random2(); printf(" %3u _ %3u " ,t ,$$ ); printf("_"); printf( " %3u '%s'    " ,$1     ,$3             ); $$=t; puts("");};} ;
  | ex    '+' '('   ex ')'          {{printf("%3d | +S | ",__LINE__); uint8_t t=random2(); printf(" %3u _ %3u " ,t ,$$ ); printf("_"); printf( " %3u %3u     " ,$1         ,$4         ); $$=t; puts("");};} ;
  | ex    '+' '{'   ex '/' ex '}'   {{printf("%3d | +B | ",__LINE__); uint8_t t=random2(); printf(" %3u _ %3u " ,t ,$$ ); printf("_"); printf( " %3u %3u %3u " ,$1         ,$4     ,$6 ); $$=t; puts("");};} ;
/*  $1    $2  $3    $4 $5  $6 $7 */

%%

int main (void){
  /* printf("%3d | ",__LINE__); puts("R.l -> NULL ; R.r -> NULL"); */
  setbuf(stdout, NULL); // disable stdout buffering
  int ret=yyparse();
  return ret;
}

void yyerror(char *s){
  fprintf (stderr, "%s\n", s);
}

uint8_t random2(){
  typeof(yylval.u_i) t=0;
  while(dup[(t=random())]){;}
  dup[t] = true;
  return t;
}
