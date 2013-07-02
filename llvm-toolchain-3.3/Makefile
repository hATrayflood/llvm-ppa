DIR = llvm-toolchain-snapshot_3.3~svn183554
DEL = llvm-toolchain-3.3_3.3-*

include ../build.mk

extract:
	tar jxf llvm-toolchain-3.3_3.3.orig.tar.bz2
	tar jxf llvm-toolchain-3.3_3.3.orig-clang.tar.bz2
	tar jxf llvm-toolchain-3.3_3.3.orig-clang-tools-extra.tar.bz2
	tar jxf llvm-toolchain-3.3_3.3.orig-compiler-rt.tar.bz2
	tar jxf llvm-toolchain-3.3_3.3.orig-lldb.tar.bz2
	tar jxf llvm-toolchain-3.3_3.3.orig-polly.tar.bz2
	mv             clang_3.3~svn183554 llvm-toolchain-snapshot_3.3~svn183554/clang
	mv clang-tools-extra_3.3~svn183554 llvm-toolchain-snapshot_3.3~svn183554/clang-tools-extra
	mv       compiler-rt_3.3~svn183554 llvm-toolchain-snapshot_3.3~svn183554/compiler-rt
	mv              lldb_3.3~svn183554 llvm-toolchain-snapshot_3.3~svn183554/lldb
	mv             polly_3.3~svn183554 llvm-toolchain-snapshot_3.3~svn183554/polly
