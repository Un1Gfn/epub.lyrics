#!/usr/bin/python3

import wsgiref.simple_server
import os
import ctypes
# import mutate
import base64

# gshuf -n 1 -i 2000000000-2999999999
D = {
    2553463205: "뱀파이어",
}

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
            audio {
                width: 100%%;
            }
        </style>
    </head>
    <body>
        <audio controls preload src="%s" type="audio/m4a"></audio>\n%s    </body>
</html>
"""

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
        # pprint.PrettyPrinter(indent=4).pprint(environ)
        self.environ = environ
        self.start_response = start_response

        for k, v in D.items():

            if f"/{k}" == self.environ['PATH_INFO']:
                assert "GET" == self.environ['REQUEST_METHOD']
                f = f"{k}/lrc.txt"
                # m = mutate.mutate(f)
                with open(f, "r") as ff:
                    m = ff.read()
                print(f"@{m}@@")
                s_lrc = self.calc(m.encode()).decode()
                # print(f"@{s_lrc}@@")
                # with open(f"{k}/track.m4a", "rb") as ff:
                #     s_b64 = base64.b64encode(ff.read()).decode()
                # print(s_b64)
                return self.gen_page("text/html", (HTML % (f"/{k}/track.m4a", s_lrc)).encode())

            if f"/{k}/track.m4a" == self.environ['PATH_INFO']:
                with open(f"{k}/track.m4a", "rb") as ff:
                    b = ff.read()
                return self.gen_page("audio/m4a", b)

        return self.gen_page("text/plain; charset=utf-8", "t2cp7u".encode())

    def gen_page(self, t, bs):
        self.start_response('200 OK', [
            ('Content-Type', t),
            ('Content-Length', str(len(bs))),
        ])
        return [bs]

if __name__ == "__main__":
    ClashMain()
