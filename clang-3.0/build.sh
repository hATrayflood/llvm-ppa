#!/bin/bash

rm -f *.deb
rm -f clang-3.0_3.0-*
cd clang-3.0
debuild -uc -us
debuild -S  -sa
