#!/usr/bin/python3

import wsgiref.simple_server
import multipart
import pathlib
# import pprint
import io
import hashlib
import ruamel.yaml
import subprocess
import os
import atexit
import shutil
import zipfile
import ctypes
import mutate

# gshuf -n 1 -i 2000000000-2999999999
D = {
    2553463205: "뱀파이어",
}

# B="""\
# x
# x(m(p))b
# x{a/b}c
# x{a/b}c(d)
# x{a/b}c(e{f/g}h)
# (a)({c/d}e)f
# {x/y}alyyjf{mx92jdf/MMM}xksdkfj(93j)sdf

# xxx
# x({먹/머}a{어/거})
# c(hahaha){kkkkk/s}

# xxx
# x({먹/머}b{어/거})
# c(hahaha){kkkkk/s}

# """

HTML = """\
<!DOCTYPE html>
<html lang=ko-KR>
    <head>
        <meta charset="utf-8"/>
        <!-- https://www.w3schools.com/css/css_rwd_viewport.asp -->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            * {
                font-family: sans-serif;
            }
        </style>
    </head>
    <body>\n%s    </body>
</html>
"""

class ClashLog:

    l = str()

class ClashMain:

    address = None
    port = None

    start_response = None
    environ = None

    calc = None

    def __init__(self):
        self.adapt_os()
        self.calc = ctypes.CDLL("calc/calc.dylib").calc
        self.calc.restype = ctypes.c_char_p
        # print(f"@{self.calc(B.encode()).decode()}@")
        print(f"http://{self.address}:{self.port}/")
        wsgiref.simple_server.make_server(self.address, self.port, self.simple_app).serve_forever()

    def adapt_os(self):
        u = os.uname()
        if 'android' in u.release.casefold():
            assert u.sysname == "Linux"
            ClashMain.address = '127.0.0.1'
            ClashMain.port = 8080
            # ClashPersistent.d = pathlib.Path("/CLASH")
            # ClashProcess.b = "/usr/bin/clash"
        else:
            assert u.sysname == 'Darwin'
            ClashMain.address = '127.0.0.1'
            ClashMain.port = 8080
            # ClashPersistent.d = pathlib.Path("/tmp/CLASH")
            # ClashProcess.b = "/opt/homebrew/bin/clash"
        print("adapted to os")
        print(u)

    def simple_app(self, environ, start_response):
        ClashLog.l = str()
        # pprint.PrettyPrinter(indent=4).pprint(environ)
        self.environ = environ
        self.start_response = start_response

        for k, v in D.items():
            if f"/{k}" == self.environ['PATH_INFO']:
                assert "GET" == self.environ['REQUEST_METHOD']
                f = f"{k}/kr.txt"
                # with open(f, "r") as ff:
                #     print(f"@{ff.read()}@@")
                m = mutate.mutate(f)
                print(f"@{m}@@")
                b = self.calc(m.encode()).decode()
                # print(f"@{b}@@")
                return self.gen_page("text/html", HTML % b)

            #     case _:
            #         for i
            #         mutate.mutate(D[0][0])
            #         return self.gen_page("text/html", HTML % self.calc(B.encode()).decode())
            # print(ClashLog.l)

        return self.gen_page("text/plain; charset=utf-8", ClashLog.l)

    def gen_page(self, t, s):
        self.start_response('200 OK', [
            ('Content-Type', t),
            ('Content-Length', str(len(s.encode()))),
        ])
        return [s.encode()]

if __name__ == "__main__":
    ClashMain()
