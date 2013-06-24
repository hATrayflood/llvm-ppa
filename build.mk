all:
	cd $(DIR) && debuild -uc -us

dput:
	cd $(DIR) && debuild -S  -sa
	../diff-wrapper -urN debian $(DIR)/debian > debian.diff
	echo dput ppa:h-rayflood/llvm *_source.changes

install:
	dpkg -i *_all.deb *_`dpkg --print-architecture`.deb

clean:
	cd $(DIR) && debuild clean

distclean: clean
	for F in `ls $(DIR)` ; do \
		if [ "$$F" != "debian" ] ; then \
			rm -fr $(DIR)/$$F ; \
		fi ; \
	done
	rm -fr $(DIR)/.pc
	rm -f  *.deb
	rm -f  $(DEL)

.PHONY: all dput install extract clean distclean
