#!/bin/bash

rm -f *.deb
rm -f clang-3.1_3.1-*
cd clang-3.1
debuild -uc -us
debuild -S  -sa
