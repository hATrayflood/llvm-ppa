#!/bin/sh

sudo sh << EOC
apt-get -y install meld
apt-get -y install python-nose
apt-get -y install devscripts
#apt-get -y install dh-make
apt-get -y install g++-4.6
apt-get -y install g++-4.7
apt-get -y install flex
apt-get -y install bison
apt-get -y install dejagnu
apt-get -y install tcl8.5
apt-get -y install autoconf
apt-get -y install automake1.9
apt-get -y install libtool
apt-get -y install doxygen
apt-get -y install chrpath
apt-get -y install texinfo
apt-get -y install quilt
apt-get -y install sharutils
apt-get -y install autotools-dev
apt-get -y install libffi-dev
apt-get -y install binutils-dev
apt-get -y install dh-ocaml
apt-get -y install python-sphinx
#apt-get -y install dh-autoreconf
#apt-get -y install libpipeline-dev
apt-get -y install binfmt-support
apt-get -y install swig
apt-get -y install libedit-dev
apt-get -y install libcloog-isl-dev
apt-get -y install libisl-dev
#apt-get -y install lcov
#apt-get -y install help2man
apt-get -y install libjsoncpp-dev
EOC
