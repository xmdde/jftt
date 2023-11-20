%{
#include <stdio.h>

int words = 0;
int lines = 0;
%}

WHITESPACE [[:blank:]]
%s NEWLINE
%x WORD
%x BLANKS
%%

{WHITESPACE}|\n  ;

<NEWLINE>. {
    fprintf(yyout, "\n");
    REJECT;
}

. {
    ECHO;
    words++;
    lines++;
    BEGIN(WORD);
}

<WORD>{
    [[:blank:]] BEGIN(BLANKS);
    \n BEGIN(NEWLINE);
}

<BLANKS>{
    {WHITESPACE}    ;

    \n BEGIN(NEWLINE);

    . {
        fprintf(yyout, " ");
        words++;
        ECHO;
        BEGIN(WORD);
    }
}
%%
int yywrap() {
    return 1; 
}
int main() {
    yyout = fopen("result.txt", "w");
    yylex();
    printf("words: %d lines: %d", words, lines);
    return 0;
}