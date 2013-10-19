#!/bin/sh

sudo sh << EOC
apt-get -y install patch
apt-get -y install xz-utils
apt-get -y install cvs
apt-get -y install subversion
apt-get -y install mercurial
apt-get -y install git
apt-get -y install yasm
apt-get -y install autoconf2.13
apt-get -y install flashplugin-installer

apt-get -y install libgnomevfs2-dev
apt-get -y install libnotify-dev
apt-get -y install libiw-dev
apt-get -y install libasound2-dev
apt-get -y install libcurl4-gnutls-dev
apt-get -y install mesa-common-dev
apt-get -y install python-dev
apt-get -y install default-jdk
apt-get -y install libgtk2.0-dev
apt-get -y install libdbus-glib-1-dev
apt-get -y install libidl-dev

apt-get -y install meld
apt-get -y install python-nose
apt-get -y install devscripts
apt-get -y install dh-make
apt-get -y install flex
apt-get -y install bison
apt-get -y install dejagnu
apt-get -y install tcl
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
apt-get -y install dh-autoreconf
apt-get -y install libpipeline-dev
apt-get -y install binfmt-support
apt-get -y install binutils-gold
apt-get -y install swig
apt-get -y install libedit-dev
apt-get -y install libcloog-isl-dev
apt-get -y install lcov
apt-get -y install help2man
apt-get -y install libjsoncpp-dev
EOC

make -C dh-exec extract
make -C dh-exec
sudo make -C dh-exec install
make -C dh-exec distclean
make -C isl extract
make -C isl
sudo make -C isl install
make -C isl distclean
