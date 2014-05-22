DIR = llvm-toolchain-3.4_3.4+208032
DEL = llvm-toolchain-3.4_3.4.1-*

include ../../build.mk

extract:
	tar jxf llvm-toolchain-3.4_3.4.1.orig.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.1.orig-clang.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.1.orig-clang-tools-extra.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.1.orig-compiler-rt.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.1.orig-lldb.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.1.orig-polly.tar.bz2
	mv             clang_3.4+208032 llvm-toolchain-3.4_3.4+208032/clang
	mv clang-tools-extra_3.4~+final llvm-toolchain-3.4_3.4+208032/clang-tools-extra
	mv       compiler-rt_3.4~+final llvm-toolchain-3.4_3.4+208032/compiler-rt
	mv              lldb_3.4~+final llvm-toolchain-3.4_3.4+208032/lldb
	mv             polly_3.4~+final llvm-toolchain-3.4_3.4+208032/polly
