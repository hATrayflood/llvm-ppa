#!/bin/sh

# called by uscan with '--upstream-version' <version> <file>
DIR=llvm-$2
TAR=../llvm-$2_$2+dfsg.orig.tar.gz

# clean up the upstream tarball
tar zxvf $3
rm $DIR/cmake/modules/LLVMParseArguments.cmake
tar -c -z -f $TAR $DIR
rm -rf $DIR $3

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
    . .svn/deb-layout
    mv $TAR $origDir
    echo "moved $TAR to $origDir"
fi

exit 0

