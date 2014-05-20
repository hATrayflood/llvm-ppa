PPA = llvm

all: debclean
	cd $(DIR) && debuild -uc -us

dput:
	rm -f *_source.changes
	cd $(DIR) && debuild -S  -sa
	@echo
	@echo dput ppa:h-rayflood/$(PPA) *_source.changes
	@echo

diff:
	if test -d ../../$(DIR)/debian ; then \
		echo $$(diff -urN ../../$(DIR)/debian $(DIR)/debian > debian.diff) ; \
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
