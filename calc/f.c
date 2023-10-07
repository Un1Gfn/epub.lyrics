#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

#define NDEBUG 1
#include "f.h"

#define INDENT "  "

char *root=NULL;

char *f_appendplain(char *s, char *sa){
  if(!sa)
    return s;
  char *r=NULL;
  asprintf(&r, "%s%s", s, sa);
  free(s);
  free(sa);
  DEBUGWRAPPER(printf("| ++ | %s\n", r));
  root=r;
  return r;
}

char *f_appendspan(char* s, char*sa){
  char *r=NULL;
  asprintf(&r, "%s<span class=\"x1p8df\">%s</span>", s?s:"", sa);
  free(s);
  free(sa);
  DEBUGWRAPPER(printf("| +S | %s\n", r));
  root=r;
  return r;
}

char *f_appendruby(char *s, char *rb, char *rt){
  char *r=NULL;
  asprintf(&r, "%s<ruby>%s<rt>%s</rt></ruby>", s?s:"", rb, rt);
  free(s);
  free(rb);
  free(rt);
  DEBUGWRAPPER(printf("| +B | %s\n", r));
  root=r;
  return r;
}

char *f_appendline(char* s, char*sa){
  char *r=NULL;
  asprintf(&r, "%s" INDENT INDENT INDENT "%s<br/>\n", s?s:"", sa);
  free(s);
  free(sa);
  DEBUGWRAPPER(printf("| +L | %s\n", r));
  root=r;
  return r;
}

char *f_appendpar(char* s, char*sa){
  char *r=NULL;
  asprintf(&r, "%s" INDENT INDENT "<p class=\"lrlef9\">\n%s" INDENT INDENT "</p>\n", s?s:"", sa);
  free(s);
  free(sa);
  DEBUGWRAPPER(printf("| +G | %s\n", r));
  root=r;
  return r;
}
