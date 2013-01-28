#!/bin/bash

rm -f *.deb
rm -f llvm-2.9_2.9+dfsg-*
cd llvm-2.9
debuild -uc -us
debuild -S  -sa
