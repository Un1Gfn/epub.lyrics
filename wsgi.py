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

HTML = """
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
    <body>
        <p>안녕하세요!</p>
    </body>
</html>
"""

class ClashLog:

    l = str()

class ClashMain:

    address = None
    port = None

    start_response = None
    environ = None

    def __init__(self):
        self.adapt_os()
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
        match self.environ['PATH_INFO']:
            # case "/somepath":
            #     assert "GET" == self.environ['REQUEST_METHOD']
            #     f()
            case _:
                return self.gen_page("text/html", HTML)
        print(ClashLog.l)
        return self.gen_page("text/plain; charset=utf-8", ClashLog.l)

    def gen_page(self, t, s):
        self.start_response('200 OK', [
            ('Content-Type', t),
            ('Content-Length', str(len(s.encode()))),
        ])
        return [s.encode()]

if __name__ == "__main__":
    ClashMain()
