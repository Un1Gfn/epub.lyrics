# https://github.com/Un1Gfn/epub.lyrics

# https://www.w3.org/TR/epub-33/
# https://idpf.org/epub/20/spec/OPF_2.0_latest.htm

# https://www.w3.org/TR/epub-33/#sec-container-filenames

# 👀 ⏳ https://www.w3.org/TR/epub-33/#sec-pkg-spine
# 👀 ⏳ https://www.w3.org/TR/epub-multi-rend-11/

# wishlist (refer to packagedocuments.opf)

T:=/sdcard/Download/epub.eyyntk.d
MAKEFLAGS=-j 1

default: all

all:
	$(MAKE) clean
	$(MAKE) pack

clean:
	grm -fv 33.epub

# --failonwarnings
pack:
	epubcheck 33/ -mode exp --save -w -u

share:
	T=/tmp/33-$$(gdate +%s).epub; \
	gcp -v 33.epub $$T; \
	sudo zsh /usr/local/bin/tgbot.zsh $$T; \
	grm -v $$T

adb:
	adb push 33.epub /sdcard/Download/Telegram/33-$(shell gdate +%s).epub

view:
	open ./33-*.epub
