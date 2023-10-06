ifeq ($(shell uname -s),Darwin)
  $(info loading homebrew compat $$PATH ...)
  include /usr/local/share/homebrew/compat.mk
endif

default:
	$(MAKE) clean
	$(MAKE) build
	$(MAKE) run

build:
	./build.zsh

run:
	{ [ xDarwin = x"$$(uname -o)" ] && lighttpd -f ./lighttpd.conf -D; } || true
	{ [ xAndroid = x"$$(uname -o)" ] && busybox httpd -f -v -p 8080 -h /sdcard/httpd; } || true

# adb.all:
# 	adb shell rm -rfv /sdcard/httpd
# 	adb push /Users/darren/bible.abloopvideo /sdcard/httpd

clean:
	rm -rfv tmp.httpd
