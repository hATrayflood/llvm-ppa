#!/bin/bash

rm -f *.deb
rm -rf dh-exec_0.4-*
rm -rf dh-exec-0.4
tar zxf dh-exec_0.4.orig.tar.gz
patch -p0 -i dh-exec-0.4.diff
cd dh-exec-0.4
debuild -uc -us
debuild -S  -sa
