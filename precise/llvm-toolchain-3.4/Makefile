DIR = llvm-toolchain-3.4_3.4+210930
DEL = llvm-toolchain-3.4_3.4.2-*

include ../../build.mk

extract:
	tar jxf llvm-toolchain-3.4_3.4.2.orig.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.2.orig-clang.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.2.orig-clang-tools-extra.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.2.orig-compiler-rt.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.2.orig-lldb.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.2.orig-polly.tar.bz2
	mv             clang_3.4+210930 llvm-toolchain-3.4_3.4+210930/clang
	mv clang-tools-extra_3.4~+final llvm-toolchain-3.4_3.4+210930/clang-tools-extra
	mv       compiler-rt_3.4~+final llvm-toolchain-3.4_3.4+210930/compiler-rt
	mv              lldb_3.4~+final llvm-toolchain-3.4_3.4+210930/lldb
	mv             polly_3.4~+final llvm-toolchain-3.4_3.4+210930/polly
