ifeq ($(shell uname -s),Darwin)
  $(info loading homebrew compat $$PATH ...)
  include /usr/local/share/homebrew/compat.mk
endif

MAKEFLAGS:=-j1

# gmake all run
# gmake all adb

default:
	true

all:
	$(MAKE) clean
	$(MAKE) -C calc
	$(MAKE) build

build:
	./build.zsh

run:
	{ [ xDarwin = x"$$(uname -o)" ] && lighttpd -tt -f ./lighttpd.conf && lighttpd -f ./lighttpd.conf -D; } || true
	{ [ xAndroid = x"$$(uname -o)" ] && busybox httpd -f -v -p 8080 -h .; } || true

adb:
	adb shell rm -rfv /sdcard/httpd.ouLoboRoC
	adb push tmp.httpd /sdcard/httpd.ouLoboRoC

clean:
	rm -rfv tmp.httpd

cert:
	openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 3650 -nodes -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=localhost"
