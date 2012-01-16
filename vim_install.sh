#!/bin/bash
DIRECTORY=~/vim-scripts
PLUGIN=$DIRECTORY/plugin
VIMRC=~/.vimrc
CSCOPE_PATH=$HOME/cscope

#Update address as needed
WGET_TAGLIST=http://www.vim.org/scripts/download_script.php?src_id=7701
WGET_PROJECT=http://www.vim.org/scripts/download_script.php?src_id=6273
WGET_ENH_COMMENT=http://www.vim.org/scripts/download_script.php?src_id=8319
WGET_SUPER_TAB=http://www.vim.org/scripts/download_script.php?src_id=16104
WGET_CSCOPE_MAPS=http://cscope.sourceforge.net/cscope_maps.vim

initial_setup () {
    echo "========================================================"
    echo " Installing vim"
    echo " vim vim-common vim-gnome vim-gui-common vim-runtime exuberant-ctags cscope"
    echo "========================================================"
    sudo apt-get -y install vim vim-common vim-gnome vim-gui-common vim-runtime exuberant-ctags cscope
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
        sudo mkdir "$1"
    fi
}

install_cscope_maps() {
    create_if_missing "$PLUGIN"
    cd "$PLUGIN"
    sudo wget -O cscope_maps.vim  $WGET_CSCOPE_MAPS
    cd
    cd $DIRECTORY
    sudo cp cscope_gen.sh /usr/bin
}

install_taglist (){
    cd /usr/src
    sudo wget -O taglist.zip $WGET_TAGLIST

    create_if_missing "$DIRECTORY"
    cd "$DIRECTORY"
    sudo unzip -u /usr/src/taglist.zip
}

install_project(){
    cd /usr/src
    sudo wget -O project.tar.gz $WGET_PROJECT

    create_if_missing "$DIRECTORY"
    cd "$DIRECTORY"
    sudo tar -xvzf /usr/src/project.tar.gz
}

install_enh_comment(){
    cd /usr/src
    sudo wget -O enh_comment.tar.gz $WGET_ENH_COMMENT

    create_if_missing "$DIRECTORY"
    cd "$DIRECTORY"
    sudo tar -xvzf /usr/src/enh_comment.tar.gz
    cd EnhancedCommentify-2.3
    sudo cp -r * $DIRECTORY
    cd $DIRECTORY
    sudo rm -r EnhancedCommentify-2.3/
}

install_super_tab() {
    cd /usr/src
    sudo wget -O supertab.vba $WGET_SUPER_TAB

    cd
    export user=$(whoami)
    sudo chown -R $user:$user vim-scripts
    sudo vim /usr/src/supertab.vba -c ":so %" -c ":q"
}

install_colortools() {
    cd
    cd $DIRECTORY
    sudo cp colorgcc /usr/bin
    sudo cp colorgccrc ~/.colorgccrc
    sudo cp color-logcat /usr/bin
    cd /usr/local/bin
    sudo ln -s /usr/bin/colorgcc gcc
    sudo ln -s /usr/bin/colorgcc g++
    sudo ln -s /usr/bin/colorgcc cc
    sudo ln -s /usr/bin/colorgcc c++
}

initial_setup
create_vimrc
install_taglist
install_project
install_enh_comment
install_super_tab
install_cscope_maps
install_colortools

echo "----------------------------------------------------"
echo "|                                                  |"
echo "|   Vim Install and configuration Complete         |"
echo "|                                                  |"
echo "----------------------------------------------------"
