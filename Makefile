
# https://www.w3.org/TR/epub-33/

# epubcheck ./ -mode exp --save --failonwarnings -w -u
# epubcheck ./ -mode exp --save -w -u

default:
	epubcheck 33/ -mode exp --save
