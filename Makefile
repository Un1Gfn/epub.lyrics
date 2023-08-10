
# https://www.w3.org/TR/epub-33/

# https://www.w3.org/TR/epub-33/#sec-container-filenames

# 👀
# 👀 https://www.w3.org/TR/epub-33/#sec-package-doc
# 👀 .opf

default: pack

# --failonwarnings
pack:
	epubcheck 33/ -mode exp --save -w -u
	gmv -vi 33.epub 33-$(shell gdate +%s).epub

clean:
	grm -fv 33-*.epub
