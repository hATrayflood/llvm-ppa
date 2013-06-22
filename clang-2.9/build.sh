#!/bin/bash

rm -f *.deb
rm -f clang-2.9_2.9-*
cd clang-2.9
debuild -uc -us
debuild -S  -sa
