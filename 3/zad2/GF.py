P = 1234577

def gf_format(x: int) -> int:
    return ((x % P) + P) % P

def gf_format_exp(x: int) -> int:
    return ((x % (P-1)) + (P-1)) % (P-1)


def multiply(x: int, y: int) -> int:
    output = gf_format(x)
    for i in range(1, y):
        output += x
        output = gf_format(output)
    return output

def multiply_exp(x: int, y: int) -> int:
    output = gf_format_exp(x)
    for i in range(1, y):
        output += x
        output = gf_format_exp(output)
    return output

def inverse(a: int, _P = P) -> int:
    m = _P
    x = 1
    y = 0

    while a > 1:
        try:
            quotient = a // m
        except:
            return
        t = m

        m = a % m
        a = t
        t = y

        y = x - quotient * y
        x = t

    if x < 0:
        x += _P

    return x