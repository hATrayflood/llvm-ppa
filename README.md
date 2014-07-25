LLVM/clang PPA
==============

Porting from [Debian LLVM Packages](http://qa.debian.org/developer.php?login=pkg-llvm-team@lists.alioth.debian.org) to Ubuntu LTS

**if you failed to upgrade, purge and re-install.**

provides
--------
    /usr/bin/clang-2.9
    /usr/bin/clang++-2.9
    /usr/bin/clang-3.0
    /usr/bin/clang++-3.0
    /usr/bin/clang-3.1
    /usr/bin/clang++-3.1
    /usr/bin/clang-3.2
    /usr/bin/clang++-3.2
    /usr/bin/clang-3.3
    /usr/bin/clang++-3.3
    /usr/bin/clang-3.4
    /usr/bin/clang++-3.4

usage
-----
    sudo add-apt-repository ppa:h-rayflood/llvm
    sudo apt-get update
    sudo apt-get dist-upgrade
    sudo apt-get install clang-2.9
    sudo apt-get install clang-3.0
    sudo apt-get install clang-3.1
    sudo apt-get install clang-3.2
    sudo apt-get install clang-3.3
    sudo apt-get install clang-3.4

upstream
--------
https://launchpad.net/debian/+source/clang  
https://launchpad.net/debian/+source/llvm-2.9  
https://launchpad.net/debian/+source/llvm-3.0  
https://launchpad.net/debian/+source/llvm-3.1  
https://launchpad.net/debian/+source/llvm-3.2  
https://launchpad.net/debian/+source/llvm-toolchain-3.2  
https://tracker.debian.org/pkg/llvm-toolchain-3.3  
https://tracker.debian.org/pkg/llvm-toolchain-3.4  

launchpad
---------
https://launchpad.net/~h-rayflood/+archive/llvm

github
------
https://github.com/hATrayflood/llvm-ppa
