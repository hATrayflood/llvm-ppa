DIR = llvm-3.2.src
DEL = llvm-toolchain-3.2_3.2repack-*

include ../../build.mk

extract:
	tar jxf llvm-toolchain-3.2_3.2repack.orig.tar.bz2
	tar jxf llvm-toolchain-3.2_3.2repack.orig-clang.tar.bz2
	tar jxf llvm-toolchain-3.2_3.2repack.orig-compiler-rt.tar.bz2
	tar jxf llvm-toolchain-3.2_3.2repack.orig-lldb.tar.bz2
	tar jxf llvm-toolchain-3.2_3.2repack.orig-polly.tar.bz2
	mv clang-3.2           llvm-3.2.src/clang
	mv compiler-rt-3.2.src llvm-3.2.src/compiler-rt
	mv lldb-3.2            llvm-3.2.src/lldb
	mv polly-3.2.src       llvm-3.2.src/polly
