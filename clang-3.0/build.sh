#!/bin/bash

sudo apt-get -y purge ocaml-nox
sudo dpkg -i ../llvm-3.0/llvm-3.0*.deb
rm -f *.deb
rm -f clang-3.0_3.0-*
cd clang-3.0
rm -rf .pc build-clang clang llvm-3.0.src tools
(cd .. && tar zxf clang-3.0_3.0.orig.tar.gz)
debuild -uc -us
rm -rf .pc build-clang clang llvm-3.0.src tools
(cd .. && tar zxf clang-3.0_3.0.orig.tar.gz)
debuild -S  -sa
