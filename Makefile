PREFIX=/usr/local

DIR_BIN=/sbin
DIR_MAN=/man/man1

NAME_DIST=sloth
NAME_BIN=sloth
NAME_MAN=sloth.1

VERSION=1.0.0
NAME_POD=sloth.pod
SOURCE=sloth.c

CC=gcc
CC_OPTIONS=-Wall -O



make: clean make-bin

install: make install-bin install-man

remove: remove-bin remove-man

clean: clean-bin

dist: distclean make-doc
	mkdir $(NAME_DIST)-$(VERSION)
	cp $(SOURCE) $(NAME_MAN) README INSTALL COPYING Makefile $(NAME_DIST)-$(VERSION)/
	tar -cvf $(NAME_DIST)-$(VERSION).tar $(NAME_DIST)-$(VERSION)/
	gzip $(NAME_DIST)-$(VERSION).tar

distclean:
	rm -rf $(NAME_DIST)-$(VERSION)*

make-bin:
	$(CC) $(SOURCE) -o $(NAME_BIN) $(CC_OPTIONS)

make-man:
	pod2man $(NAME_POD) > $(NAME_MAN)
	./parseman.pl $(NAME_MAN)

make-doc: make-man
	pod2text $(NAME_POD) > README

install-bin:
	cp $(NAME_BIN) $(PREFIX)$(DIR_BIN)/$(NAME_BIN)

install-man:
	cp $(NAME_MAN) $(PREFIX)$(DIR_MAN)/$(NAME_MAN)

remove-bin:
	rm $(NAME_BIN) $(PREFIX)$(DIR_BIN)/$(NAME_BIN)

remove-man:
	rm $(NAME_MAN) $(PREFIX)$(DIR_MAN)/$(NAME_MAN)

clean-bin:
	rm $(NAME_BIN)
