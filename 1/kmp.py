import sys

def compute_lps(pattern):
    """
    Computes Longest Prefix Suffix array (lps) for given pattern. 
    """
    pattern_len = len(pattern)
    lps = [0] * pattern_len
    k = 0

    for q in range(1, pattern_len):
        while k > 0 and pattern[k] != pattern[q]:
            k = lps[k - 1]
        if pattern[k] == pattern[q]:
            k += 1
        lps[q] = k
    return lps

def kmp_search(text, pattern):
    """
    Returns an array of indexes where the pattern was found using KMP algorithm.
    """
    n = len(text)
    m = len(pattern)
    lps = compute_lps(pattern)
    q = 0
    indexes = []

    for i in range(n):
        while q > 0 and pattern[q] != text[i]:
            q = lps[q - 1]
        if pattern[q] == text[i]:
            q += 1
        if q == m:
            indexes.append(i - m + 1)
            q = lps[q - 1]
    return indexes

pattern = sys.argv[1]
with open(sys.argv[2]) as file:
        text = file.read()
result = kmp_search(text, pattern)
print(result)
