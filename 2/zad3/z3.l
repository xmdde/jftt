%{
#include <stdio.h>
#include <iostream>
#include <cstring>

bool leave_doc = false;
%}

include #include.*(\"|>)\n?

continue_line \\\n

singleline [[:blank:]]*\/{continue_line}?\/{continue_line}?.*{continue_line}?.*\n
multiline_begin \/{continue_line}?\*
multiline_end \*{continue_line}?\/{continue_line}?\n?

doc_singleline [[:blank:]]*\/{continue_line}?\/{continue_line}?(\/|!){continue_line}?.*\n
doc_multiline_begin \/{continue_line}?\*{continue_line}?(\*|!){continue_line}?

%x IN_MULTILINE
%x IN_STRING
%%

{include} { ECHO; }

\" { 
    ECHO;
    BEGIN(IN_STRING);
}

{doc_singleline} {
    if (leave_doc)
        ECHO;
}

{singleline}     ;

{multiline_begin} {
    BEGIN(IN_MULTILINE);
}

{doc_multiline_begin} {
    if (leave_doc) {
        ECHO;
    } else {
        BEGIN(IN_MULTILINE);
    }
}

<IN_MULTILINE>{
    .|\n            ;
    {multiline_end} { BEGIN(INITIAL); }
}

<IN_STRING>{
    \" {
        ECHO;
        BEGIN(INITIAL);
    }
    .|\n ECHO;
}

%%
int yywrap() {
    return 1; 
}
int main(int argc, char** argv) {
    yyout = fopen("result.cpp", "w");
    if (argc > 1 && strcmp(argv[1], "-d") == 0) {
        leave_doc = true;
    }
    yylex();
    return 0;
}