#!/bin/bash

rm -f *.deb
rm -f llvm-3.1_3.1-*
cd llvm-3.1-3.1
debuild -uc -us
debuild -S  -sa
