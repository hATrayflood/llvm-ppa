DIR = clang-3.2
DEL = clang-3.2_3.2-*

include ../build.mk

PPA = buildtest

extract:
	tar jxf clang-3.2_3.2.orig.tar.bz2
	tar jxf clang-3.2_3.2.orig-compiler-rt.tar.bz2
	mv compiler-rt-3.2.src $(DIR)/compiler-rt
