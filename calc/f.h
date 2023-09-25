#ifndef F_H
#define F_H

#ifdef NDEBUG
  #define DEBUGWRAPPER(X) ;
#else
  #define DEBUGWRAPPER(X) {X;}
#endif

extern char *root;

char *f_appendplain(char*, char*);
char *f_appendspan(char*, char*);
char *f_appendruby(char*, char*, char*);
char *f_appendline(char*, char*);
char *f_appendpar(char*, char*);

#endif
