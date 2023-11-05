%{
#include <stdio.h>
%}

com_begin \<!--
com_end --\>
string \".*\"

%x NO_COMMENT
%x COMMENT

%%

\<!--.*--.*--\>   ECHO;
\<!--.*---\>      ECHO;

\< {
    ECHO;
    BEGIN(NO_COMMENT);
}

{com_begin} BEGIN(COMMENT);

<NO_COMMENT>{
    {string} ECHO;
    > {
        ECHO;
        BEGIN(INITIAL);
    }
    .|\n     ECHO;
}

<COMMENT>{
    .|\n       ;
    {com_end}  BEGIN(INITIAL);
}

%%
int yywrap() {
    return 1; 
}
int main(int argc, char** argv) {
    yyout = fopen("result.xml", "w");
    yylex();
    return 0;
}