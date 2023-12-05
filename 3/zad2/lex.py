tokens = (
    'ADD', 'SUB', 'MUL', 'DIV', 'POW',
    'LPR', 'RPR',
    'NUM',
    'COM'
)

t_COM = r'\#.*'
t_ADD = r'\+'
t_MUL = r'\*'
t_DIV = r'\/'
t_POW = r'\^'
t_LPR = r'\('
t_RPR = r'\)'
t_SUB = r'-'

def t_NUM(t):
    r'[0-9]+'
    t.value = int(t.value)
    return t

t_ignore = ' \t'

def t_newline(t):
    r'\n+'
    t.lexer.lineno += t.value.count('\n')

def t_error(t):
    print(f'\nBłąd: niepoprawny znak - {t.value[0]!r}')
    t.lexer.skip(1)