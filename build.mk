export LANG=C
PPA = llvm
PKGNAME = $(notdir $(PWD))

all: debclean
	cd $(DIR) && debuild -uc -us

dput:
	$(MAKE) -C ../../$(PKGNAME)
	rm -f *_source.changes
	cd $(DIR) && debuild -S  -sa
	@echo
	@echo dput ppa:h-rayflood/$(PPA) *_source.changes
	@echo

diff:
	$(MAKE) -C ../../$(PKGNAME) debian
	if test -d ../../$(PKGNAME)/debian ; then \
		echo $$(diff -urN ../../$(PKGNAME)/debian $(DIR)/debian > debian.diff) ; \
	fi

install:
	dpkg -i $$(ls *_all.deb *_`dpkg --print-architecture`.deb 2>/dev/null)

clean:
	cd $(DIR) && debuild clean

debclean:
	rm -f *.deb
	rm -f $(DEL)

distclean: clean debclean
	rm -fr $(addprefix $(DIR)/,$(filter-out . .. debian,$(shell ls -a $(DIR))))

.PHONY: all dput install extract clean debclean distclean
