DIR = llvm-toolchain-3.6_3.6~+final
DEL = llvm-toolchain-3.6_3.6.1-*

include ../../build.mk

extract:
	$(MAKE) -C ../../$(PKGNAME)
	tar jxf llvm-toolchain-3.6_3.6.1.orig.tar.bz2
	tar jxf llvm-toolchain-3.6_3.6.1.orig-clang.tar.bz2
	tar jxf llvm-toolchain-3.6_3.6.1.orig-clang-tools-extra.tar.bz2
	tar jxf llvm-toolchain-3.6_3.6.1.orig-compiler-rt.tar.bz2
	tar jxf llvm-toolchain-3.6_3.6.1.orig-lldb.tar.bz2
	tar jxf llvm-toolchain-3.6_3.6.1.orig-polly.tar.bz2
	rm -fr $(DIR)/clang
	rm -fr $(DIR)/clang-tools-extra
	rm -fr $(DIR)/compiler-rt
	rm -fr $(DIR)/lldb
	rm -fr $(DIR)/polly
	mv             clang_3.6~+final $(DIR)/clang
	mv clang-tools-extra_3.6~+final $(DIR)/clang-tools-extra
	mv       compiler-rt_3.6~+final $(DIR)/compiler-rt
	mv              lldb_3.6~+final $(DIR)/lldb
	mv             polly_3.6~+final $(DIR)/polly
