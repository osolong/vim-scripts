#!/bin/bash
DIRECTORY=~/vim-scripts
PLUGIN=$DIRECTORY/plugin
VIMRC=~/.vimrc

# Updated if neccesary.
VUNDLE_URL=https://github.com/gmarik/vundle.git

check_if_sudo () {
	if [ ! -z "`env | grep "SUDO"`" ]; then
		echo "Error: Must be run without sudo"
		exit 50
	fi
}

initial_setup () {
    echo "========================================================"
    echo " Installing vim"
    echo " vim vim-common vim-gnome vim-gui-common vim-runtime exuberant-ctags cscope"
    echo "========================================================"
    sudo apt-get -y install vim vim-common vim-gnome vim-gui-common vim-runtime exuberant-ctags cscope libclang-dev git-core
    _r1="\/home\/$(whoami)\/vim-scripts\/cscope"
    sed -i "s/where_is_cscope/$_r1/g" vimrc
}

create_vimrc() {
    echo -e "set runtimepath=~/vim-scripts,\$VIMRUNTIME" > ~/.vimrc
    echo -e "source ~/vim-scripts/vimrc" >> ~/.vimrc
}

create_if_missing() {
    if [ ! -d "$1" ]; then
        echo "Creating $1 !!"
        sudo mkdir -d "$1"
    fi
}

install_cscope_maps() {
    cd
    cd $DIRECTORY
    sudo cp cscope_gen.sh /usr/bin
}

install_colortools() {
    cd
    cd $DIRECTORY
    sudo cp colorgcc /usr/bin
    sudo cp colorgccrc ~/.colorgccrc
    sudo cp color-logcat /usr/bin
    cd /usr/local/bin
    sudo ln -sf /usr/bin/colorgcc gcc
    sudo ln -sf /usr/bin/colorgcc g++
    sudo ln -sf /usr/bin/colorgcc cc
    sudo ln -sf /usr/bin/colorgcc c++
}

install_usbreset() {
	cd
	cd $DIRECTORY
	mkdir bin
	gcc usbreset.c -o bin/usbreset
	sudo cp usbreset /usr/bin
}

install_vundle() {
	cd
	cd $DIRECTORY
	git clone $VUNDLE_URL bundle/vundle
	vim +BundleInstall +qall
}

check_if_sudo
initial_setup
create_vimrc
install_usbreset
install_colortools
install_vundle
cd
sudo chown -R $user:$user vim-scripts
install_usbreset

echo "----------------------------------------------------"
echo "|                                                  |"
echo "|   Vim Install and configuration Complete         |"
echo "|                                                  |"
echo "----------------------------------------------------"
