BASE_URL = https://launchpad.net/debian/+archive/primary/+files

all: $(ORIG_TARS)

clean:
	rm -fr $(ORIG_TARS)

debian: $(DEBIAN_TAR)
	case $< in \
	*.debian.tar.xz) \
		tar Jxf $< \
	;; \
	*.debian.tar.bz2) \
		tar jxf $< \
	;; \
	*.debian.tar.gz) \
		tar zxf $< \
	;; \
	esac
	touch $@

%.tar.xz %.tar.bz2 %.tar.gz:
	wget $(BASE_URL)/$@

debclean:
	rm -fr debian $(DEBIAN_TAR)

distclean: clean debclean
