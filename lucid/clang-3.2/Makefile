DIR = clang-3.2
DEL = clang-3.2_3.2-*

include ../../build.mk

extract:
	$(MAKE) -C ../../$(PKGNAME)
	tar jxf clang-3.2_3.2.orig.tar.bz2
	tar jxf clang-3.2_3.2.orig-compiler-rt.tar.bz2
	rm -fr $(DIR)/compiler-rt
	mv compiler-rt-3.2.src $(DIR)/compiler-rt
