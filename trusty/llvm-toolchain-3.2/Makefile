DIR = llvm-3.2.src
DEL = llvm-toolchain-3.2_3.2repack-*

include ../../build.mk

extract:
	$(MAKE) -C ../../$(PKGNAME)
	tar jxf llvm-toolchain-3.2_3.2repack.orig.tar.bz2
	tar jxf llvm-toolchain-3.2_3.2repack.orig-clang.tar.bz2
	tar jxf llvm-toolchain-3.2_3.2repack.orig-compiler-rt.tar.bz2
	tar jxf llvm-toolchain-3.2_3.2repack.orig-lldb.tar.bz2
	tar jxf llvm-toolchain-3.2_3.2repack.orig-polly.tar.bz2
	rm -fr $(DIR)/clang
	rm -fr $(DIR)/compiler-rt
	rm -fr $(DIR)/lldb
	rm -fr $(DIR)/polly
	mv       clang-3.2     $(DIR)/clang
	mv compiler-rt-3.2.src $(DIR)/compiler-rt
	mv        lldb-3.2     $(DIR)/lldb
	mv       polly-3.2.src $(DIR)/polly
