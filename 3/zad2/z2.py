import ply.yacc as yacc
import ply.lex as lex
from sys import stdin
from lex import *
from GF import *

def print_(*x) -> None:
    print(*x, end='')


lex.lex()

precedence = (
    ('left', 'ADD', 'SUB'),
    ('left', 'MUL', 'DIV'),
    ('right', 'NEG'),
    ('nonassoc', 'POW')
)


def p_STAR_EXPR(p):
    'STAR : EXPR'
    print()
    print('Wynik: ', p[1])

def p_STAR_COM(p):
    'STAR : COM'
    pass


def p_NUMR(p):
    'NUMR : NUM'
    p[0] = gf_format(p[1])
    print_(p[0], '')


def p_EXPR_NEG(p):
    'EXPR : SUB EXPR %prec NEG'
    print_("~", '')
    p[0] = gf_format(0 - gf_format(p[2]))

def p_EXPR_ADD(p):
    'EXPR : EXPR ADD EXPR'
    p[0] = gf_format(gf_format(p[1]) + gf_format(p[3]))
    print_('+ ')

def p_EXPR_SUB(p):
    'EXPR : EXPR SUB EXPR'
    p[0] = gf_format(gf_format(p[1]) - gf_format(p[3]))
    print_('- ')

def p_EXPR_MUL(p):
    'EXPR : EXPR MUL EXPR'
    p[0] = multiply(p[1], p[3])
    print_('* ')

def p_EXPR_DIV(p):
    'EXPR : EXPR DIV EXPR'
    x = p[1]
    y = p[3]
    if y == 0:
        print_('/ ')
        print_('\nBłąd: dzielenie przez 0')
        return
    p[0] = gf_format(multiply(x, inverse(y)))
    print_('/ ')

def p_EXPR_POW(p):
    'EXPR : EXPR POW EXPO'
    x = p[1]
    y = p[3]
    output = 1
    if y is None :
        return
    for i in range(0, y):
        output *= x
        output = gf_format(output)
    p[0] = output
    print_('^ ')


def p_EXPR_PRS(p):
    'EXPR : LPR EXPR RPR'
    p[0] = p[2]


def p_EXPR_NUM(p):
    'EXPR : NUMR'
    p[0] = p[1]


def p_EXPONUMR(p):
    'EXPONUMR : NUM'
    p[0] = gf_format_exp(p[1])
    print_(p[0], '')


def p_EXPO_NEG(p):
    'EXPO : SUB EXPO %prec NEG'
    p[0] = gf_format_exp(0 - gf_format_exp(p[2]))
    print_("~", '')

def p_EXPO_ADD(p):
    'EXPO : EXPO ADD EXPO'
    p[0] = gf_format_exp(gf_format_exp(p[1]) + gf_format_exp(p[3]))
    print_('+ ')

def p_EXPO_SUB(p):
    'EXPO : EXPO SUB EXPO'
    p[0] = gf_format_exp(gf_format_exp(p[1]) - gf_format_exp(p[3]))
    print_('- ')

def p_EXPO_MUL(p):
    'EXPO : EXPO MUL EXPO'
    p[0] = multiply_exp(p[1], p[3])
    print_('* ')

def p_EXPO_DIV(p):
    'EXPO : EXPO DIV EXPO'
    x = p[1]
    y = p[3]
    if y == 0:
        print_('/ ')
        print_('\nBłąd: dzielenie przez 0')
        return
    r = inverse(y, P-1)
    if r is None :
        print_(f'\nBłąd: element nieodwracalny ({y})')
        return
    p[0] = gf_format_exp(multiply_exp(x, inverse(y, P-1)))
    print_('/ ')


def p_EXPO_PRS(p):
    'EXPO : LPR EXPO RPR'
    p[0] = p[2]

def p_EXPO_NUM(p):
    'EXPO : EXPONUMR'
    p[0] = p[1]


def p_error(p):
    print(f'\nBłąd: zła składnia')


yacc.yacc()

acc = ''
for line in stdin:
    if line[-2] == '\\':
        acc += line[:-2]
    elif acc != '':
        acc += line
        yacc.parse(acc)
        acc = ''
    else:
        yacc.parse(line)