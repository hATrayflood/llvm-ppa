#!/bin/bash

sudo dpkg -i ../llvm-3.0/*.deb
rm -f *.deb
rm -f clang-3.0_3.0-*
cd clang-3.0
debuild -uc -us
debuild -S  -sa
