#!/bin/bash

rm -f *.deb
rm -f llvm-3.2_3.2-*
cd llvm-3.2.src
debuild -uc -us
debuild -S  -sa
