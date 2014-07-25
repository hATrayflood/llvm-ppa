DIR = llvm-toolchain-snapshot_3.3~svn183554
DEL = llvm-toolchain-3.3_3.3-*

include ../../build.mk

extract:
	$(MAKE) -C ../../$(PKGNAME)
	tar jxf llvm-toolchain-3.3_3.3.orig.tar.bz2
	tar jxf llvm-toolchain-3.3_3.3.orig-clang.tar.bz2
	tar jxf llvm-toolchain-3.3_3.3.orig-clang-tools-extra.tar.bz2
	tar jxf llvm-toolchain-3.3_3.3.orig-compiler-rt.tar.bz2
	tar jxf llvm-toolchain-3.3_3.3.orig-lldb.tar.bz2
	tar jxf llvm-toolchain-3.3_3.3.orig-polly.tar.bz2
	rm -fr $(DIR)/clang
	rm -fr $(DIR)/clang-tools-extra
	rm -fr $(DIR)/compiler-rt
	rm -fr $(DIR)/lldb
	rm -fr $(DIR)/polly
	mv             clang_3.3~svn183554 $(DIR)/clang
	mv clang-tools-extra_3.3~svn183554 $(DIR)/clang-tools-extra
	mv       compiler-rt_3.3~svn183554 $(DIR)/compiler-rt
	mv              lldb_3.3~svn183554 $(DIR)/lldb
	mv             polly_3.3~svn183554 $(DIR)/polly
