#!/bin/sh
# This script will create the following tarballs:
# llvm-toolchain-snapshot-3.2_3.2repack.orig-clang.tar.bz2
# llvm-toolchain-snapshot-3.2_3.2repack.orig-clang-extra.tar.bz2
# llvm-toolchain-snapshot-3.2_3.2repack.orig-compiler-rt.tar.bz2
# llvm-toolchain-snapshot-3.2_3.2repack.orig-lldb.tar.bz2
# llvm-toolchain-snapshot-3.2_3.2repack.orig-polly.tar.bz2
# llvm-toolchain-snapshot-3.2_3.2repack.orig.tar.bz2
set -e

SVN_BASE_URL=http://llvm.org/svn/llvm-project/

if test -n "$1"; then
# http://llvm.org/svn/llvm-project/{cfe,llvm,compiler-rt,...}/branches/google/stable/
    BRANCH=$1
fi

get_svn_url() {
    MODULE=$1
    BRANCH=$2
    if test -n "$BRANCH"; then
        SVN_URL="$SVN_BASE_URL/$MODULE/branches/$BRANCH"
    else
        SVN_URL="$SVN_BASE_URL/$MODULE/trunk/"
    fi
    echo $SVN_URL
}

get_higher_revision() {
    PROJECTS="llvm cfe compiler-rt polly lldb clang-tools-extra"
    REVISION_MAX=0
    for f in $PROJECTS; do
        REVISION=$(LANG=C svn info $(get_svn_url $f $BRANCH)|grep "^Last Changed Rev:"|awk '{print $4}')
        if test $REVISION -gt $REVISION_MAX; then
            REVISION_MAX=$REVISION
        fi
    done
    echo $REVISION_MAX
}



if test -n "$BRANCH"; then
    REVISION=$(get_higher_revision)
    # Do not use the revision when exporting branch. We consider that all the
    # branch are sync
    SVN_CMD="svn export"
else
    REVISION=$(LANG=C svn info $(get_svn_url llvm)|grep "^Revision:"|awk '{print $2}')
    SVN_CMD="svn export -r $REVISION"
fi

MAJOR_VERSION=3.3

# LLVM
LLVM_TARGET=llvm-toolchain-snapshot_$MAJOR_VERSION~svn$REVISION
$SVN_CMD $(get_svn_url llvm $BRANCH) $LLVM_TARGET
tar jcvf llvm-toolchain-snapshot_$MAJOR_VERSION~svn$REVISION.orig.tar.bz2 $LLVM_TARGET
rm -rf $LLVM_TARGET


# Clang
CLANG_TARGET=clang_$MAJOR_VERSION~svn$REVISION
$SVN_CMD $(get_svn_url cfe $BRANCH) $CLANG_TARGET
tar jcvf llvm-toolchain-snapshot_$MAJOR_VERSION~svn$REVISION.orig-clang.tar.bz2 $CLANG_TARGET
rm -rf $CLANG_TARGET


# Clang extra
CLANG_TARGET=clang-tools-extra_$MAJOR_VERSION~svn$REVISION
$SVN_CMD $(get_svn_url clang-tools-extra $BRANCH) $CLANG_TARGET
tar jcvf llvm-toolchain-snapshot_$MAJOR_VERSION~svn$REVISION.orig-clang-tools-extra.tar.bz2 $CLANG_TARGET
rm -rf $CLANG_TARGET

# Compiler-rt
COMPILER_RT_TARGET=compiler-rt_$MAJOR_VERSION~svn$REVISION
$SVN_CMD $(get_svn_url compiler-rt $BRANCH) $COMPILER_RT_TARGET
tar jcvf llvm-toolchain-snapshot_$MAJOR_VERSION~svn$REVISION.orig-compiler-rt.tar.bz2 $COMPILER_RT_TARGET
rm -rf $COMPILER_RT_TARGET

# Polly
POLLY_TARGET=polly_$MAJOR_VERSION~svn$REVISION
$SVN_CMD $(get_svn_url polly $BRANCH) $POLLY_TARGET
tar jcvf llvm-toolchain-snapshot_$MAJOR_VERSION~svn$REVISION.orig-polly.tar.bz2 $POLLY_TARGET
rm -rf $POLLY_TARGET

# LLDB
LLDB_TARGET=lldb_$MAJOR_VERSION~svn$REVISION
$SVN_CMD $(get_svn_url lldb $BRANCH) $LLDB_TARGET
tar jcvf llvm-toolchain-snapshot_$MAJOR_VERSION~svn$REVISION.orig-lldb.tar.bz2 $LLDB_TARGET
rm -rf $LLDB_TARGET

PATH_DEBIAN="$(pwd)/$(dirname $0)/../"
echo "going into $PATH_DEBIAN"
export DEBFULLNAME="Sylvestre Ledru"
export DEBEMAIL="sylvestre@debian.org"
cd $PATH_DEBIAN

if test -z "$DISTRIBUTION"; then
    DISTRIBUTION="experimental"
fi
dch --distribution $DISTRIBUTION --newversion 1:$MAJOR_VERSION~svn$REVISION-1~exp1 "New snapshot release"

exit 0
