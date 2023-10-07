import sys

def compute_transition_function(pattern, alphabet):
    m = len(pattern)
    delta = {(q, a): 0 for q in range(m + 1) for a in alphabet}
    
    for q in range(m + 1):
        for a in alphabet:
            k = min([m, q + 1])
            while k > 0 and pattern[:k] != (pattern[:q] + a)[-k:]:
                k -= 1
            delta[q, a] = k
    return delta

def fa_search(text, delta, m):
    n = len(text)
    q = 0
    indexes = []

    for i in range(n):
        q = delta[q, text[i]]
        if q == m:
            indexes.append(i - m + 1)
    return indexes

pattern = sys.argv[1]
with open(sys.argv[2]) as file:
    text = file.read()

alphabet = {a for a in text}
delta = compute_transition_function(pattern, alphabet)
result = fa_search(text, delta, len(pattern))
print(result)
