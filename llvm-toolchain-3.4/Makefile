DIR = llvm-toolchain-3.4_3.4~+final
DEL = llvm-toolchain-3.4_3.4-*

include ../build.mk

extract:
	tar jxf llvm-toolchain-3.4_3.4.orig.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.orig-clang.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.orig-clang-tools-extra.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.orig-compiler-rt.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.orig-lldb.tar.bz2
	tar jxf llvm-toolchain-3.4_3.4.orig-polly.tar.bz2
	mv             clang_3.4~+final llvm-toolchain-3.4_3.4~+final/clang
	mv clang-tools-extra_3.4~+final llvm-toolchain-3.4_3.4~+final/clang-tools-extra
	mv       compiler-rt_3.4~+final llvm-toolchain-3.4_3.4~+final/compiler-rt
	mv              lldb_3.4~+final llvm-toolchain-3.4_3.4~+final/lldb
	mv             polly_3.4~+final llvm-toolchain-3.4_3.4~+final/polly
