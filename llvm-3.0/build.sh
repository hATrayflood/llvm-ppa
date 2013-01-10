#!/bin/bash

sudo apt-get -y install ocaml-nox
rm -f *.deb
rm -f llvm-3.0_3.0-*
cd llvm-3.0.src
debuild -uc -us
debuild -S  -sa
