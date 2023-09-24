#!/usr/bin/env python3

import ctypes

B="""\
x
x(m(p))b
x{a/b}c
x{a/b}c(d)
x{a/b}c(e{f/g}h)
(a)({c/d}e)f
{x/y}alyyjf{mx92jdf/MMM}xksdkfj(93j)sdf

xxx
x({먹/머}a{어/거})
c(hahaha){kkkkk/s}

xxx
x({먹/머}b{어/거})
c(hahaha){kkkkk/s}

"""


def main():
    calc = ctypes.CDLL("calc.dylib").calc
    calc.restype = ctypes.c_char_p
    print(f"@{calc(B.encode()).decode()}@")

if __name__ == "__main__":
    main()
