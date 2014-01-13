all: debclean
	cd $(DIR) && debuild -uc -us

dput:
	cd $(DIR) && debuild -S  -sa
	@echo dput ppa:h-rayflood/llvm *_source.changes

diff:
	if test -d debian ; then \
		echo $$(diff -urN debian $(DIR)/debian > debian.diff) ; \
	fi

install:
	dpkg -i $$(ls *_all.deb *_`dpkg --print-architecture`.deb 2>/dev/null)

clean:
	cd $(DIR) && debuild clean

debclean:
	rm -f  *.deb
	rm -f  $(DEL)

distclean: clean debclean
	rm -fr $(addprefix $(DIR)/,$(filter-out . .. debian,$(shell ls -a $(DIR))))

.PHONY: all dput install extract clean debclean distclean
