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

ex: tk_plain {
  $$=$1;
  DEBUGWRAPPER(printf("| .N | %s\n", $$));
  root=$$;
};

ex: '(' ex ')' {
  asprintf(&($$), "<span class=\"x1p8df\">%s</span>", $2);
  free($2); $2=NULL;
  DEBUGWRAPPER(printf("| .S | %s\n", $$));
  root=$$;
};

ex: '{' ex '/' ex '}' {
  asprintf(&($$), "<ruby>%s<rt>%s</rt></ruby>", $2, $4);
  free($2); $2=NULL;
  free($4); $4=NULL;
  DEBUGWRAPPER(printf("| .B | %s\n", $$));
  root=$$;
};

ex: ex tk_plain {
  asprintf(&($$), "%s%s", $1, $2);
  free($1); $1=NULL;
  free($2); $2=NULL;
  DEBUGWRAPPER(printf("| +N | %s\n", $$));
  root=$$;
};

ex: ex '(' ex ')' {
  asprintf(&($$), "%s<span class=\"x1p8df\">%s</span>", $1, $3);
  free($1); $1=NULL;
  free($3); $3=NULL;
  DEBUGWRAPPER(printf("| +S | %s\n", $$));
  root=$$;
};

ex: ex '{' ex '/' ex '}' {
  asprintf(&($$), "%s<ruby>%s<rt>%s</rt></ruby>", $1, $3, $5);
  free($1); $1=NULL;
  free($3); $3=NULL;
  free($5); $5=NULL;
  DEBUGWRAPPER(printf("| +B | %s\n", $$));
  root=$$;
};

ex: ex tk_par ex {
  asprintf(&($$), "%s</p> <p>%s\n", $1, $3);
  free($1); $1=NULL;
  free($3); $3=NULL;
  DEBUGWRAPPER(printf("| +P | %s\n", $$));
  root=$$;
};

%%

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
