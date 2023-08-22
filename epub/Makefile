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
	$(MAKE) inspect

clean:
	grm -fv 33.epub

# --save
# --failonwarnings
# epubcheck 33/ -mode exp --save -w -u
pack:
	cd 33/; zip -0 -X -r ../33.epub mimetype packagedocument.opf META-INF/ MISC/ LRC/ RES/ AUDIO/
	@echo
	epubcheck 33.epub -w -u
	@echo

inspect:
	gls -Alh 33.epub

share:
	T=/tmp/33-$$(gdate +%s)-tgbot.epub; \
	gcp -v 33.epub $$T; \
	sudo zsh /usr/local/bin/tgbot.zsh $$T; \
	grm -v $$T

adb:
	@echo
	adb devices
	adb shell uname -a
	@echo
	adb shell sleep 1
	@echo
	adb push 33.epub /sdcard/Download/Telegram/33-$(shell gdate +%s)-adb.epub
	@echo

view:
	open ./33-*.epub
