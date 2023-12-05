%{
#define YYSTYPE int
#include <iostream>
#include <string>

const int P = 1234577;

extern int yylex();
extern int yyparse();
int yyerror(std::string s);

int gf_format(int a);
int gf_format_exp(int a);

int invert(int a, const int _P);
int divide(long int a, int b, const int _P);
int power(long int a, int pow);

int extended_euclid(int a, int b, int& x, int& y);

std::string error_msg = "";
std::string rpn = "";
%}

%token NUM
%token ERR
%left '+' '-'
%left '*' '/'
%precedence NEG
%nonassoc '^'

%%

input:
    %empty
    | input line
;
line: 
    expr '\n' { 
        std::cout << rpn << '\n';
        std::cout << "Wynik: " << $1 << '\n'; 
        rpn = "";
    }
    | error '\n' {
        if (error_msg == "") {
            error_msg = "zła składnia";
        }
        std::cout << "Błąd: " << error_msg << '\n'; 
        rpn = ""; 
        error_msg = "";
    }
;
expr: 
    number                  { rpn += std::to_string($1) + " "; $$ = $1; }
    | '(' expr ')'          { $$ = $2; }
    | '-' expr %prec NEG    { rpn += "~ "; $$ = gf_format(-$2); }
    | expr '+' expr         { rpn += "+ "; $$ = gf_format($1 + $3); }
    | expr '-' expr         { rpn += "- "; $$ = gf_format($1 - $3); }
    | expr '*' expr         { rpn += "* "; $$ = gf_format($1 * $3); }
    | expr '^' exponent     { rpn += "^ "; $$ = gf_format(power($1, gf_format_exp($3))); }
    | expr '/' expr         {
        rpn += "/ ";
        if ($3 == 0) {
            error_msg = "dzielenie przez 0"; 
            YYERROR; 
        } else {
            $$ = divide($1, $3, P);
        }
    }
;
exponent:
    exp_number                { rpn += std::to_string($1) + " "; $$ = $1; }
    | '(' exponent ')'        { $$ = $2; }
    | '-' exponent %prec NEG  { rpn += "~ "; $$ = ((-$2 % (P - 1)) + (P - 1)) % (P - 1); }
    | exponent '+' exponent   { rpn += "+ "; $$ = ($1 + $3) % (P - 1); }
    | exponent '-' exponent   { rpn += "- "; $$ = gf_format_exp($1 - $3); }
    | exponent '*' exponent   { rpn += "* "; $$ = ($1 * $3) % (P - 1); }
    | exponent '/' exponent   { 
        rpn += "/ ";
        if ($3 == 0) {
            error_msg = "dzielenie przez 0";
            YYERROR; 
        } else {
            int x;
            int y;
            int r = extended_euclid($3, P - 1, x, y);
            if (r > 1) {
                error_msg = "element nieodwracalny";
                YYERROR;
            } else {
                $$ = divide($1, $3, P - 1);
            }
        }
    }
;
number:
    NUM            { $$ = gf_format($1); }
;
exp_number:
    NUM            { $$ = gf_format_exp($1); }
%%

int gf_format(int a) {
    return ((a % P) + P) % P;
}

int gf_format_exp(int a) {
    return ((a % (P-1)) + (P-1)) % (P-1);
}

int divide(long int a, int b, const int _P) {
    long int inv = invert(b, _P);
    return static_cast<int>((a * inv) % _P);
}

int invert(int a, const int _P) {
    int x;
    int y;
    extended_euclid(a, _P, x, y);
    return (x%_P + _P) % _P;
}

int power(long int a, int pow) {
    if (pow == 0) {
        return 1;
    }

    long int b = power(a, pow/2);
    if (pow % 2 == 0) {
        return static_cast<int>((b * b) % P);
    } else {
        return static_cast<int>((a * b * b) % P);
    }
}

int extended_euclid(int a, int b, int& x, int& y) {
    if (a == 0) {
        x = 0;
        y = 1;
        return b;
    }

    int x1;
    int y1;
    int d = extended_euclid(b%a, a, x1, y1);
    x = y1 - (b/a) * x1;
    y = x1;
    return d;
}

int yyerror(std::string s) {	
    return 0;
}

int main() {
    yyparse();
    return 0;
}
