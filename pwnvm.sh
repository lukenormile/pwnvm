#!/bin/bash

# Updates
sudo apt -y update
sudo apt -y upgrade

sudo apt -y install python3-pip
sudo apt -y install screen
sudo apt -y install gdb gdb-multiarch
sudo apt -y install unzip
sudo apt -y install build-essential
sudo apt -y install unrar
sudo apt -y install foremost
sudo apt -y install htop

# QEMU with MIPS/ARM - http://reverseengineering.stackexchange.com/questions/8829/cross-debugging-for-mips-elf-with-qemu-toolchain
sudo apt -y install qemu qemu-user qemu-user-static
sudo apt -y install 'binfmt*'
sudo apt -y install libc6-armhf-armel-cross
sudo apt -y install debian-keyring
sudo apt -y install debian-archive-keyring
sudo apt -y install emdebian-archive-keyring
tee /etc/apt/sources.list.d/emdebian.list << EOF
deb http://mirrors.mit.edu/debian squeeze main
deb http://www.emdebian.org/debian squeeze main
EOF
sudo apt -y install libc6-mipsel-cross
sudo apt -y install libc6-arm-cross
mkdir /etc/qemu-binfmt
ln -s /usr/mipsel-linux-gnu /etc/qemu-binfmt/mipsel
ln -s /usr/arm-linux-gnueabihf /etc/qemu-binfmt/arm
rm /etc/apt/sources.list.d/emdebian.list

# These are so the 64 bit vm can build 32 bit
sudo apt -y install libx32gcc-4.8-dev
sudo apt -y install libc6-dev-i386

# Install ARM binutils
sudo apt install binutils-arm-linux-gnueabi

# Install Pwntools
sudo apt -y install python3 python-pip python-dev git libssl-dev libffi-dev build-essential
sudo pip install --upgrade pip
sudo pip install --upgrade pwntools

cd
mkdir tools
cd tools

# Capstone 
sudo apt install libcapstone2
sudo pip3 install capstone

# pycparser for pwndbg
sudo pip3 install pycparser # Use pip3 for Python3

# Install radare2
git clone https://github.com/radare/radare2
pushd radare2
./sys/install.sh
popd

# Install binwalk
git clone https://github.com/devttys0/binwalk
pushd binwalk
sudo python3 setup.py install
popd

# Install Angr
sudo apt -y install python3-dev libffi-dev build-essential virtualenvwrapper
mkvirtualenv --python=$(which python3) angr && pip install angr

# oh-my-zsh
sudo apt -y install zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# tmux
sudo apt -y install tmux

# fzf
sudo apt install fzf

## GDB Tools
# Install pwndbg
git clone https://github.com/zachriggle/pwndbg
pushd pwndbg
./setup.sh
popd

# Splitmind for pwndbg
git clone https://github.com/jerdna-regeiz/splitmind

# fixenv
wget https://raw.githubusercontent.com/hellman/fixenv/master/r.sh
mv r.sh fixenv
chmod +x fixenv

# AFL Fuzzer
wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
tar -zxvf afl-latest.tgz
pushd afl-*
make && sudo make install
popd
rm afl-latest.tgz

# Enable 32bit binaries on 64bit host
sudo dpkg --add-architecture i386
sudo apt -y update
sudo apt -y upgrade
sudo apt -y install libc6:i386 libc6-dbg:i386 libncurses5:i386 libstdc++6:i386

# Install z3 theorem prover
git clone https://github.com/Z3Prover/z3.git 
pushd z3
python scripts/mk_make.py --python
pushd build
make && sudo make install
popd
popd

# Download ret-sync
git clone https://github.com/bootleg/ret-sync.git 

# Dotfiles
wget https://raw.githubusercontent.com/lukenormile/my-vimrc/master/.vimrc
wget https://raw.githubusercontent.com/lukenormile/my-tmux-conf/master/.tmux.conf
