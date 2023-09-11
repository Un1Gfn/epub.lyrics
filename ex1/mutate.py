#!/opt/homebrew/bin/python3 -u
#!/opt/homebrew/bin/python3

# 받침 발음 변화
# https://en.wikipedia.org/wiki/Korean_language_and_computers#Hangul_syllables_block
# https://ja.wikipedia.org/wiki/パッチムの発音変化一覧

import sys
import string

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

def mutate1(h):
    j = h2j(h)
    if j.m == 7 and j.i in [ 0, 17, 18, ]: # b01u02p089
        j.m = 5
    return j2h(j)

def mutate2(h1, h2):
    # b01u03p109
    l = [ # (  F,  I, ),
        (  1,  0, ), # ㄱ
        (  2,  1, ), # ㄲ
        (  4,  2, ), # ㄴ
        (  7,  3, ), # ㄷ
        (  8,  5, ), # ㄹ

        ( 16,  6, ), # ㅁ
        ( 17,  7, ), # ㅂ

        ( 19,  9, ), # ㅅ
        ( 20, 10, ), # ㅆ
        ( 21, 11, ), # ㅇ
        ( 22, 12, ), # ㅈ

        ( 23, 14, ), # ㅊ
        ( 24, 15, ), # ㅋ
        ( 25, 16, ), # ㅌ
        ( 26, 17, ), # ㅍ
        ( 27, 18, ), # ㅎ
    ]
    j1, j2 = h2j(h1), h2j(h2)
    if j2.i == 11:
        for (f,i) in l:
            if f == j1.f:
                j1.f, j2.i = 0, i
    return j2h(j1), j2h(j2)

def emit(h, hh):
    if h:
        if h == hh:
            print(h, end='')
        else:
            print("{%s/%s}" % (h, hh), end='')
    else:
        assert not hh

# emit.counter = 0

def main():
    uPrev = None
    uPrevM = None
    sNonHangul = ""
    Nonpronounceable = string.punctuation + ' ' + '、，。・”’'
    def v():
        print([uPrev, uPrevM, sNonHangul, uCur])
    N = 0
    file = open("in.txt", "r")
    while True:

        uCur = file.read(1)

        # print("%d." % N, end='')
        # N += 1
        # if N > 110:
        #     v()
        #     breakpoint()
        # pass

        if not uCur: # CaseEOF
            emit(uPrev, uPrevM)
            print(sNonHangul)
            break
        elif 0*588+0*28+0+44032 <= ord(uCur) <= 18*588+20*28+27+44032: # CaseHangul
            if uPrev:
                uPrevMM, uCurM = mutate2(uPrevM, mutate1(uCur))
                emit(uPrev, uPrevMM)
                print(sNonHangul, end='')
                sNonHangul ,uPrev, uPrevM = "", uCur, uCurM
            else: # CaseBOFC at beginning of file or after cut
                print(sNonHangul, end='')
                sNonHangul, uPrev, uPrevM = "", uCur, uCur
        else: # CaseNonhangul
            if uCur in Nonpronounceable: # CaseNonhangulNonpronounceableNocut
                sNonHangul += uCur
                pass
            else: # CaseNonhangulPronounceableCut
                sNonHangul += uCur
                emit(uPrev, uPrevM)
                print(sNonHangul, end='')
                sNonHangul, uPrev, uPrevM = "", None, None
    file.close()

if __name__ == "__main__":
    main()

# if uCur:
#     j = h2j(uCur)
#     print("[%s|%d.%d.%d]\n" % (uCur, j.i, j.m, j.f), end='')
# else:
#     break
