%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include "z1y.hpp"

const int P = 1234577;
extern int yylex();
%}

%%
[ \t]         ;
^#(.|\\\n)*\n ;
\\\n          ;
[[:digit:]]+  { 
    yylval = atoi(yytext);
    return NUM; 
}
"("  { return '('; }
")"  { return ')'; }
"+"  { return '+'; }
"-"  { return '-'; }
"*"  { return '*'; }
"/"  { return '/'; }
"^"  { return '^'; }
\n   { return '\n'; }
.    { return ERR; }
%%