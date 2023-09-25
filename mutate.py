#!/opt/homebrew/bin/python3 -u

# [%] verbatim line
# [\] force syllable break

# 받침 발음 변화
# https://en.wikipedia.org/wiki/Korean_language_and_computers#Hangul_syllables_block
# https://ja.wikipedia.org/wiki/パッチムの発音変化一覧

import sys
import string

# BOOK_1_UNIT_00_PAGE_44
BATCHIM_K = (1, 24, 2)
BATCHIM_T = (7, 25, 19, 20, 22, 23, 27)
BATCHIM_P = (17, 26)
BATCHIM_KX = BATCHIM_K + (3,)
BATCHIM_TX = BATCHIM_T
BATCHIM_PX = BATCHIM_K + (18,)
FH2F = {
     6: 4, # ㄶ ㄴ
    15: 8, # ㅀ ㄹ
    27: 0, # ㅎ
}

class Jamos:
    pass

def h2j(h):
    j = Jamos()
    j.f = ord(h) - 44032
    j.i = j.f // 588 # initial consonant
    j.f %= 588
    j.m = j.f // 28 # medial vowel
    j.f %= 28 # final consonant
    return j

def j2h(j):
    return chr(j.i * 588 + j.m * 28 + j.f + 44032)

def ruleset_mono(h):
    j = h2j(h)
    # BOOK_1_UNIT_02_PAGE_089
    if j.i in (0, 17, 18) and j.m == 7:
        j.m = 5
    return j2h(j)

# /Users/darren/tex/20230605.dfi48n/20230606.tex
def ruleset_duo(hx, hy):

    jx, jy = h2j(hx), h2j(hy)

    # BOOK_1_UNIT_05_PAGE_150 # execute before BOOK_1_UNIT_03_PAGE_109
    if (jx.f, jy.i, jy.m, jy.f) in [(17, 11, 17, 0), (17, 11, 17, 1)]:
        jx.f, jy.i = 16, 2
    if jx.f in BATCHIM_P and jy.i in (0, 9):
        jy.i += 1

    # BOOK_1_UNIT_11_PAGE_284 # execute before BOOK_1_UNIT_06_PAGE_172
    # BOOK_1_UNIT_11_PAGE_284 # execute before BOOK_1_UNIT_10_PAGE_263
    i2ih = {
         0: 15, # ㅋ
         3: 16, # ㅌ
        12: 14, # ㅊ
    }
    if jx.f in FH2F.keys() and jy.i in i2ih.keys():
        jx.f, jy.i = FH2F[jx.f], i2ih[jy.i]
    if jy.i == 18:
        if jx.f in BATCHIM_KX: jx.f, jy.i = 0, 15 # ㅋ
        if jx.f in BATCHIM_TX: jx.f, jy.i = 0, 16 # ㅌ
        if jx.f in BATCHIM_PX: jx.f, jy.i = 0, 17 # ㅍ

    # BOOK_1_UNIT_06_PAGE_172 # execute before BOOK_1_UNIT_03_PAGE_109
    if jx.f in FH2F.keys() and jy.i == 11:
        jx.f = FH2F[jx.f]

    # BOOK_1_UNIT_03_PAGE_109 # execute before BOOK_1_UNIT_10_PAGE_263
    f2i = { # F0: (F, I)
         1: ( 0,  0), # ㄱ
         2: ( 0,  1), # ㄲ
         3: ( 1,  9), # ㄳ ㄱ ㅅ
         4: ( 0,  2), # ㄴ
         5: ( 4, 12), # ㄵ ㄴ ㅈ
        # 6 # ㄶ
         7: ( 0,  3), # ㄷ
         8: ( 0,  5), # ㄹ
         9: ( 8,  0), # ㄺ ㄹ ㄱ
        10: ( 8,  6), # ㄻ ㄹ ㅁ
        11: ( 8,  7), # ㄼ ㄹ ㅂ
        12: ( 8,  9), # ㄽ ㄹ ㅅ
        13: ( 8, 16), # ㄾ ㄹ ㅌ
        14: ( 8, 17), # ㄿ ㄹ ㅍ
        # 15 # ㅀ
        16: ( 0,  6), # ㅁ
        17: ( 0,  7), # ㅂ
        18: (17,  9), # ㅄ ㅂ ㅅ
        19: ( 0,  9), # ㅅ
        20: ( 0, 10), # ㅆ
        # 21 # ㅇ
        22: ( 0, 12), # ㅈ
        23: ( 0, 14), # ㅊ
        24: ( 0, 15), # ㅋ
        25: ( 0, 16), # ㅌ
        26: ( 0, 17), # ㅍ
        # 27 # ㅎ
    }
    if jx.f in f2i.keys() and jy.i == 11:
        jx.f, jy.i = f2i[jx.f]

    # BOOK_1_UNIT_04_PAGE_129
    # BOOK_1_UNIT_10_PAGE_263
    if jx.f in BATCHIM_K+BATCHIM_T+BATCHIM_P and jy.i in (0, 3, 7, 9, 12):
        jy.i += 1

    # BOOK_1_UNIT_07_PAGE_193
    if jx.f in BATCHIM_P and jy.i in (2, 6):
        jx.f = 16

    return j2h(jx), j2h(jy)

def emit(h, hh):
    if h == hh:
        return h
    else:
        return "{%s/%s}" % (h, hh)

# emit.counter = 0

def mutate(filename):

    r = ""
    uPrev = ""
    uPrevM = ""
    sNonHangul = ""
    Nonpronounceable = str1 = ''.join(x for x in string.punctuation if x not in ("%", "\\")) + ' ' + '、，。・”’'
    file = open(filename, "r")

    # N = 0
    # def v():
    #     print([uPrev, uPrevM, sNonHangul, uCur])


    while True:

        uCur = file.read(1)

        # print("%d." % N, end='')
        # N += 1
        # if N > 110:
        #     v()
        #     breakpoint()
        # pass

        if not uCur: # CaseEOF
            r += emit(uPrev, uPrevM)
            r += sNonHangul
            break
        elif 0*588+0*28+0+44032 <= ord(uCur) <= 18*588+20*28+27+44032: # CaseHangul
            if uPrev:
                uPrevMM, uCurM = ruleset_duo(uPrevM, ruleset_mono(uCur))
                r += emit(uPrev, uPrevMM)
                r += sNonHangul
                sNonHangul ,uPrev, uPrevM = "", uCur, uCurM
            else: # CaseBOFC at beginning of file or after cut
                r += sNonHangul
                sNonHangul, uPrev, uPrevM = "", uCur, uCur
        else: # CaseNonhangul
            if uCur in Nonpronounceable: # NonpronounceableNocut
                sNonHangul += uCur
                pass
            else: # PronounceableCut
                if uCur != "\\":
                    sNonHangul += uCur
                # G1WIX9CT calc.l
                # G1WIX9CT mutate.py
                if uCur == "%":
                    while True:
                        uCur = file.read(1)
                        sNonHangul += uCur
                        if uCur == "\n":
                            break
                r += emit(uPrev, uPrevM)
                r += sNonHangul
                sNonHangul, uPrev, uPrevM = "", "", ""

    file.close()
    return r

# if uCur:
#     j = h2j(uCur)
#     print("[%s|%d.%d.%d]\n" % (uCur, j.i, j.m, j.f), end='')
# else:
#     break
