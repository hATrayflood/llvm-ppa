DIR = llvm-toolchain-3.4_3.4+210930
DEL = llvm-toolchain-3.4_3.4.2-*

include ../../build.mk

extract:
	$(MAKE) -C ../../$(PKGNAME)
	tar jxf llvm-toolchain-3.4_3.4.2.orig.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.2.orig-clang.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.2.orig-clang-tools-extra.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.2.orig-compiler-rt.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.2.orig-lldb.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.2.orig-polly.tar.bz2
	rm -fr $(DIR)/clang
	rm -fr $(DIR)/clang-tools-extra
	rm -fr $(DIR)/compiler-rt
	rm -fr $(DIR)/lldb
	rm -fr $(DIR)/polly
	mv             clang_3.4+210930 $(DIR)/clang
	mv clang-tools-extra_3.4~+final $(DIR)/clang-tools-extra
	mv       compiler-rt_3.4~+final $(DIR)/compiler-rt
	mv              lldb_3.4~+final $(DIR)/lldb
	mv             polly_3.4~+final $(DIR)/polly
