# https://github.com/Un1Gfn/epub.lyrics

# https://www.w3.org/TR/epub-33/
# https://idpf.org/epub/20/spec/OPF_2.0_latest.htm

# https://www.w3.org/TR/epub-33/#sec-container-filenames

# 👀 ⏳ https://www.w3.org/TR/epub-33/#sec-spine-elem

T:=/sdcard/Download/epub.eyyntk.d

default:
	$(MAKE) clean
	$(MAKE) pack
	$(MAKE) adb
	# $(MAKE) view

clean:
	grm -fv 33-*.epub

# --failonwarnings
pack:
	epubcheck 33/ -mode exp --save -w -u
	gmv -vi 33.epub 33-$(shell gdate +%s).epub

adb:
	adb shell 'mkdir -v $(T); rm -fv $(T)/*'
	adb push 33-* /sdcard/Download/epub.eyyntk.d/

view:
	open ./33-*.epub