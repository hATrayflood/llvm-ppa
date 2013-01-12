#!/bin/bash

sudo dpkg -i ../llvm-3.2/*.deb
rm -f *.deb
rm -f clang-3.2_3.2-*
cd clang-3.2
debuild -uc -us
debuild -S  -sa
