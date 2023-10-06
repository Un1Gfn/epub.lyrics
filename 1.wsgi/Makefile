
ifeq ($(shell uname -s),Darwin)
  $(info loading homebrew compat $$PATH ...)
  include /usr/local/share/make/compat.mk
endif

MAKEFLAGS:=-j1 --no-print-directory

default:
	$(MAKE) -C calc
	python3 ./wsgi.py
