#!/bin/sh

sudo sh << EOC
apt-get -y install meld
apt-get -y install python-nose
apt-get -y install gnupg-agent
apt-get -y install devscripts
apt-get -y install dh-make
apt-get -y install flex
apt-get -y install bison
apt-get -y install dejagnu
apt-get -y install tcl
apt-get -y install automake1.9
apt-get -y install libtool
apt-get -y install doxygen
apt-get -y install chrpath
apt-get -y install texinfo
apt-get -y install sharutils
apt-get -y install libffi-dev
apt-get -y install binutils-dev
apt-get -y install dh-ocaml
apt-get -y install python-sphinx
EOC
